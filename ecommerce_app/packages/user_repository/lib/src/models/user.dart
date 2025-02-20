import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User(this.id,this.username,this.password);
  final String username;
  final String password;
  final String id;

  @override
  List<Object> get props => [id,username,password];

  static const empty = User('-','-','-');
}