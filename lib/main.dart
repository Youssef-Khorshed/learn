import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Core/Routes/app_routes.dart';
import 'package:flutter_complete_project/Core/Routes/routes.dart';
import 'package:flutter_complete_project/Features/StateManagement/Bloc/obsercer.dart';

void main() {
  Bloc.observer = const MyBlocObserver();

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      onGenerateRoute: AppRoutes.generateroute,
      initialRoute: Routes.map,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
    );
  }
}
