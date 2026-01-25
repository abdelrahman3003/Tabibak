import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/manager/home_provider/home_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart';

class DoctorListView extends StatelessWidget {
  const DoctorListView({super.key, required this.doctorsSummaryList});
  final List<DoctorSummary> doctorsSummaryList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Consumer(builder: (context, ref, _) {
          return DoctorItem(
            doctorSummary: doctorsSummaryList[index],
            onTap: () async {
              ref
                  .read(homeControllerProvider.notifier)
                  .goToDoctorDetails(context, doctorsSummaryList[index].id);
            },
          );
        }),
      ),
    );
  }
}
