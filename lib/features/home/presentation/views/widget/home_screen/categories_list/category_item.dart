import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_redius.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem({
    super.key,
    required this.icon,
    required this.name,
    this.onTap,
  });

  final String icon;
  final String name;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.r12),
      splashColor: Colors.grey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 120.h,
            width: 120.w,
            padding: EdgeInsets.all(12.r),
            decoration: BoxDecoration(
              color: isDark
                  ? Theme.of(context).cardColor
                  : const Color(0xffEEF2FF),
              borderRadius: BorderRadius.circular(AppRadius.r16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: CachedNetworkImage(
              imageUrl: icon,
              fit: BoxFit.contain,
              placeholder: (context, url) => const Center(
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
              errorWidget: (context, url, error) => const Icon(
                Icons.broken_image,
                color: Colors.grey,
              ),
            ),
          ),
          SizedBox(height: 8.h),
          Text(
            name,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDark ? Colors.white70 : const Color(0xff475569),
                  fontWeight: FontWeight.w600,
                ),
          ),
        ],
      ),
    );
  }
}
