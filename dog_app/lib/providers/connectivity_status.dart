import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';

class ConnectivityStatus with ChangeNotifier{
  ConnectivityResult _connectivityResult = ConnectivityResult.none;
  ConnectivityResult get connectivityResult => _connectivityResult;
  bool isOnline = true;
  late Timer _timer;

  ConnectivityStatus(){
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      checkConnectivity();
    });
  }

  Future<void> checkConnectivity() async {
    _connectivityResult = await Connectivity().checkConnectivity();
    isOnline = connectivityResult != ConnectivityResult.none;
    notifyListeners();

  }

}