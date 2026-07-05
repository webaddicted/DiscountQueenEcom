import 'package:flutter/foundation.dart' show kIsWeb;
// ignore: avoid_web_libraries_in_flutter
import 'dart:html' if (dart.library.io) 'package:portfolio/global/utils/web_url_stub.dart'
    as html;

class WebUrlHelper {
  WebUrlHelper._();

  static void replaceUrl(String path) {
    if (kIsWeb) {
      html.window.history.replaceState(null, '', '#$path');
    }
  }

  static void pushUrl(String path) {
    if (kIsWeb) {
      html.window.history.pushState(null, '', '#$path');
    }
  }

  static void onPopState(void Function(String path) callback) {
    if (kIsWeb) {
      html.window.onPopState.listen((_) {
        final hash = html.window.location.hash;
        final path = hash.startsWith('#') ? hash.substring(1) : hash;
        callback(path);
      });
    }
  }
}
