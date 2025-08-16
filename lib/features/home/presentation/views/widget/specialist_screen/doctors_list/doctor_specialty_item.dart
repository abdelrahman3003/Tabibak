import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';

class DoctorSpecialtyItem extends StatelessWidget {
  const DoctorSpecialtyItem(
      {super.key, this.onTap, required this.doctorSummary});
  final Function()? onTap;
  final DoctorSummary doctorSummary;
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
                  color: AppColors.second,
                  image: doctorSummary.image == null
                      ? null
                      : DecorationImage(
                          image:
                              CachedNetworkImageProvider(doctorSummary.image!),
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorSummary.name ?? "",
                    style: Apptextstyles.font16Blackebold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  5.hBox,
                  Text(
                    doctorSummary.specialties?.name ?? "",
                    style: Apptextstyles.font14BlackReqular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.hBox,
                  Text(
                    doctorSummary.clinicData?.address ?? "مكان غير معروف",
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
