import 'package:cart_repository/src/cart_api/cart_api_client.dart';
import 'package:cart_repository/src/models/models.dart';

class CartRepository{

  final CartApiClient cartApiClient;

  CartRepository({required this.cartApiClient});
  void dispose(){
    cartApiClient.dispose();
  }
  Future<List<CartResponse>> getAllCartItem(String accessToken) async{
    // try{
      final results = await cartApiClient.getAllCartItem(accessToken);
      return results;
    //  }catch(e){
    //
    //   throw Exception('Cart repository:$e');
    // }
  }
  Future<bool> addToCart(int variantId,String accessToken) async{
    try{
      print('add to cart repo');
      return await cartApiClient.addToCart(variantId, accessToken);

    }catch(e){
      throw Exception('add fail : $e');
    }
  }

  Future<int?> getVariantId(int colorId,int sizeId,int productId) async{
    try{
      return await cartApiClient.getVariantId(colorId: colorId, sizeId: sizeId, productId: productId);
    }catch (e){
      throw Exception(e);
    }
  }
  Future<bool> removeCartItem(int itemId,String accessToken) async{
    // try{
      return await cartApiClient.removeCartItem(itemId,accessToken);
    // }catch(e){
    //   throw Exception('remove fail : $e');
    // }
  }
  Future<bool> updateQuantity({required int itemId,required int quantity, required String accessToken}) async{
    try{
      return await cartApiClient.updateQuantity(itemId: itemId, quantity: quantity, accessToken: accessToken);
    }catch(e){
      throw Exception('update quantity fail : $e');
    }
  }
}