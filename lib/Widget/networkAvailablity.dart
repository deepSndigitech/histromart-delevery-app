//------------------------------------------------------------------------------
//============ connectivity_plus for checking internet connectivity ============

import 'package:connectivity/connectivity.dart';

bool isNetworkAvail = true;

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}
