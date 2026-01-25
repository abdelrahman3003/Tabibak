import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/doctor/presentaion/manager/doctor_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart';

class DoctorListView extends StatelessWidget {
  const DoctorListView({super.key, required this.doctorsSummaryList});
  final List<DoctorModel> doctorsSummaryList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctorsSummaryList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Consumer(builder: (context, ref, _) {
          return DoctorItem(
            doctorSummary: doctorsSummaryList[index],
            onTap: () async {
              ref.read(doctorIdProvider.notifier).state =
                  doctorsSummaryList[index].doctorId;
              context.pushNamed(Routes.doctorDetailsScreen);
            },
          );
        }),
      ),
    );
  }
}
