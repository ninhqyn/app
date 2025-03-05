part of 'home_bloc.dart';

enum StatusFetched{
  initial,
  success,
  failure
}
@immutable
sealed class HomeState extends Equatable{}
final class HomeInitial extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
final class LoadedProduct extends HomeState {
  final List<ProductModel> productModels;
  final StatusFetched status;
  LoadedProduct ({
    this.productModels = const<ProductModel>[],
    this.status = StatusFetched.initial
  });
  LoadedProduct copyWith({
    List<ProductModel>? productModels,
    StatusFetched? status
}){
    return LoadedProduct(
        productModels: productModels ?? this.productModels,
        status: status ?? this.status
    );
}
  @override
  // TODO: implement props
  List<Object?> get props => [productModels,status];
}
final class Loading extends HomeState{
  @override
  // TODO: implement props
  List<Object?> get props => [];
}