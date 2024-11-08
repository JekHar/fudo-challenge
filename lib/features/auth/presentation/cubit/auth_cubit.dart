import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/features/auth/domain/usecases/login.dart';
import 'package:fudo_challenge/features/auth/presentation/cubit/auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final Login loginUseCase;

  AuthCubit({required this.loginUseCase}) : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());

    final result =
        await loginUseCase(LoginParams(email: email, password: password));

    emit(result.fold(
      (failure) => AuthError(message: _mapFailureToMessage(failure)),
      (user) => AuthSuccess(user),
    ));
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case AuthFailure _:
        return 'Credenciales inválidas';
      case NetworkFailure _:
        return 'Sin conexión a internet';
      default:
        return 'Error inesperado';
    }
  }
}
