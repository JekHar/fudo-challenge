
import 'package:fudo_challenge/features/auth/domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.isAuthenticated,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      isAuthenticated: json['isAuthenticated'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAuthenticated': isAuthenticated,
    };
  }
}
