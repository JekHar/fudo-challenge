import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/features/auth/domain/entities/user.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> login(String email, String password);
  Future<Either<Failure, void>> logout();
}
