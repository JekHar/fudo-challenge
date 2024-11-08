import 'package:fudo_challenge/core/interfaces/network_info.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_local_data_source.dart';
import 'package:fudo_challenge/features/posts/data/datasources/users_remote_data_source.dart';

class UsersRepository {
  final UsersRemoteDataSource remoteDataSource;
  final UsersLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  UsersRepository({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  Future<List<User>> getUsers() async {
    if (await networkInfo.isConnected) {
      try {
        final users = await remoteDataSource.getUsers();
        await localDataSource.cacheUsers(users);
        return users;
      } catch (_) {
        return _getLocalUsers();
      }
    } else {
      return _getLocalUsers();
    }
  }

  Future<List<User>> _getLocalUsers() async {
    try {
      return await localDataSource.getCachedUsers();
    } catch (_) {
      return [];
    }
  }
}
