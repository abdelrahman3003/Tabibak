import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/gen/assets.gen.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
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
                  "Dr. Randy Wigham",
                  style: Apptextstyles.font16Blackebold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 5),
                Text(
                  "General  |  RSUD Gatot Subroto",
                  style: Apptextstyles.font14BlackReqular,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
