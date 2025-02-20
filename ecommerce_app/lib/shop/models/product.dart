import 'package:equatable/equatable.dart';

class Product extends Equatable{
  final int id;
  final String name;

  const Product(this.id,this.name);

  @override
  // TODO: implement props
  List<Object?> get props => [id,name];
}