import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'get_posts_test.mocks.dart';

@GenerateMocks([PostsRepository])
void main() {
  late GetPosts usecase;
  late MockPostsRepository mockPostsRepository;

  setUp(() {
    mockPostsRepository = MockPostsRepository();
    usecase = GetPosts(mockPostsRepository);
  });

  final tPosts = [
    const Post(id: 1, title: 'test title', body: 'test body', userId: 1),
  ];

  test('should get posts from repository', () async {
    when(mockPostsRepository.getPosts()).thenAnswer((_) async => Right(tPosts));

    final result = await usecase(NoParams());
    
    expect(result, Right(tPosts));
    verify(mockPostsRepository.getPosts());
    verifyNoMoreInteractions(mockPostsRepository);
  });
}
