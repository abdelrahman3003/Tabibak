import 'package:flutter/material.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class ShimmerWidget extends StatelessWidget {
  const ShimmerWidget({
    super.key,
    required this.height,
    required this.width,
    this.radius,
    this.isCircle = false,
  });

  final double height;
  final double width;
  final double? radius;
  final bool isCircle;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: isCircle
          ? BorderRadius.circular(1000)
          : BorderRadius.circular(radius ?? 0),
      child: Shimmer(
        duration: const Duration(milliseconds: 800),
        interval: const Duration(milliseconds: 300),
        color: Colors.grey,
        colorOpacity: 0.3,
        enabled: true,
        child: Container(
          height: height,
          width: width,
          color: Colors.grey.shade300,
        ),
      ),
    );
  }
}
