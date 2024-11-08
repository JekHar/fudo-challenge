import 'dart:convert';
import 'package:fudo_challenge/core/error/exceptions.dart';
import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';

class UsersLocalDataSource {
  final LocalStorage localStorage;
  static const String cachedUsersKey = 'CACHED_USERS';

  UsersLocalDataSource({required this.localStorage});

  Future<List<User>> getCachedUsers() async {
    try {
      final jsonString = await localStorage.getString(cachedUsersKey);
      if (jsonString != null) {
        final List<dynamic> jsonList = json.decode(jsonString);
        return jsonList.map((json) => User.fromJson(json)).toList();
      }
      throw CacheException();
    } catch (_) {
      throw CacheException();
    }
  }

  Future<void> cacheUsers(List<User> users) async {
    final String jsonString = json.encode(
      users
          .map((user) => {
                'id': user.id,
                'name': user.name,
              })
          .toList(),
    );
    await localStorage.saveString(cachedUsersKey, jsonString);
  }
}
