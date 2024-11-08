import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';

abstract class PostsRepository {
  Future<Either<Failure, List<Post>>> getPosts();
  Future<Either<Failure, List<Post>>> getPostsByUser(int userId);
  Future<Either<Failure, Post>> createPost(String title, String body, int userId);
}