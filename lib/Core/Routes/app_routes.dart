import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Core/Routes/routes.dart';
import 'package:flutter_complete_project/Features/Maps/Data/DataSource/mapremote.dart';
import 'package:flutter_complete_project/Features/Maps/Data/RepoImplementation/mapRepoImplementation.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/Logic/cubit/maps/maps_cubit.dart';
import 'package:flutter_complete_project/Features/Maps/Presentation/UI/widgets/googlemaps.dart';

class AppRoutes {
  static Route generateroute(RouteSettings settings) {
    switch (settings.name) {
      // case Routes.onBoarding:
      //   return MaterialPageRoute(builder: (context) => const Onboarding());
      // case Routes.login:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //             create: (context) => getit<LoginCubit>(),
      //             child: const Loginscreen(),
      //           ));
      // case Routes.register:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //             create: (context) => getit<RegisterCubit>(),
      //             child: const Signupscrenn(),
      //           ));
      // case Routes.home:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //             create: (context) => getit<HomeBloc>(),
      //             child: const Homescreen(),
      //           ));
      // case Routes.map:
      //   return MaterialPageRoute(
      //       builder: (context) => BlocProvider(
      //             create: (context) => getit<HomeBloc>(),
      //             child: McDonaldsLocator(),
      //           ));
      case Routes.map:
        return MaterialPageRoute(
            builder: (context) => BlocProvider(
                  create: (context) => MapsCubit(MapsRepoimplementation(
                      mapRemoteDataSource:
                          MapRemoteDataSourceImplementation(dio: Dio()))),
                  child: const MyMaps(),
                ));
      default:
        return MaterialPageRoute(
            builder: (context) => const Text('data not found'));
    }
  }
}
