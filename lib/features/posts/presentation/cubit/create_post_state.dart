import 'package:equatable/equatable.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';

abstract class CreatePostState extends Equatable {
  const CreatePostState();

  @override
  List<Object?> get props => [];
}

class CreatePostInitial extends CreatePostState {}

class CreatePostLoadingUsers extends CreatePostState {}

class CreatePostUsersLoaded extends CreatePostState {
  final List<User> users;
  final User? selectedUser;

  const CreatePostUsersLoaded({
    required this.users,
    this.selectedUser,
  });

  @override
  List<Object?> get props => [users, selectedUser];

  CreatePostUsersLoaded copyWith({
    List<User>? users,
    User? selectedUser,
  }) {
    return CreatePostUsersLoaded(
      users: users ?? this.users,
      selectedUser: selectedUser ?? this.selectedUser,
    );
  }
}

class CreatePostUsersError extends CreatePostState {
  final String message;

  const CreatePostUsersError(this.message);

  @override
  List<Object> get props => [message];
}
