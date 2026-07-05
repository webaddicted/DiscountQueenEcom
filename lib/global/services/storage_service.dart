import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:portfolio/global/utils/app_utils.dart';

enum UploadStatus { idle, uploading, success, error, cancelled }

class UploadResult {
  final UploadStatus status;
  final String? url;
  final String? error;

  const UploadResult._({required this.status, this.url, this.error});

  factory UploadResult.success(String url) =>
      UploadResult._(status: UploadStatus.success, url: url);
  factory UploadResult.error(String error) =>
      UploadResult._(status: UploadStatus.error, error: error);
  factory UploadResult.cancelled() =>
      const UploadResult._(status: UploadStatus.cancelled);
}

class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  Future<String?> uploadFile(String path, File file,
      {Function(double)? onProgress}) async {
    // TODO: Implement file upload
    return null;
  }

  Future<void> deleteFile(String path) async {
    // TODO: Implement file delete
  }

  Future<String?> getDownloadUrl(String path) async => null;

  Future<String> getAppDocumentsPath() async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<String> getTempPath() async {
    final dir = await getTemporaryDirectory();
    return dir.path;
  }

  Future<File?> saveToLocal(String fileName, Uint8List bytes) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      return await file.writeAsBytes(bytes);
    } catch (e) {
      printError('StorageService', 'saveToLocal error: $e');
      return null;
    }
  }

  Future<Uint8List?> readFromLocal(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) return await file.readAsBytes();
      return null;
    } catch (e) {
      printError('StorageService', 'readFromLocal error: $e');
      return null;
    }
  }

  Future<bool> deleteFromLocal(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      final file = File('${dir.path}/$fileName');
      if (await file.exists()) {
        await file.delete();
        return true;
      }
      return false;
    } catch (e) {
      printError('StorageService', 'deleteFromLocal error: $e');
      return false;
    }
  }

  Future<bool> fileExists(String fileName) async {
    try {
      final dir = await getApplicationDocumentsDirectory();
      return await File('${dir.path}/$fileName').exists();
    } catch (_) {
      return false;
    }
  }

  Future<int> getDirectorySize(String dirPath) async {
    int totalSize = 0;
    try {
      final dir = Directory(dirPath);
      if (await dir.exists()) {
        await for (final entity in dir.list(recursive: true)) {
          if (entity is File) totalSize += await entity.length();
        }
      }
    } catch (e) {
      printError('StorageService', 'getDirectorySize error: $e');
    }
    return totalSize;
  }

  Future<void> clearCache() async {
    try {
      final dir = await getTemporaryDirectory();
      if (await dir.exists()) await dir.delete(recursive: true);
    } catch (e) {
      printError('StorageService', 'clearCache error: $e');
    }
  }
}
