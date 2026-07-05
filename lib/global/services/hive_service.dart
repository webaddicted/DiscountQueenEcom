import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:portfolio/global/constant/db_const.dart';
import 'package:portfolio/global/utils/app_utils.dart';

class HiveService {
  static final HiveService _instance = HiveService._internal();
  factory HiveService() => _instance;
  HiveService._internal();

  bool _initialized = false;
  HiveCipher? _cipher;

  Future<void> init({String? encryptionKey}) async {
    if (_initialized) return;
    await Hive.initFlutter();

    if (encryptionKey != null && encryptionKey.isNotEmpty) {
      try {
        final keyBytes = base64Decode(encryptionKey);
        _cipher = HiveAesCipher(keyBytes);
      } catch (e) {
        printError('HiveService', 'Failed to init encryption: $e');
      }
    }

    _initialized = true;
  }

  static String generateEncryptionKey() {
    final key = Hive.generateSecureKey();
    return base64Encode(Uint8List.fromList(key));
  }

  Future<Box<T>> _openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) return Hive.box<T>(name);
    return await Hive.openBox<T>(name, encryptionCipher: _cipher);
  }

  Future<void> put<T>(String boxName, String key, T value) async {
    try {
      final box = await _openBox(boxName);
      await box.put(key, value);
    } catch (e) {
      printError('HiveService', 'put($boxName, $key) error: $e');
    }
  }

  Future<T?> get<T>(String boxName, String key, {T? defaultValue}) async {
    try {
      final box = await _openBox(boxName);
      return box.get(key, defaultValue: defaultValue);
    } catch (e) {
      printError('HiveService', 'get($boxName, $key) error: $e');
      return defaultValue;
    }
  }

  Future<void> delete(String boxName, String key) async {
    try {
      final box = await _openBox(boxName);
      await box.delete(key);
    } catch (e) {
      printError('HiveService', 'delete($boxName, $key) error: $e');
    }
  }

  Future<void> clearBox(String boxName) async {
    try {
      final box = await _openBox(boxName);
      await box.clear();
    } catch (e) {
      printError('HiveService', 'clearBox($boxName) error: $e');
    }
  }

  Future<void> clearAll() async {
    try {
      for (final boxName in [
        DbConst.userBox,
        DbConst.settingsBox,
        DbConst.cacheBox,
      ]) {
        await clearBox(boxName);
      }
    } catch (e) {
      printError('HiveService', 'clearAll error: $e');
    }
  }

  Future<List<T>> getAll<T>(String boxName) async {
    try {
      final box = await _openBox<T>(boxName);
      return box.values.toList();
    } catch (e) {
      printError('HiveService', 'getAll($boxName) error: $e');
      return [];
    }
  }

  Future<Map<String, T>> getAllAsMap<T>(String boxName) async {
    try {
      final box = await _openBox<T>(boxName);
      return box.toMap().cast<String, T>();
    } catch (e) {
      printError('HiveService', 'getAllAsMap($boxName) error: $e');
      return {};
    }
  }

  Future<void> putAll<T>(String boxName, Map<String, T> entries) async {
    try {
      final box = await _openBox(boxName);
      await box.putAll(entries);
    } catch (e) {
      printError('HiveService', 'putAll($boxName) error: $e');
    }
  }

  Future<bool> containsKey(String boxName, String key) async {
    try {
      final box = await _openBox(boxName);
      return box.containsKey(key);
    } catch (e) {
      return false;
    }
  }

  Future<int> boxLength(String boxName) async {
    try {
      final box = await _openBox(boxName);
      return box.length;
    } catch (e) {
      return 0;
    }
  }

  Future<void> closeAll() async {
    try {
      await Hive.close();
      _initialized = false;
    } catch (e) {
      if (kDebugMode) printError('HiveService', 'closeAll error: $e');
    }
  }
}
