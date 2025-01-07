import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_complete_project/Core/enums/localization.dart';
part 'local_state.dart';

class LocalCubit extends Cubit<LocalState> {
  LocalCubit() : super(LocalInitial(const Locale('ar')));
  static LocalCubit get(context) => BlocProvider.of(context);
  LocalizationThemeState localizationThemeState = LocalizationThemeState.ar;
  Locale localization = const Locale("ar");

  Connectivity connectivity = Connectivity();

  void changeLocale() {
    emit(LocaleLoading());

    if (localizationThemeState == LocalizationThemeState.ar) {
      localizationThemeState = LocalizationThemeState.en;
      localization = const Locale("en");
      emit(LocaleSuccess());
    } else {
      localization = const Locale("ar");

      localizationThemeState = LocalizationThemeState.ar;

      emit(LocaleSuccess());
    }
  }

  bool checkLanguage(BuildContext context) =>
      localization == const Locale("en");

  void isConnection() {
    emit(InternetLoading());

    connectivity.onConnectivityChanged.listen(
      (event) {
        if (event.first == ConnectivityResult.none) {
          emit(InternetFailure());
        }
      },
    );

    emit(InternetSuccess());
  }
}
