import 'package:dartz/dartz.dart';
import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/interfaces/network_info.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';

class PostsRepositoryImpl implements PostsRepository {
  final PostsRemoteDataSource remoteDataSource;
  final PostsLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  PostsRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<Post>>> getPosts() async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPosts();
        await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      try {
        final localPosts = await localDataSource.getCachedPosts();
        return Right(localPosts);
      } on CacheException {
        return Left(CacheFailure());
      }
    }
  }

  @override
  Future<Either<Failure, List<Post>>> getPostsByUser(int userId) async {
    if (await networkInfo.isConnected) {
      try {
        final remotePosts = await remoteDataSource.getPostsByUserId(userId);
        await localDataSource.cachePosts(remotePosts);
        return Right(remotePosts);
      } on ServerException {
        return Left(ServerFailure());
      }
    }

    try {
      final localPosts = await localDataSource.getCachedPosts();
      final userPosts =
          localPosts.where((post) => post.userId == userId).toList();
      return Right(userPosts);
    } on CacheException {
      return Left(CacheFailure());
    }
  }

  @override
  Future<Either<Failure, Post>> createPost(
    String title,
    String body,
    int userId,
  ) async {
    if (await networkInfo.isConnected) {
      try {
        final post = await remoteDataSource.createPost(title, body, userId);
        return Right(post);
      } on ServerException {
        return Left(ServerFailure());
      }
    } else {
      return Left(NetworkFailure());
    }
  }
}
