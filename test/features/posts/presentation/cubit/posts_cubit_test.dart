import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/features/posts/data/repositories/users_repository_impl.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts_by_user.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/create_post.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_state.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'posts_cubit_test.mocks.dart';

@GenerateMocks([GetPosts, GetPostsByUser, CreatePost, UsersRepository])
void main() {
  late PostsCubit cubit;
  late MockGetPosts mockGetPosts;
  late MockGetPostsByUser mockGetPostsByUser;
  late MockCreatePost mockCreatePost;
  late MockUsersRepository mockUsersRepository;

  setUp(() {
    mockGetPosts = MockGetPosts();
    mockGetPostsByUser = MockGetPostsByUser();
    mockCreatePost = MockCreatePost();
    mockUsersRepository = MockUsersRepository();
    cubit = PostsCubit(
      getPosts: mockGetPosts,
      getPostsByUser: mockGetPostsByUser,
      createPost: mockCreatePost,
      usersRepository: mockUsersRepository,
    );
  });

  final tPosts = [
    const Post(id: 1, title: 'test title', body: 'test body', userId: 1),
  ];

  blocTest<PostsCubit, PostsState>(
    'emits [PostsLoading, PostsLoaded] when loadPosts is successful',
    build: () {
      when(mockGetPosts(any)).thenAnswer((_) async => Right(tPosts));
      return cubit;
    },
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      const PostsLoading(),
      PostsLoaded(tPosts),
    ],
  );

  blocTest<PostsCubit, PostsState>(
    'emits [PostsLoading, PostsError] when loadPosts fails',
    build: () {
      when(mockGetPosts(any)).thenAnswer((_) async => Left(ServerFailure()));
      return cubit;
    },
    act: (cubit) => cubit.loadPosts(),
    expect: () => [
      const PostsLoading(),
      const PostsError('Error del servidor'),
    ],
  );
}
