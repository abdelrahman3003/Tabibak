import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';

class DoctorItem extends StatelessWidget {
  const DoctorItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Expanded(
            child: Container(
              height: 150.h,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage("asssets/images/doctor.png"),
                    fit: BoxFit.cover,
                  )),
            ),
          ),
          SizedBox(width: 30),
          Expanded(
            child: Column(
              children: [
                Text(
                  "علي محمد احمد",
                  style: Apptextstyles.font16Blackebold,
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                SizedBox(height: 5),
                Text(
                  "عام  |  جامعه اسيوط",
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
