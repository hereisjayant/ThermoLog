// ignore_for_file: must_be_immutable

import 'package:app/utils/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class SkeletonRect extends StatelessWidget {
  final double width;
  final double height;
  final double borderRadius;

  SkeletonRect(
      {required this.width, required this.height, required this.borderRadius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.width,
      height: this.height,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(this.borderRadius),
        color: skeletonGrey,
      ),
    );
  }
}

class SkeletonCircle extends StatelessWidget {
  final double radius;

  SkeletonCircle({required this.radius});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: this.radius,
      height: this.radius,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: skeletonGrey,
      ),
    );

  }
}

class ShimmerSkeleton extends StatelessWidget {
  final Widget child;
  bool? enabled;

  ShimmerSkeleton({required this.child, this.enabled=true});

  @override
  Widget build(BuildContext context) {
    return enabled! ? Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        enabled: enabled!,
        child: child
    ):child;

  }
}