import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/data/repositories/users_repository_impl.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/create_post_state.dart';

class CreatePostCubit extends Cubit<CreatePostState> {
  final UsersRepository usersRepository;

  CreatePostCubit({
    required this.usersRepository,
  }) : super(CreatePostInitial());

  Future<void> loadUsers() async {
    emit(CreatePostLoadingUsers());
    try {
      final users = await usersRepository.getUsers();
      emit(CreatePostUsersLoaded(users: users));
    } catch (_) {
      emit(const CreatePostUsersError('Error loading users'));
    }
  }

  void selectUser(User user) {
    if (state is CreatePostUsersLoaded) {
      final currentState = state as CreatePostUsersLoaded;
      emit(currentState.copyWith(selectedUser: user));
    }
  }
}
