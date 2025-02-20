import 'package:equatable/equatable.dart';

class Category extends Equatable{
  final int id;
  final String name;

  const Category(this.id,this.name);

  @override
  // TODO: implement props
  List<Object?> get props => [id,name];
}