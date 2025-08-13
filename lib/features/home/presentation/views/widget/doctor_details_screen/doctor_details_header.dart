import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class DoctorDetailsHeader extends StatelessWidget {
  const DoctorDetailsHeader({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ImageCircle(
          urlImage:
              "https://www.bing.com/th/id/OIP.l96BdnBni68Vv9r_AgP7UgHaHa?w=224&h=211&c=8&rs=1&qlt=90&o=6&cb=thwsc4&pid=3.1&rm=2",
          radius: 60.r,
        ),
        12.hBox,
        Text("د. أحمد محمد", style: Apptextstyles.font18blackBold),
        Text("استشاري جراحة العظام", style: Apptextstyles.font16blackRegular),
        4.hBox,
        Text(
          "جامعة القاهرة",
          style: Apptextstyles.font14BlackReqular
              .copyWith(color: AppColors.textLight),
        ),
      ],
    );
  }
}
