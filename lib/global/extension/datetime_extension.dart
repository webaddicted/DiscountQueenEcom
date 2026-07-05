import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

extension DateTimeExtension on DateTime {
  // Formatting
  String get formatted => DateFormat('dd MMM yyyy').format(this);
  String get formattedWithTime =>
      DateFormat('dd MMM yyyy, hh:mm a').format(this);
  String get timeOnly => DateFormat('hh:mm a').format(this);
  String get dateOnly => DateFormat('yyyy-MM-dd').format(this);

  // Relative time
  String get relativeTime {
    final diff = DateTime.now().difference(this);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    if (diff.inDays < 30) return '${(diff.inDays / 7).floor()}w ago';
    if (diff.inDays < 365) return '${(diff.inDays / 30).floor()}mo ago';
    return '${(diff.inDays / 365).floor()}y ago';
  }

  // Checks
  bool get isToday => DateUtils.isSameDay(this, DateTime.now());
  bool get isYesterday => DateUtils.isSameDay(
      this, DateTime.now().subtract(const Duration(days: 1)));
  bool get isTomorrow =>
      DateUtils.isSameDay(this, DateTime.now().add(const Duration(days: 1)));
  bool get isThisWeek => difference(DateTime.now()).inDays.abs() < 7;

  // Utilities
  DateTime get startOfDay => DateTime(year, month, day);
  DateTime get endOfDay => DateTime(year, month, day, 23, 59, 59);
  int daysBetween(DateTime other) => difference(other).inDays.abs();
}
