import 'package:flutter/material.dart';
import 'package:portfolio/global/theme/text_style.dart';
import 'package:portfolio/global/widgets/shimmer_widget.dart';

class LoadingWidget extends StatelessWidget {
  final String? message;
  final bool useShimmer;

  const LoadingWidget({super.key, this.message, this.useShimmer = false});
  const LoadingWidget.shimmer({super.key, this.message}) : useShimmer = true;

  @override
  Widget build(BuildContext context) {
    if (useShimmer) return ShimmerLoadingWidget(message: message);
    return Center(
        child: Column(mainAxisSize: MainAxisSize.min, children: [
      const CircularProgressIndicator(),
      if (message != null) ...[
        const SizedBox(height: 8),
        Text(message!, style: AppTextStyle.bodySmall),
      ],
    ]));
  }
}
