import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/features/posts/posts_module.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_state.dart';
import 'package:fudo_challenge/features/posts/presentation/widgets/post_card.dart';
import 'package:fudo_challenge/features/posts/presentation/widgets/search_bar.dart';

class PostsPage extends StatelessWidget {
  const PostsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Posts'),
      ),
      body: BlocListener<PostsCubit, PostsState>(
        listener: (context, state) {
          if (state is PostCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('¡Post creado!')),
            );
            context.read<PostsCubit>().loadPosts();
            Navigator.of(context).pop();
          }
          if (state is PostsError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: Column(
          children: [
            const PostsSearchBar(),
            Expanded(
              child: BlocBuilder<PostsCubit, PostsState>(
                builder: (context, state) {
                  if (state is PostsInitial) {
                    context.read<PostsCubit>().loadPosts();
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PostsLoading && state.isFirstFetch) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  if (state is PostsLoaded) {
                    if (state.posts.isEmpty) {
                      return const Center(
                        child: Text('No se encontraron posts'),
                      );
                    }

                    return RefreshIndicator(
                      onRefresh: () => context.read<PostsCubit>().loadPosts(),
                      child: ListView.builder(
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: state.posts.length,
                        itemBuilder: (context, index) => PostCard(
                          post: state.posts[index],
                        ),
                      ),
                    );
                  }

                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.pushNamed(context, PostsModule.createPost),
        child: const Icon(Icons.add),
      ),
    );
  }
}
