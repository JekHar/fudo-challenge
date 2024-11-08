import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetPostsByUser implements UseCase<List<Post>, int> {
  final PostsRepository repository;

  GetPostsByUser(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(int userId) {
    return repository.getPostsByUser(userId);
  }
}
