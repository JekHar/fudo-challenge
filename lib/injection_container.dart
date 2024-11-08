import 'package:fudo_challenge/core/implementations/http_client_impl.dart';
import 'package:fudo_challenge/core/implementations/network_info_impl.dart';
import 'package:fudo_challenge/core/implementations/shared_prefs_storage.dart';
import 'package:fudo_challenge/core/interfaces/http_client.dart';
import 'package:fudo_challenge/core/interfaces/local_storage.dart';
import 'package:fudo_challenge/core/interfaces/network_info.dart';
import 'package:fudo_challenge/features/auth/auth_module.dart';
import 'package:fudo_challenge/features/posts/posts_module.dart';
import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:shared_preferences/shared_preferences.dart';

final di = GetIt.instance;

Future<void> init() async {
  final sharedPreferences = await SharedPreferences.getInstance();
  di.registerLazySingleton(() => InternetConnectionChecker());
  di.registerLazySingleton(() => http.Client());
  di.registerLazySingleton(() => sharedPreferences);

  di.registerLazySingleton<NetworkInfo>(
    () => NetworkInfoImpl(di()),
  );

  di.registerLazySingleton<LocalStorage>(
    () => SharedPrefsStorage(di()),
  );

  di.registerLazySingleton<HttpClient>(
    () => HttpClientImpl(di()),
  );

  AuthModule().registerDependencies(di);
  PostsModule().registerDependencies(di);
}
