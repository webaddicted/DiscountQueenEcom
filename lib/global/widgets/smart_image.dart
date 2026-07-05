import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SmartImage extends StatelessWidget {
  final String source;
  final double? width;
  final double? height;
  final BoxFit fit;
  final double borderRadius;
  final Widget? placeholder;
  final Widget? errorWidget;
  final Color? color;
  final BlendMode? colorBlendMode;
  final String? heroTag;
  final VoidCallback? onTap;

  const SmartImage({
    super.key,
    required this.source,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholder,
    this.errorWidget,
    this.color,
    this.colorBlendMode,
    this.heroTag,
    this.onTap,
  });

  factory SmartImage.circular({
    required String source,
    double size = 48,
    BoxFit fit = BoxFit.cover,
    String? heroTag,
    VoidCallback? onTap,
  }) {
    return SmartImage(
      source: source,
      width: size,
      height: size,
      fit: fit,
      borderRadius: size / 2,
      heroTag: heroTag,
      onTap: onTap,
    );
  }

  factory SmartImage.rounded({
    required String source,
    double? width,
    double? height,
    double borderRadius = 12,
    BoxFit fit = BoxFit.cover,
    String? heroTag,
    VoidCallback? onTap,
  }) {
    return SmartImage(
      source: source,
      width: width,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      heroTag: heroTag,
      onTap: onTap,
    );
  }

  factory SmartImage.avatar({
    required String source,
    double size = 40,
    String? heroTag,
    VoidCallback? onTap,
  }) {
    return SmartImage(
      source: source,
      width: size,
      height: size,
      fit: BoxFit.cover,
      borderRadius: size / 2,
      heroTag: heroTag,
      onTap: onTap,
    );
  }

  factory SmartImage.banner({
    required String source,
    double? height = 200,
    BoxFit fit = BoxFit.cover,
    double borderRadius = 8,
    String? heroTag,
    VoidCallback? onTap,
  }) {
    return SmartImage(
      source: source,
      width: double.infinity,
      height: height,
      fit: fit,
      borderRadius: borderRadius,
      heroTag: heroTag,
      onTap: onTap,
    );
  }

  bool get _isNetwork =>
      source.startsWith('http://') || source.startsWith('https://');
  bool get _isFile => source.startsWith('/') || source.startsWith('file://');
  // ignore: unused_element
  bool get _isAsset => !_isNetwork && !_isFile;

  @override
  Widget build(BuildContext context) {
    if (source.trim().isEmpty) {
      return _wrapChild(errorWidget ?? _defaultError());
    }

    Widget image;
    if (_isNetwork) {
      image = CachedNetworkImage(
        imageUrl: source,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        fadeInDuration: const Duration(milliseconds: 300),
        placeholder: (_, __) =>
            placeholder ?? _defaultPlaceholder(),
        errorWidget: (_, __, ___) =>
            errorWidget ?? _defaultError(),
      );
    } else if (_isFile) {
      image = Image.file(
        File(source.replaceFirst('file://', '')),
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? _defaultError(),
      );
    } else {
      image = Image.asset(
        source,
        width: width,
        height: height,
        fit: fit,
        color: color,
        colorBlendMode: colorBlendMode,
        errorBuilder: (_, __, ___) =>
            errorWidget ?? _defaultError(),
      );
    }

    return _wrapChild(image);
  }

  Widget _wrapChild(Widget child) {
    Widget result = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: child,
    );

    if (heroTag != null) {
      result = Hero(tag: heroTag!, child: result);
    }

    if (onTap != null) {
      result = GestureDetector(onTap: onTap, child: result);
    }

    return result;
  }

  Widget _defaultPlaceholder() {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
        width: width,
        height: height,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
    );
  }

  Widget _defaultError() {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
      child: Icon(Icons.broken_image_outlined,
          size: 24, color: Colors.grey.shade400),
    );
  }
}
