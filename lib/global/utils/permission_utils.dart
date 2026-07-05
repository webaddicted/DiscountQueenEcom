import 'dart:async';
import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/utils/app_utils.dart';

enum PermissionType {
  camera,
  location,
  storage,
  manageStorage,
  notification,
  contact,
  sms,
  mediaLibrary,
  microphone,
  photos,
}

class _PermissionInfo {
  final Permission permission;
  final String title;
  final String subtitle;
  final String buttonText;

  const _PermissionInfo({
    required this.permission,
    required this.title,
    required this.subtitle,
    required this.buttonText,
  });
}

class PermissionHelper {
  PermissionHelper._();

  static int? _cachedSdkVersion;

  // ============ PUBLIC API ============

  /// Request a single permission with optional custom dialog
  static Future<bool> requestPermission(
    PermissionType type, {
    bool showDialogOnDenied = true,
    bool showBottomSheet = false,
  }) async {
    final info = await _getPermissionInfo(type);
    if (info == null) return true;

    PermissionStatus status = await info.permission.status;
    printLog('PermissionHelper', 'Status for ${type.name}: $status');

    if (status.isGranted) return true;

    if (status == PermissionStatus.denied) {
      if (showBottomSheet) {
        final completer = Completer<bool>();
        _showPermissionBottomSheet(
          info,
          onAllow: () async {
            final newStatus = await info.permission.request();
            if (newStatus.isGranted) {
              completer.complete(true);
            } else {
              if (showDialogOnDenied) _showSettingsDialog(type);
              completer.complete(false);
            }
          },
          onDeny: () => completer.complete(false),
        );
        return completer.future;
      } else {
        status = await info.permission.request();
        if (status.isGranted) return true;
        if (showDialogOnDenied && status.isPermanentlyDenied) {
          _showSettingsDialog(type);
        }
        return false;
      }
    }

    if (status.isPermanentlyDenied && showDialogOnDenied) {
      _showSettingsDialog(type);
    }

    return false;
  }

  /// Request multiple permissions at once
  static Future<Map<PermissionType, bool>> requestMultiple(
    List<PermissionType> types, {
    bool showDialogOnDenied = true,
  }) async {
    final results = <PermissionType, bool>{};
    final toRequest = <PermissionType, Permission>{};

    for (final type in types) {
      final info = await _getPermissionInfo(type);
      if (info == null) {
        results[type] = true;
        continue;
      }
      if (await info.permission.isGranted) {
        results[type] = true;
      } else {
        toRequest[type] = info.permission;
      }
    }

    if (toRequest.isEmpty) return results;

    final statuses = await toRequest.values.toList().request();
    final deniedPermissions = <String>[];

    for (final entry in toRequest.entries) {
      final status = statuses[entry.value];
      if (status?.isGranted == true) {
        results[entry.key] = true;
      } else {
        results[entry.key] = false;
        deniedPermissions.add(entry.key.name);
      }
    }

    if (deniedPermissions.isNotEmpty && showDialogOnDenied) {
      _showSettingsDialog(null,
          customMessage:
              'The following permissions are required: ${deniedPermissions.join(', ')}.\n\nPlease enable them in app settings.');
    }

    return results;
  }

  /// Request multiple permissions sequentially with bottom sheet for each
  static Future<Map<PermissionType, bool>> requestSequential(
    List<PermissionType> types,
  ) async {
    final results = <PermissionType, bool>{};

    for (final type in types) {
      results[type] = await requestPermission(
        type,
        showDialogOnDenied: true,
        showBottomSheet: true,
      );
    }

    return results;
  }

  /// Check if permission is granted
  static Future<bool> isGranted(PermissionType type) async {
    final info = await _getPermissionInfo(type);
    if (info == null) return true;
    return await info.permission.isGranted;
  }

  /// Check if permission is permanently denied
  static Future<bool> isPermanentlyDenied(PermissionType type) async {
    final info = await _getPermissionInfo(type);
    if (info == null) return false;
    return await info.permission.isPermanentlyDenied;
  }

  /// Open app settings
  static Future<bool> openSettings() async => await openAppSettings();

  /// Get Permission from PermissionType
  static Permission getPermissionFromType(PermissionType type) {
    switch (type) {
      case PermissionType.camera:
        return Permission.camera;
      case PermissionType.location:
        return Permission.location;
      case PermissionType.storage:
        return Permission.storage;
      case PermissionType.manageStorage:
        return Permission.manageExternalStorage;
      case PermissionType.notification:
        return Permission.notification;
      case PermissionType.contact:
        return Permission.contacts;
      case PermissionType.sms:
        return Permission.sms;
      case PermissionType.mediaLibrary:
        return Permission.mediaLibrary;
      case PermissionType.microphone:
        return Permission.microphone;
      case PermissionType.photos:
        return Permission.photos;
    }
  }

  // ============ ANDROID SDK VERSION ============

  static Future<int> _getAndroidSdkVersion() async {
    if (_cachedSdkVersion != null) return _cachedSdkVersion!;
    if (Platform.isAndroid) {
      try {
        final androidInfo = await DeviceInfoPlugin().androidInfo;
        _cachedSdkVersion = androidInfo.version.sdkInt;
        return _cachedSdkVersion!;
      } catch (e) {
        return 29;
      }
    }
    return 0;
  }

