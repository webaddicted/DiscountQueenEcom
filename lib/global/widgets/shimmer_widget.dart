import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:portfolio/global/theme/text_style.dart';

class ShimmerBox extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  const ShimmerBox({
    super.key,
    this.width = double.infinity,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(borderRadius))),
    );
  }
}

class ShimmerWrap extends StatelessWidget {
  final Widget child;

  const ShimmerWrap({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade300,
      highlightColor: Colors.grey.shade100,
      child: child,
    );
  }
}

class ShimmerListPlaceholder extends StatelessWidget {
  final int itemCount;
  final double itemHeight;

  const ShimmerListPlaceholder(
      {super.key, this.itemCount = 6, this.itemHeight = 80});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const NeverScrollableScrollPhysics(),
      itemCount: itemCount,
      separatorBuilder: (_, __) => const SizedBox(height: 8),
      padding: const EdgeInsets.all(8),
      itemBuilder: (_, __) => ShimmerBox(height: itemHeight),
    );
  }
}

class ShimmerLoadingWidget extends StatelessWidget {
  final String? message;
  const ShimmerLoadingWidget({super.key, this.message});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Expanded(child: ShimmerListPlaceholder()),
      if (message != null)
        Padding(
            padding: const EdgeInsets.all(8),
            child: Text(message!, style: AppTextStyle.bodySmall)),
    ]);
  }
}
