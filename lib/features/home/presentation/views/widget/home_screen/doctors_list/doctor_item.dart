import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/gen/assets.gen.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({super.key, this.onTap});
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(Constants.radius),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Row(
          children: [
            Container(
              height: 110.h,
              width: 100.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(Assets.images.doctor.path),
                    fit: BoxFit.cover,
                  )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "د. احمد علي",
                    style: Apptextstyles.font16Blackebold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  5.hBox,
                  Text(
                    "عام | مستشفي فاو العام",
                    style: Apptextstyles.font14BlackReqular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.hBox,
                  Text(
                    "نجع حمادي",
                    style: Apptextstyles.font14BlackReqular
                        .copyWith(fontSize: 12.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
