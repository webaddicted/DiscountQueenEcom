import 'dart:io';

/// Development-only override that accepts self-signed certificates.
/// Remove or restrict for production builds.
class AppHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
