import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class ImageCircle extends StatelessWidget {
  const ImageCircle({
    super.key,
    this.urlImage,
    this.radius,
  });
  final String? urlImage;
  final double? radius;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundColor: Theme.of(context).colorScheme.secondary,
      radius: radius ?? 28.r,
      backgroundImage: (urlImage != null && urlImage!.isNotEmpty)
          ? CachedNetworkImageProvider(urlImage!)
          : null,
      child: (urlImage == null || urlImage!.isEmpty)
          ? Icon(
              Icons.person,
              size: (radius ?? 28.r) * 1.2,
              color: AppColors.primary.withValues(alpha: 0.5),
            )
          : null,
    );
  }
}
