import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:fudo_challenge/core/interfaces/network_info.dart';
import 'package:fudo_challenge/features/auth/data/models/user_model.dart';
import 'package:fudo_challenge/features/auth/domain/entities/user.dart';
import 'package:fudo_challenge/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final NetworkInfo networkInfo;
  final LocalStorage localStorage;
  static const String useCacheKey = 'CACHED_USER';

  AuthRepositoryImpl({
    required this.networkInfo,
    required this.localStorage,
  });

  @override
  Future<Either<Failure, User>> login(String email, String password) async {
    if (await networkInfo.isConnected) {
      try {
        if (email == 'challenge@fudo' && password == 'password') {
          const user = UserModel(isAuthenticated: true);
          await _cacheUser(user);
          return const Right(user);
        } else {
          return Left(AuthFailure());
        }
      } catch (_) {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await localStorage.remove(useCacheKey);
      return const Right(null);
    } catch (_) {
      return Left(CacheFailure());
    }
  }

  Future<void> _cacheUser(UserModel user) async {
    await localStorage.saveString(
      useCacheKey,
      user.toJson().toString(),
    );
  }
}