  // ============ PERMISSION INFO MAPPING ============

  /// Returns null if no permission is needed (e.g., Android 13+ for storage)
  static Future<_PermissionInfo?> _getPermissionInfo(
      PermissionType type) async {
    switch (type) {
      case PermissionType.camera:
        return const _PermissionInfo(
          permission: Permission.camera,
          title: 'Camera Access Required',
          subtitle:
              'To capture photos and videos, this app needs access to your camera. Enable camera access to use features like profile picture updates and media sharing.',
          buttonText: 'Allow Camera Access',
        );

      case PermissionType.location:
        return const _PermissionInfo(
          permission: Permission.location,
          title: 'Location Access Required',
          subtitle:
              'To provide the best experience, this app needs access to your location. We can offer personalized services and nearby suggestions.',
          buttonText: 'Allow Location Access',
        );

      case PermissionType.storage:
        final sdkVersion = await _getAndroidSdkVersion();
        if (Platform.isAndroid) {
          if (sdkVersion >= 33) return null;
          if (sdkVersion >= 30) {
            return const _PermissionInfo(
              permission: Permission.manageExternalStorage,
              title: 'File Access Required',
              subtitle:
                  'This app needs access to manage files on your device to save and download content.',
              buttonText: 'Allow File Access',
            );
          }
          if (sdkVersion >= 29) return null;
        }
        return const _PermissionInfo(
          permission: Permission.storage,
          title: 'Storage Access Required',
          subtitle:
              'This app needs access to your device storage to save and manage files.',
          buttonText: 'Allow Storage Access',
        );

      case PermissionType.manageStorage:
        return const _PermissionInfo(
          permission: Permission.manageExternalStorage,
          title: 'File Access Required',
          subtitle:
              'This app needs access to manage files on your device to save files to the Downloads folder.',
          buttonText: 'Allow File Access',
        );

      case PermissionType.notification:
        return const _PermissionInfo(
          permission: Permission.notification,
          title: 'Notification Access Required',
          subtitle:
              'Stay updated with important information by enabling notifications. We\'ll keep you informed about new activities and relevant updates.',
          buttonText: 'Allow Notifications',
        );

      case PermissionType.contact:
        return const _PermissionInfo(
          permission: Permission.contacts,
          title: 'Contacts Access Required',
          subtitle:
              'This app needs access to your contacts to help you connect with friends and family.',
          buttonText: 'Allow Contacts Access',
        );

      case PermissionType.sms:
        return const _PermissionInfo(
          permission: Permission.sms,
          title: 'SMS Access Required',
          subtitle:
              'This app needs SMS access for auto-verification of OTP codes.',
          buttonText: 'Allow SMS Access',
        );

      case PermissionType.mediaLibrary:
        return const _PermissionInfo(
          permission: Permission.mediaLibrary,
          title: 'Media Library Access Required',
          subtitle:
              'This app needs access to your media library to manage and share your photos and videos.',
          buttonText: 'Allow Media Access',
        );

      case PermissionType.microphone:
        return const _PermissionInfo(
          permission: Permission.microphone,
          title: 'Microphone Access Required',
          subtitle:
              'This app needs access to your microphone to record audio. Enable microphone access to use voice features.',
          buttonText: 'Allow Microphone Access',
        );

      case PermissionType.photos:
        return const _PermissionInfo(
          permission: Permission.photos,
          title: 'Photos Access Required',
          subtitle:
              'This app needs access to your photos to manage and share images.',
          buttonText: 'Allow Photos Access',
        );
    }
  }

  // ============ UI DIALOGS ============

  static void _showSettingsDialog(PermissionType? type, {String? customMessage}) {
    Get.dialog(
      AlertDialog(
        title: Text('Permission Required', style: AppTextStyle.titleMedium),
        content: Text(
          customMessage ??
              'Please enable ${type?.name ?? ''} permission from Settings to use this feature.',
          style: AppTextStyle.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Get.back();
              openAppSettings();
            },
            child: const Text('Open Settings'),
          ),
        ],
      ),
      barrierDismissible: false,
    );
  }

  static void _showPermissionBottomSheet(
    _PermissionInfo info, {
    required VoidCallback onAllow,
    required VoidCallback onDeny,
  }) {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Get.theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(2)),
          ),
          Icon(Icons.shield_outlined, size: 48, color: Get.theme.primaryColor),
          const SizedBox(height: 8),
          Text(info.title,
              style: AppTextStyle.headlineSmall,
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          Text(info.subtitle,
              style: AppTextStyle.bodyMedium.copyWith(color: Colors.grey.shade600),
              textAlign: TextAlign.center),
          const SizedBox(height: 8),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Get.back();
                onAllow();
              },
              child: Text(info.buttonText),
            ),
          ),
          const SizedBox(height: 4),
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () {
                Get.back();
                onDeny();
              },
              child: const Text('Not Now'),
            ),
          ),
          const SizedBox(height: 4),
        ]),
      ),
      isDismissible: false,
    );
  }
}
