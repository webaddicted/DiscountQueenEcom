import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileUtils {
  FileUtils._();

  static Future<Directory> getAppDirectory() async =>
      await getApplicationDocumentsDirectory();
  static Future<Directory> getTempDirectory() async =>
      await getTemporaryDirectory();

  static Future<File> getFile(String fileName) async {
    final dir = await getAppDirectory();
    return File('${dir.path}/$fileName');
  }

  static String getFileName(String path) => path.split('/').last;
  static String getFileExtension(String path) => path.split('.').last;
}
