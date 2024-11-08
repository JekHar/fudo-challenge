import 'package:flutter/material.dart';
import 'package:fudo_challenge/core/interfaces/module.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_local_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/posts_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_local_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/data/repositories/posts_repository_impl.dart';
import 'package:fudo_challenge/features/posts/data/repositories/users_repository_impl.dart';
import 'package:fudo_challenge/features/posts/domain/repositories/posts_repository.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/create_post.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts_by_user.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/create_post_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/pages/create_post_page.dart';
import 'package:fudo_challenge/features/posts/presentation/pages/posts_page.dart';
import 'package:get_it/get_it.dart';

class PostsModule extends Module {
  static const String posts = '/posts';
  static const String createPost = '/posts/create';

  @override
  Map<String, WidgetBuilder> generateRoutes() {
    return {
      posts: (_) => const PostsPage(),
      createPost: (_) => const CreatePostPage(),
    };
  }

  @override
  void registerDependencies(GetIt injector) {
    injector.registerLazySingleton<PostsRemoteDataSource>(
      () => PostsRemoteDataSourceImpl(client: injector()),
    );

    injector.registerLazySingleton<PostsLocalDataSource>(
      () => PostsLocalDataSourceImpl(localStorage: injector()),
    );

    injector.registerLazySingleton(
      () => UsersLocalDataSource(localStorage: injector()),
    );

    injector.registerLazySingleton(
      () => UsersRepository(
        remoteDataSource: injector(),
        localDataSource: injector(),
        networkInfo: injector(),
      ),
    );

    injector.registerLazySingleton<PostsRepository>(
      () => PostsRepositoryImpl(
        remoteDataSource: injector(),
        localDataSource: injector(),
        networkInfo: injector(),
      ),
    );

    injector.registerLazySingleton(() => GetPosts(injector()));
    injector.registerLazySingleton(() => GetPostsByUser(injector()));
    injector.registerLazySingleton(() => CreatePost(injector()));

    injector.registerLazySingleton(
      () => UsersRemoteDataSource(client: injector()),
    );

    injector.registerFactory(
      () => PostsCubit(
        getPosts: injector(),
        getPostsByUser: injector(),
        createPost: injector(),
        usersRepository: injector(),
      ),
    );

    injector.registerFactory(
      () => CreatePostCubit(
        usersRepository: injector(),
      ),
    );
  }
}
