import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Core/Routes/routes.dart';
import 'package:flutter_complete_project/Features/Maps/Data/DataSource/mapremote.dart';
import 'package:flutter_complete_project/Features/Maps/Data/RepoImplementation/mapRepoImplementation.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/UI/widgets/googlemaps.dart';
import 'package:flutter_complete_project/Features/Maps2/googlemaps2.dart';

class AppRoutes {
  static Route generateroute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.map:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MapsCubit(MapsRepoimplementation(
                      mapRemoteDataSource:
                          MapRemoteDataSourceImplementation(dio: Dio()))),
                  child: const MyMaps(),
                ));

      case Routes.map2:
        return MaterialPageRoute(builder: (context) => const Googlemaps2());

      default:
        return MaterialPageRoute(
            builder: (context) => const Text('data not found'));
    }
  }
}
