import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/auth/domain/entities/user.dart';
import 'package:fudo_challenge/features/auth/domain/repositories/auth_repository.dart';

class LoginParams {
  final String email;
  final String password;

  const LoginParams({required this.email, required this.password});
}

class Login implements UseCase<User, LoginParams> {
  final AuthRepository repository;

  Login(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginParams params) {
    return repository.login(params.email, params.password);
  }
}
