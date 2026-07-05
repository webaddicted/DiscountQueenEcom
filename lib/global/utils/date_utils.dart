import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AppDateUtils {
  AppDateUtils._();

  static String format(DateTime date, {String pattern = 'dd MMM yyyy'}) =>
      DateFormat(pattern).format(date);
  static String formatWithTime(DateTime date) =>
      DateFormat('dd MMM yyyy, hh:mm a').format(date);
  static String formatTime(DateTime date) =>
      DateFormat('hh:mm a').format(date);
  static String formatApiDate(DateTime date) =>
      DateFormat('yyyy-MM-dd').format(date);

  static DateTime? parse(String dateString,
      {String pattern = 'yyyy-MM-dd'}) {
    try {
      return DateFormat(pattern).parse(dateString);
    } catch (_) {
      return null;
    }
  }

  static String relativeTime(DateTime date) {
    final diff = DateTime.now().difference(date);
    if (diff.inSeconds < 60) return 'Just now';
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return format(date);
  }

  static bool isToday(DateTime date) =>
      DateUtils.isSameDay(date, DateTime.now());
  static int daysBetween(DateTime a, DateTime b) =>
      a.difference(b).inDays.abs();
}
