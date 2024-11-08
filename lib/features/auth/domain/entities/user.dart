import 'package:equatable/equatable.dart';

class User extends Equatable {
  final bool isAuthenticated;

  const User({required this.isAuthenticated});

  @override
  List<Object> get props => [isAuthenticated];
}
