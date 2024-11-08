import 'package:equatable/equatable.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';

abstract class PostsState extends Equatable {
  const PostsState();

  @override
  List<Object> get props => [];
}

class PostsInitial extends PostsState {}

class PostsLoading extends PostsState {
  final bool isFirstFetch;

  const PostsLoading({this.isFirstFetch = true});

  @override
  List<Object> get props => [isFirstFetch];
}

class PostsLoaded extends PostsState {
  final List<Post> posts;

  const PostsLoaded(this.posts);

  @override
  List<Object> get props => [posts];
}

class PostCreated extends PostsState {
  final Post post;

  const PostCreated(this.post);

  @override
  List<Object> get props => [post];
}

class PostsError extends PostsState {
  final String message;

  const PostsError(this.message);

  @override
  List<Object> get props => [message];
}
