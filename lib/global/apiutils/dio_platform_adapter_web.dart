import 'package:dio/browser.dart';
import 'package:dio/dio.dart';

/// Browser XHR adapter — required for reliable Flutter web API calls.
void configureDioAdapter(Dio dio) {
  dio.httpClientAdapter = BrowserHttpClientAdapter();
}
