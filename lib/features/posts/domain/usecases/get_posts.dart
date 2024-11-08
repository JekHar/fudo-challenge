import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';

class GetPosts implements UseCase<List<Post>, NoParams> {
  final PostsRepository repository;

  GetPosts(this.repository);

  @override
  Future<Either<Failure, List<Post>>> call(NoParams params) {
    return repository.getPosts();
  }
}
