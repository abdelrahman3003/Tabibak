import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class CategoryItem extends StatelessWidget {
  const CategoryItem(
      {super.key, required this.icon, required this.name, this.onTap});
  final String icon;
  final String name;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8.r),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 50.h,
              width: 60.w,
              padding: EdgeInsets.all(8),
              margin: EdgeInsets.symmetric(horizontal: 14.w),
              decoration: BoxDecoration(
                  shape: BoxShape.circle, color: AppColors.second),
              child: CachedNetworkImage(
                imageUrl: icon,
                errorWidget: (context, url, error) => SizedBox(),
              )),
          SizedBox(height: 5),
          Text(
            name,
            style: Apptextstyles.font14BlackReqular,
          )
        ],
      ),
    );
  }
}
