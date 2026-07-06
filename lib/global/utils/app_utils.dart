import 'dart:math';

import 'package:logger/logger.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

final _logger = Logger(printer: PrettyPrinter(methodCount: 0));

bool isEmpty(String? value) => value == null || value.trim().isEmpty;
bool isNotEmpty(String? value) => !isEmpty(value);

void printLog(String tag, dynamic msg) => _logger.d('[$tag] $msg');
void printError(String tag, dynamic msg) => _logger.e('[$tag] $msg');

Future<void> launchURL(String url) async {
  final uri = Uri.parse(url);
  if (await canLaunchUrl(uri)) {
    await launchUrl(uri, mode: LaunchMode.externalApplication);
  }
}

void shareText(String text, {String? subject}) =>
    SharePlus.instance.share(ShareParams(text: text, subject: subject));

Future<void> delay(int milliseconds) =>
    Future.delayed(Duration(milliseconds: milliseconds));

int randomNumber({int max = 1000}) => Random().nextInt(max);

String formatFileSize(int bytes, {int decimals = 2}) {
  if (bytes <= 0) return '0 B';
  const suffixes = ['B', 'KB', 'MB', 'GB', 'TB'];
  final i = (log(bytes) / log(1024)).floor();
  return '${(bytes / pow(1024, i)).toStringAsFixed(decimals)} ${suffixes[i]}';
}

String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60);
  final seconds = duration.inSeconds.remainder(60);
  if (hours > 0) return '${hours}h ${minutes}m';
  if (minutes > 0) return '${minutes}m ${seconds}s';
  return '${seconds}s';
}
