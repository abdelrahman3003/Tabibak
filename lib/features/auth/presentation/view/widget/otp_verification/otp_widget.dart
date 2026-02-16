import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class OtpWidget extends StatelessWidget {
  const OtpWidget({super.key, this.onChanged});
  final Function(String)? onChanged;
  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.ltr,
        child: Pinput(
            length: 6,
            onChanged: onChanged,
            defaultPinTheme: PinTheme(
              width: 50.w,
              height: 50.h,
              textStyle: Theme.of(context)
                  .textTheme
                  .bodyLarge!
                  .copyWith(fontSize: 20.sp),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.primary),
                borderRadius: BorderRadius.circular(8),
              ),
            )));
  }
}
