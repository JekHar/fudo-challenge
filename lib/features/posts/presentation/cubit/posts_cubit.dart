import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/error/failures.dart';
import 'package:fudo_challenge/core/usecases/usecase.dart';
import 'package:fudo_challenge/features/posts/data/repositories/users_repository_impl.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/create_post.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts.dart';
import 'package:fudo_challenge/features/posts/domain/usecases/get_posts_by_user.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_state.dart';

class PostsCubit extends Cubit<PostsState> {
  final GetPosts getPosts;
  final GetPostsByUser getPostsByUser;
  final CreatePost createPost;
  final UsersRepository usersRepository;

  PostsCubit({
    required this.getPosts,
    required this.getPostsByUser,
    required this.createPost,
    required this.usersRepository,
  }) : super(PostsInitial());

  Future<void> loadPosts() async {
    emit(const PostsLoading());
    final failureOrPosts = await getPosts(NoParams());
    emit(failureOrPosts.fold(
      (failure) => PostsError(_mapFailureToMessage(failure)),
      (posts) => PostsLoaded(posts),
    ));
  }

  Future<void> submitPost({
    required String title,
    required String body,
    required int userId,
  }) async {
    emit(const PostsLoading(isFirstFetch: false));
    final failureOrPost = await createPost(
      CreatePostParams(
        title: title,
        body: body,
        userId: userId,
      ),
    );
    emit(failureOrPost.fold(
      (failure) => PostsError(_mapFailureToMessage(failure)),
      (post) => PostCreated(post),
    ));
  }

  Future<void> searchByUserName(String userName) async {
    if (userName.isEmpty) {
      return loadPosts();
    }

    emit(const PostsLoading(isFirstFetch: false));
    try {
      final users = await usersRepository.getUsers();
      final user = users.firstWhere(
        (user) => user.name.toLowerCase().contains(userName.toLowerCase()),
        orElse: () => throw const UserNotFoundException(),
      );

      final failureOrPosts = await getPostsByUser(user.id);

      emit(failureOrPosts.fold(
        (failure) {
          if (failure is NetworkFailure) {
            return const PostsError(
                'Sin conexión. Mostrando resultados almacenados.');
          }
          return PostsError(_mapFailureToMessage(failure));
        },
        (posts) => PostsLoaded(posts),
      ));
    } on UserNotFoundException {
      emit(const PostsError('Usuario no encontrado'));
    } catch (e) {
      emit(const PostsError('Error al buscar usuario'));
    }
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure():
        return 'Error del servidor';
      case CacheFailure():
        return 'Error de caché';
      case NetworkFailure():
        return 'Sin conexión a Internet';
      default:
        return 'Error inesperado';
    }
  }
}
