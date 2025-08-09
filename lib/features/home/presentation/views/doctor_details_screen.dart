import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/doctor_details_header.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/doctor_info_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/doctor_details_screen/schedule_section.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class DoctorDetailsScreen extends StatelessWidget {
  const DoctorDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: 'تفاصيل الطبيب',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(alignment: Alignment.center, child: DoctorDetailsHeader()),
            20.hBox,
            TitelText(title: "'نبذة عن الطبيب'"),
            8.hBox,
            Text(
              "د. أحمد محمد هو استشاري متخصص في جراحة العظام بخبرة تزيد عن 15 عامًا. قام بعلاج مئات الحالات وشارك في العديد من المؤتمرات الطبية الدولية.",
              style: Apptextstyles.font16blackRegular.copyWith(height: 1.5),
              textAlign: TextAlign.justify,
            ),
            20.hBox,
            DoctorInfoSection(),
            const SizedBox(height: 20),
            TitelText(title: 'مواعيد العمل'),
            20.hBox,
            ScheduleSection(),
          ],
        ),
      ),
    );
  }
}
