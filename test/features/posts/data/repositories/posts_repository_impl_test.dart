import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_challenge/core/interfaces/network_info.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/data/models/post_model.dart';
import 'package:fudo_challenge/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'posts_repository_impl_test.mocks.dart';

@GenerateMocks([
  PostsRemoteDataSource,
  PostsLocalDataSource,
  NetworkInfo,
])
void main() {
  late PostsRepositoryImpl repository;
  late MockPostsRemoteDataSource mockRemoteDataSource;
  late MockPostsLocalDataSource mockLocalDataSource;
  late MockNetworkInfo mockNetworkInfo;

  setUp(() {
    mockRemoteDataSource = MockPostsRemoteDataSource();
    mockLocalDataSource = MockPostsLocalDataSource();
    mockNetworkInfo = MockNetworkInfo();
    repository = PostsRepositoryImpl(
      remoteDataSource: mockRemoteDataSource,
      localDataSource: mockLocalDataSource,
      networkInfo: mockNetworkInfo,
    );
  });

  group('getPosts', () {
    final tPostModels = [
      const PostModel(id: 1, title: 'test title', body: 'test body', userId: 1),
    ];
    final tPosts = tPostModels;

    test(
      'should return remote data when the call to remote data source is successful',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => true);
        when(mockRemoteDataSource.getPosts())
            .thenAnswer((_) async => tPostModels);

        final result = await repository.getPosts();

        verify(mockRemoteDataSource.getPosts());
        expect(result, equals(Right(tPosts)));
      },
    );

    test(
      'should return cached data when the device is offline',
      () async {
        when(mockNetworkInfo.isConnected).thenAnswer((_) async => false);
        when(mockLocalDataSource.getCachedPosts())
            .thenAnswer((_) async => tPostModels);
            
        final result = await repository.getPosts();
        
        verify(mockLocalDataSource.getCachedPosts());
        expect(result, equals(Right(tPosts)));
      },
    );
  });
}
