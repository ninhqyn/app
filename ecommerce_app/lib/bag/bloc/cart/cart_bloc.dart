import 'package:authentication_repository/authentication_repository.dart';
import 'package:bloc/bloc.dart';
import 'package:cart_repository/cart_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:product_repository/product_repository.dart';

part 'cart_event.dart';
part 'cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {

  final AuthenticationRepository authenticationRepository;
  final CartRepository cartRepository;
  final ProductRepository productRepository;
  CartBloc({
    required this.authenticationRepository,
    required this.cartRepository,
    required this.productRepository
  }) : super(CartInitial()) {
    on<LoadedCart>(_onLoadedCart);
    on<UpdateQuantity>(_onUpdateQuantity);
    on<AddToCart>(_onAddToCart);

  }
  Future<void> _onAddToCart(AddToCart event,Emitter<CartState> emit) async{
    final tokenModel = await authenticationRepository.getTokenModel();
    final variantId = await cartRepository.getVariantId(event.colorId,event.sizeId,event.productId);
    if(variantId == null){
      return ;
    }
    final result = await cartRepository.addToCart(variantId, tokenModel.accessToken);
    if(result){
      emit(CartAddedToCart(productName: event.productName));
      final cartItems = await cartRepository.getAllCartItem(tokenModel.accessToken);
      emit(CartInitial(cartItems: cartItems));
    }else{
      emit(FailToAddToCart());
      final cartItems = await cartRepository.getAllCartItem(tokenModel.accessToken);
      emit(CartInitial(cartItems: cartItems));

    }

    if(state is CartInitial){
      final currentState = state as CartInitial;
      double totalAmount = 0;
      for(int i=0;i<currentState.cartItems.length;i++){
        totalAmount = totalAmount + currentState.cartItems[i].price*currentState.cartItems[i].quantity;
      }
      emit(currentState.copyWith(totalAmount: totalAmount));
    }
  }
  Future<void> _onUpdateQuantity(UpdateQuantity event,Emitter<CartState> emit) async{
    print('minus');
    int quantity = event.currentQuantity;
    if(event.add){
      quantity=quantity+1;
    }else{
      quantity = quantity-1;
    }
    final tokenModel = await authenticationRepository.getTokenModel();
    final result = await cartRepository.updateQuantity(itemId:event.itemId,quantity:quantity,accessToken:  tokenModel.accessToken);
    if(result){
      final cartItems = await cartRepository.getAllCartItem(tokenModel.accessToken);
      emit(CartInitial(cartItems: cartItems));
      if(state is CartInitial){
        final currentState = state as CartInitial;
        double totalAmount = 0;
        for(int i=0;i<currentState.cartItems.length;i++){
          totalAmount = totalAmount + currentState.cartItems[i].price*currentState.cartItems[i].quantity;
        }
        emit(currentState.copyWith(totalAmount: totalAmount));
      }
    }
  }
  Future<void> _onLoadedCart(LoadedCart event,Emitter<CartState> emit) async{
    emit(CartLoading());
      final tokenModel = await authenticationRepository.getTokenModel();
      final cartItems = await cartRepository.getAllCartItem(tokenModel.accessToken);
      emit(CartInitial(cartItems: cartItems));
      if(state is CartInitial){
        final currentState = state as CartInitial;
        double totalAmount = 0;
        for(int i=0;i<currentState.cartItems.length;i++){
          totalAmount = totalAmount + currentState.cartItems[i].price*currentState.cartItems[i].quantity;
        }
        emit(currentState.copyWith(totalAmount: totalAmount));
      }
  }
}
