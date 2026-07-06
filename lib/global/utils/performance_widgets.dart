import 'dart:async';

import 'package:flutter/material.dart';
import 'package:portfolio/global/theme/text_style.dart';

class PerformanceWidgets {
  PerformanceWidgets._();

  static Widget optimizedText(
    String text, {
    TextStyle? style,
    TextAlign? textAlign,
    int? maxLines,
    TextOverflow? overflow,
  }) {
    return Text(
      text,
      style: style,
      textAlign: textAlign,
      maxLines: maxLines,
      overflow: overflow,
    );
  }

  static Widget optimizedContainer({
    Widget? child,
    EdgeInsets? padding,
    EdgeInsets? margin,
    BoxDecoration? decoration,
    double? width,
    double? height,
  }) {
    return Container(
      padding: padding,
      margin: margin,
      decoration: decoration,
      width: width,
      height: height,
      child: child,
    );
  }

  static Widget verticalSpace(double height) => SizedBox(height: height);
  static Widget horizontalSpace(double width) => SizedBox(width: width);

  static Widget optimizedColumn({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.start,
    MainAxisSize mainAxisSize = MainAxisSize.min,
  }) {
    return Column(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }

  static Widget optimizedRow({
    required List<Widget> children,
    MainAxisAlignment mainAxisAlignment = MainAxisAlignment.start,
    CrossAxisAlignment crossAxisAlignment = CrossAxisAlignment.center,
    MainAxisSize mainAxisSize = MainAxisSize.max,
  }) {
    return Row(
      mainAxisAlignment: mainAxisAlignment,
      crossAxisAlignment: crossAxisAlignment,
      mainAxisSize: mainAxisSize,
      children: children,
    );
  }
}

mixin PerformanceOptimizationMixin<T extends StatefulWidget> on State<T> {
  Timer? _debounceTimer;

  void safeSetState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  void debouncedSetState(VoidCallback fn, {Duration duration = const Duration(milliseconds: 300)}) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, () {
      if (mounted) setState(fn);
    });
  }

  void executeAfterFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) callback();
    });
  }

  @override
  void dispose() {
    _debounceTimer?.cancel();
    super.dispose();
  }
}

class OptimizedBuilder<T> extends StatefulWidget {
  final T dependency;
  final Widget Function(BuildContext context, T dependency) builder;

  const OptimizedBuilder({
    super.key,
    required this.dependency,
    required this.builder,
  });

  @override
  State<OptimizedBuilder<T>> createState() => _OptimizedBuilderState<T>();
}

class _OptimizedBuilderState<T> extends State<OptimizedBuilder<T>> {
  late Widget _cachedWidget;

  @override
  void initState() {
    super.initState();
    _cachedWidget = widget.builder(context, widget.dependency);
  }

  @override
  void didUpdateWidget(covariant OptimizedBuilder<T> oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.dependency != widget.dependency) {
      _cachedWidget = widget.builder(context, widget.dependency);
    }
  }

  @override
  Widget build(BuildContext context) => _cachedWidget;
}

class OptimizedListItem extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final EdgeInsets padding;

  const OptimizedListItem({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Row(children: [
          if (leading != null) ...[leading!, const SizedBox(width: 8)],
          Expanded(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(title,
                      style: AppTextStyle.titleMedium.copyWith(
                          fontWeight: FontWeight.w600)),
                  if (subtitle != null)
                    Text(subtitle!,
                        style: AppTextStyle.bodySmall
                            .copyWith(color: Colors.grey.shade600)),
                ]),
          ),
          ?trailing,
        ]),
      ),
    );
  }
}

class OptimizedCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets margin;
  final EdgeInsets padding;
  final double elevation;
  final double borderRadius;
  final Color? color;
  final VoidCallback? onTap;

  const OptimizedCard({
    super.key,
    required this.child,
    this.margin = const EdgeInsets.all(4),
    this.padding = const EdgeInsets.all(8),
    this.elevation = 0,
    this.borderRadius = 12,
    this.color,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = Card(
      margin: margin,
      elevation: elevation,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(borderRadius)),
      color: color,
      child: Padding(padding: padding, child: child),
    );
    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(borderRadius),
        child: card,
      );
    }
    return card;
  }
}

class OptimizedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final Widget child;
  final bool isLoading;
  final Color? backgroundColor;
  final double borderRadius;
  final EdgeInsets padding;

  const OptimizedButton({
    super.key,
    required this.onPressed,
    required this.child,
    this.isLoading = false,
    this.backgroundColor,
    this.borderRadius = 8,
    this.padding = const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius)),
        padding: padding,
      ),
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
          : child,
    );
  }
}

class MemoryManager {
  MemoryManager._();

  static void executeNextFrame(VoidCallback callback) {
    WidgetsBinding.instance.addPostFrameCallback((_) => callback());
  }

  static void safeExecute(bool mounted, VoidCallback callback) {
    if (mounted) callback();
  }

  static Timer? _debounceTimers;

  static void debounce(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 300)}) {
    _debounceTimers?.cancel();
    _debounceTimers = Timer(duration, callback);
  }

  static DateTime? _lastThrottleTime;

  static void throttle(VoidCallback callback,
      {Duration duration = const Duration(milliseconds: 300)}) {
    final now = DateTime.now();
    if (_lastThrottleTime == null ||
        now.difference(_lastThrottleTime!) > duration) {
      _lastThrottleTime = now;
      callback();
    }
  }
}
