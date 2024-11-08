import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/interfaces/http_client.dart';
import 'package:fudo_challenge/features/posts/data/models/post_model.dart';
import 'package:fudo_challenge/features/posts/domain/entities/post.dart';

abstract class PostsRemoteDataSource {
  Future<List<PostModel>> getPosts();
  Future<List<PostModel>> getPostsByUserId(int userId);
  Future<Post> createPost(String title, String body, int userId);
}

class PostsRemoteDataSourceImpl implements PostsRemoteDataSource {
  final HttpClient client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  PostsRemoteDataSourceImpl({required this.client});

  @override
  Future<List<PostModel>> getPosts() async {
    final response = await client.get('$baseUrl/posts');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<PostModel>> getPostsByUserId(int userId) async {
    final response = await client.get('$baseUrl/posts?userId=$userId');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => PostModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Post> createPost(String title, String body, int userId) async {
    final response = await client.post(
      '$baseUrl/posts',
      body: {
        'title': title,
        'body': body,
        'userId': userId,
      },
    );

    if (response.statusCode == 201) {
      return PostModel.fromJson(response.data as Map<String, dynamic>);
    } else {
      throw ServerException();
    }
  }
}
