import 'package:shared_preferences/shared_preferences.dart';
import 'package:portfolio/global/utils/app_utils.dart';

class SPHelper {
  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static T? getPreference<T>(String key, T defaultValue) {
    try {
      if (_prefs == null) return defaultValue;
      if (defaultValue is String) return (_prefs!.getString(key) ?? defaultValue) as T;
      if (defaultValue is bool) return (_prefs!.getBool(key) ?? defaultValue) as T;
      if (defaultValue is int) return (_prefs!.getInt(key) ?? defaultValue) as T;
      if (defaultValue is double) return (_prefs!.getDouble(key) ?? defaultValue) as T;
      if (defaultValue is List<String>) return (_prefs!.getStringList(key) ?? defaultValue) as T;
      return defaultValue;
    } catch (e) {
      printLog('SPHelper', 'getPreference error: $key $e');
      return defaultValue;
    }
  }

  static Future<bool> setPreference<T>(String key, T value) async {
    try {
      if (_prefs == null) return false;
      if (value is String) return await _prefs!.setString(key, value);
      if (value is bool) return await _prefs!.setBool(key, value);
      if (value is int) return await _prefs!.setInt(key, value);
      if (value is double) return await _prefs!.setDouble(key, value);
      if (value is List<String>) return await _prefs!.setStringList(key, value);
      return false;
    } catch (e) {
      printLog('SPHelper', 'setPreference error: $key $e');
      return false;
    }
  }

  static Set<String> getAllKeys() => _prefs?.getKeys() ?? {};
  static Future<bool> removeKey(String key) async => await _prefs?.remove(key) ?? false;
  static Future<bool> clearAll() async => await _prefs?.clear() ?? false;
  static bool keyExists(String key) => _prefs?.containsKey(key) ?? false;

  static Future<bool> setBatch(Map<String, dynamic> values) async {
    try {
      bool allSuccess = true;
      for (final entry in values.entries) {
        final success = await setPreference(entry.key, entry.value);
        if (!success) allSuccess = false;
      }
      return allSuccess;
    } catch (e) {
      printLog('SPHelper', 'setBatch error: $e');
      return false;
    }
  }

  static Map<String, dynamic> getBatch(List<String> keys, Map<String, dynamic> defaults) {
    final Map<String, dynamic> result = {};
    try {
      for (final key in keys) {
        result[key] = getPreference(key, defaults[key]);
      }
    } catch (e) {
      printLog('SPHelper', 'getBatch error: $e');
    }
    return result;
  }

  static T? getPreferenceSync<T>(String key, T defaultValue) {
    try {
      if (_prefs == null) return defaultValue;
      if (defaultValue is String) return (_prefs!.getString(key) ?? defaultValue) as T;
      if (defaultValue is bool) return (_prefs!.getBool(key) ?? defaultValue) as T;
      if (defaultValue is int) return (_prefs!.getInt(key) ?? defaultValue) as T;
      if (defaultValue is double) return (_prefs!.getDouble(key) ?? defaultValue) as T;
      if (defaultValue is List<String>) return (_prefs!.getStringList(key) ?? defaultValue) as T;
      return defaultValue;
    } catch (e) {
      printLog('SPHelper', 'getPreferenceSync error: $key $e');
      return defaultValue;
    }
  }
}
