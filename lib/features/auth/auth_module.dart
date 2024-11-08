import 'package:flutter/material.dart';
import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:fudo_challenge/core/interfaces/module.dart';
import 'package:fudo_challenge/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fudo_challenge/features/auth/domain/repositories/auth_repository.dart';
import 'package:fudo_challenge/features/auth/domain/usecases/login.dart';
import 'package:fudo_challenge/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:fudo_challenge/features/auth/presentation/pages/login_page.dart';
import 'package:get_it/get_it.dart';

class AuthModule extends Module {
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgotPassword';

  @override
  Map<String, WidgetBuilder> generateRoutes() {
    return {
      login: (context) => const LoginPage(),
    };
  }

  @override
  void registerDependencies(GetIt injector) {
    injector
      ..registerFactory(() => AuthCubit(loginUseCase: injector()))
      ..registerLazySingleton(() => Login(injector()))
      ..registerLazySingleton<AuthRepository>(
        () => AuthRepositoryImpl(networkInfo: injector(), localStorage: injector<LocalStorage>()),
      );
  }
}
