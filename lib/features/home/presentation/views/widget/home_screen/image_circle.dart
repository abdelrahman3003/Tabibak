import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ImageCircle extends StatelessWidget {
  const ImageCircle({
    super.key,
    required this.urlImage,
    this.radius,
  });
  final String urlImage;
  final double? radius;
  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 28.r,
      backgroundImage: CachedNetworkImageProvider(
        urlImage,
      ),
    );
  }
}
