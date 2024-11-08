import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';

class CreatePostParams extends Equatable {
  final String title;
  final String body;
  final int userId;

  const CreatePostParams({
    required this.title,
    required this.body,
    required this.userId,
  });

  @override
  List<Object> get props => [title, body, userId];
}

class CreatePost implements UseCase<Post, CreatePostParams> {
  final PostsRepository repository;

  CreatePost(this.repository);

  @override
  Future<Either<Failure, Post>> call(CreatePostParams params) {
    return repository.createPost(params.title, params.body, params.userId);
  }
}
