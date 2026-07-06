import 'package:flutter/foundation.dart' show kIsWeb;

import 'package:portfolio/global/utils/web_url_helper_stub.dart'
    if (dart.library.js_interop) 'package:portfolio/global/utils/web_url_helper_web.dart';

class WebUrlHelper {
  WebUrlHelper._();

  static void replaceUrl(String path) {
    if (kIsWeb) {
      webReplaceUrl(path);
    }
  }

  static void pushUrl(String path) {
    if (kIsWeb) {
      webPushUrl(path);
    }
  }

  static void onPopState(void Function(String path) callback) {
    if (kIsWeb) {
      webOnPopState(callback);
    }
  }
}
