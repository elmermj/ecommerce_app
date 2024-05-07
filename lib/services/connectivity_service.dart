import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:ecommerce_app/utils/log.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {

  RxBool connected = false.obs;

  ConnectivityService() {
    Connectivity().onConnectivityChanged.listen(
      (status) async {
          _getNetworkStatus(status.last);
      },
    );
  }

  void _getNetworkStatus(ConnectivityResult status) {
    if (status == ConnectivityResult.mobile || status == ConnectivityResult.wifi || status == ConnectivityResult.other) {
      connected.value = true;
      Log.green("Internet connected");
    } else {
      connected.value = false;
      Log.red("Lost the connection");
    }
  }

}