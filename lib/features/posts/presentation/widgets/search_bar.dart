import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';

import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';

class PostsSearchBar extends StatefulWidget {
  const PostsSearchBar({super.key});

  @override
  State<PostsSearchBar> createState() => _PostsSearchBarState();
}

class _PostsSearchBarState extends State<PostsSearchBar> {
  Timer? _debounce;

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query, BuildContext context) {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      context.read<PostsCubit>().searchByUserName(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextField(
        decoration: const InputDecoration(
          labelText: 'Buscar posts por usuario',
          border: OutlineInputBorder(),
          prefixIcon: Icon(Icons.search),
          hintText: 'Ejemplo: Leanne',
        ),
        onChanged: (value) => _onSearchChanged(value, context),
      ),
    );
  }
}
