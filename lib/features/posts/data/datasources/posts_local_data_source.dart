import 'dart:convert';

import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:fudo_challenge/features/posts/data/models/post_model.dart';

abstract class PostsLocalDataSource {
  Future<void> cachePosts(List<PostModel> posts);
  Future<List<PostModel>> getCachedPosts();
}

class PostsLocalDataSourceImpl implements PostsLocalDataSource {
  static const cachedPostsKey = 'CACHED_POSTS';
  final LocalStorage localStorage;

  PostsLocalDataSourceImpl({required this.localStorage});

  @override
  Future<void> cachePosts(List<PostModel> posts) async {
    try {
      final currentCachedString = await localStorage.getString(cachedPostsKey);
      List<PostModel> allPosts = [];

      if (currentCachedString != null) {
        final List<dynamic> currentCached = json.decode(currentCachedString);
        final currentPosts = currentCached
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
        allPosts = [...currentPosts];
      }

      for (var post in posts) {
        final index = allPosts.indexWhere((p) => p.id == post.id);
        if (index >= 0) {
          allPosts[index] = post;
        } else {
          allPosts.add(post);
        }
      }

      final String jsonString = json.encode(
        allPosts.map((post) => post.toJson()).toList(),
      );
      await localStorage.saveString(cachedPostsKey, jsonString);
    } catch (_) {
      throw CacheException();
    }
  }

  @override
  Future<List<PostModel>> getCachedPosts() async {
    try {
      final jsonString = await localStorage.getString(cachedPostsKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList
            .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
            .toList();
      }
      throw CacheException();
    } catch (_) {
      throw CacheException();
    }
  }
}
