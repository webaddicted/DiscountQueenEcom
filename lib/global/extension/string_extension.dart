import 'package:flutter/material.dart';
import 'package:portfolio/global/constant/color_const.dart';

extension StringExtension on String {
  bool get isNullOrEmpty => trim().isEmpty;
  bool get isNotNullOrEmpty => trim().isNotEmpty;

  // Formatting
  String get capitalize =>
      isEmpty ? '' : '${this[0].toUpperCase()}${substring(1)}';
  String get capitalizeEachWord =>
      split(' ').map((w) => w.capitalize).join(' ');
  String get initials => split(' ')
      .where((w) => w.isNotEmpty)
      .map((w) => w[0].toUpperCase())
      .take(2)
      .join();

  // Validation
  bool get isValidEmail =>
      RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(this);
  bool get isValidPhone => RegExp(r'^\+?[\d\s-]{10,}$').hasMatch(this);
  bool get isValidUrl => Uri.tryParse(this)?.hasAbsolutePath ?? false;
  bool get isNumeric => double.tryParse(this) != null;

  // Parsing
  int? get toIntOrNull => int.tryParse(this);
  double? get toDoubleOrNull => double.tryParse(this);
  Color get toColor => colorFromHex(this);

  // Truncation
  String truncate(int maxLength, {String suffix = '...'}) =>
      length <= maxLength ? this : '${substring(0, maxLength)}$suffix';
}
