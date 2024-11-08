import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/create_post_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/create_post_state.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_state.dart';

class CreatePostPage extends StatefulWidget {
  const CreatePostPage({super.key});

  @override
  State<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends State<CreatePostPage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => CreatePostCubit(
        usersRepository: context.read<CreatePostCubit>().usersRepository,
      )..loadUsers(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Crear Post'),
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostUsersError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.message)),
              );
            }
          },
          builder: (context, state) {
            if (state is CreatePostLoadingUsers) {
              return const Center(child: CircularProgressIndicator());
            }

            if (state is CreatePostUsersLoaded) {
              return SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      DropdownButtonFormField<User>(
                        value: state.selectedUser,
                        decoration: const InputDecoration(
                          labelText: 'Selecciona un usuario',
                          border: OutlineInputBorder(),
                        ),
                        items: state.users.map((User user) {
                          return DropdownMenuItem<User>(
                            value: user,
                            child: Text(user.name),
                          );
                        }).toList(),
                        onChanged: (User? user) {
                          if (user != null) {
                            context.read<CreatePostCubit>().selectUser(user);
                          }
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Selecciona un usuario';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _titleController,
                        decoration: const InputDecoration(
                          labelText: 'Título',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el título';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _bodyController,
                        decoration: const InputDecoration(
                          labelText: 'Contenido',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Ingresa el contenido';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      BlocBuilder<PostsCubit, PostsState>(
                        builder: (context, postsState) {
                          return ElevatedButton(
                            onPressed: postsState is PostsLoading
                                ? null
                                : () {
                                    if (_formKey.currentState?.validate() ??
                                        false) {
                                      context.read<PostsCubit>().submitPost(
                                            title: _titleController.text,
                                            body: _bodyController.text,
                                            userId: state.selectedUser!.id,
                                          );
                                    }
                                  },
                            child: postsState is PostsLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                        strokeWidth: 2),
                                  )
                                : const Text('Crear Post'),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            }

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  }
}
