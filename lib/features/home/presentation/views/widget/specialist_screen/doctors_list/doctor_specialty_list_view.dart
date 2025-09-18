import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/router.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/manager/home_controller.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/doctors_list/doctor_specialty_item.dart';

class DoctorSpecialtyListView extends StatelessWidget {
  const DoctorSpecialtyListView({super.key, required this.doctorsSummaryList});
  final List<DoctorSummary> doctorsSummaryList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctorsSummaryList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Consumer(builder: (context, ref, _) {
          return DoctorSpecialtyItem(
            doctorSummary: doctorsSummaryList[index],
            onTap: () async {
              context.pushNamed(Routes.doctorDetailsScreen);
              await ref
                  .read(homeControllerPrvider.notifier)
                  .getDoctorData(doctorsSummaryList[index].id);
            },
          );
        }),
      ),
    );
  }
}
