import 'dart:async';

class _StubHistory {
  void replaceState(dynamic data, String title, String? url) {}
  void pushState(dynamic data, String title, String? url) {}
}

class _StubLocation {
  String hash = '';
}

class _StubWindow {
  final history = _StubHistory();
  final location = _StubLocation();
  Stream<dynamic> get onPopState => const Stream.empty();
}

final window = _StubWindow();
