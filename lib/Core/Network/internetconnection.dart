import 'dart:async';
import 'package:connectivity_plus/connectivity_plus.dart';

abstract class InternetConnectivity {
  Future<bool> get isConnected;
  Stream<List<ConnectivityResult>> get onConnectivityChanged;
}

class MobileConnectivity implements InternetConnectivity {
  Connectivity connectivity;
  MobileConnectivity({required this.connectivity});
  @override
  Future<bool> get isConnected async {
    var connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  @override
  Stream<List<ConnectivityResult>> get onConnectivityChanged =>
      connectivity.onConnectivityChanged;
}
