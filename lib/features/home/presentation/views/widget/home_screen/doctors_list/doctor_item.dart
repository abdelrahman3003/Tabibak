import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/string_constants.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({super.key, this.onTap, required this.doctorModel});
  final Function()? onTap;
  final DoctorModel doctorModel;
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
                  image: doctorModel.image == null
                      ? null
                      : DecorationImage(
                          image: CachedNetworkImageProvider(doctorModel.image!),
                          fit: BoxFit.cover,
                        )),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    doctorModel.name ?? "",
                    style: Apptextstyles.font16Blackebold,
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                  ),
                  5.hBox,
                  Text(
                    doctorModel.specialty ?? "",
                    style: Apptextstyles.font14BlackReqular,
                    overflow: TextOverflow.ellipsis,
                  ),
                  5.hBox,
                  Text(
                    doctorModel.clinicData?.address ?? "مكان غير معروف",
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
