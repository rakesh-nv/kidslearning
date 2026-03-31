import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final RxBool isOnline = true.obs;

  Future<ConnectivityService> init() async {
    final List<ConnectivityResult> results = await (Connectivity().checkConnectivity());
    _updateConnectionStatus(results);
    
    Connectivity().onConnectivityChanged.listen((List<ConnectivityResult> results) {
      _updateConnectionStatus(results);
    });
    return this;
  }

  void _updateConnectionStatus(List<ConnectivityResult> results) {
    isOnline.value = results.isNotEmpty && !results.contains(ConnectivityResult.none);
  }
}
