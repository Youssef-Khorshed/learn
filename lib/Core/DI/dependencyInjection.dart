import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Core/lang/LocalCubit/local_cubit.dart';
import 'package:flutter_complete_project/Features/StateManagement/Bloc/obsercer.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get_it/get_it.dart';

import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';

final getit = GetIt.instance;

void setup() async {
  /// genenral intialize
  WidgetsFlutterBinding.ensureInitialized();
  Bloc.observer = const MyBlocObserver();
  await dotenv.load();

  /// initialize factories
  getit.registerFactory(() => MapsCubit(
        getit(),
      ));
  getit.registerLazySingleton(() => LocalCubit());
}
