import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/interfaces/http_client.dart';

class User {
  final int id;
  final String name;

  User({required this.id, required this.name});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class UsersRemoteDataSource {
  final HttpClient client;
  final String baseUrl = 'https://jsonplaceholder.typicode.com';

  UsersRemoteDataSource({required this.client});

  Future<List<User>> getUsers() async {
    final response = await client.get('$baseUrl/users');

    if (response.statusCode == 200) {
      return (response.data as List)
          .map((json) => User.fromJson(json as Map<String, dynamic>))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
