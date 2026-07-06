import 'package:web/web.dart' as web;

void webReplaceUrl(String path) {
  web.window.history.replaceState(null, '', '#$path');
}

void webPushUrl(String path) {
  web.window.history.pushState(null, '', '#$path');
}

void webOnPopState(void Function(String path) callback) {
  web.window.onPopState.listen((_) {
    final hash = web.window.location.hash;
    final path = hash.startsWith('#') ? hash.substring(1) : hash;
    callback(path);
  });
}
