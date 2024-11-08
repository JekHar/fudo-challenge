import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

abstract class Module {
  Map<String, WidgetBuilder> generateRoutes();
  void registerDependencies(GetIt injector);
}
