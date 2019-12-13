import 'dart:async';

import 'package:connectivity/connectivity.dart';
import 'package:groto_shop/enums/connectivity_state.dart';

class ConnectivityService {
  Connectivity _connectivity = Connectivity();
  StreamController<ConnectivityState> connectivityStreamController =
  StreamController<ConnectivityState>();

  ConnectivityService() {
    _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
      connectivityStreamController.add(_getStateFromResult(result));
    });
  }

  ConnectivityState _getStateFromResult(ConnectivityResult result) {
    switch (result) {
      case ConnectivityResult.wifi:
        return ConnectivityState.WIFI;
      case ConnectivityResult.mobile:
        return ConnectivityState.CELLULAR;
      case ConnectivityResult.none:
        return ConnectivityState.OFFLINE;
      default:
        return ConnectivityState.OFFLINE;
    }
  }
}
