import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shimmer_animation/shimmer_animation.dart';

class CategoriesListShimmer extends StatelessWidget {
  const CategoriesListShimmer({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 90.h,
      child: ListView.builder(
        itemCount: 10,
        shrinkWrap: true,
        scrollDirection: Axis.horizontal,
        itemBuilder: (context, index) => Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Shimmer(
                duration: const Duration(milliseconds: 800),
                interval: const Duration(milliseconds: 300),
                color: Colors.grey,
                colorOpacity: 0.3,
                enabled: true,
                child: Container(
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
              SizedBox(height: 8.h),
              Shimmer(
                duration: const Duration(milliseconds: 800),
                interval: const Duration(milliseconds: 300),
                color: Colors.grey,
                colorOpacity: 0.3,
                enabled: true,
                child: Container(
                  width: 50.w,
                  height: 10.h,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(4.r),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
