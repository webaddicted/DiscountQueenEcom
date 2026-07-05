import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';

class ConnectivityService extends GetxService {
  final _isConnected = true.obs;
  bool get isConnected => _isConnected.value;

  @override
  void onInit() {
    super.onInit();
    Connectivity().onConnectivityChanged.listen((results) {
      _isConnected.value = !results.contains(ConnectivityResult.none);
    });
  }

  Future<bool> checkConnection() async {
    final result = await Connectivity().checkConnectivity();
    _isConnected.value = !result.contains(ConnectivityResult.none);
    return _isConnected.value;
  }
}
