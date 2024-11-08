import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fudo_challenge/core/interfaces/module.dart';
import 'package:fudo_challenge/features/auth/auth_module.dart';
import 'package:fudo_challenge/features/posts/posts_module.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/create_post_cubit.dart';
import 'package:fudo_challenge/features/posts/presentation/cubit/posts_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  Map<String, WidgetBuilder> _generateRoutes() {
    
    final List<Module> modules = [
      AuthModule(),
      PostsModule(),
    ];

    final routes = <String, WidgetBuilder>{};

    for (final module in modules) {
      routes.addAll(module.generateRoutes());
    }
    return routes;
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => di.di<AuthCubit>()),
        BlocProvider(create: (context) => di.di<PostsCubit>()),
        BlocProvider(create: (context) => di.di<CreatePostCubit>()),
      ],
      child: MaterialApp(
        title: 'Fudo Challenge',
        theme: ThemeData(
          primarySwatch: Colors.blue,
          useMaterial3: true,
        ),
        routes: _generateRoutes(),
        initialRoute: AuthModule.login,
      ),
    );
  }
}