import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/doctor/presentation/manager/doctor/doctor_provider.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart';

class DoctorSpecialtyListView extends StatelessWidget {
  const DoctorSpecialtyListView({super.key, required this.doctorList});
  final List<DoctorModel> doctorList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: doctorList.length,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Consumer(builder: (context, ref, _) {
          return DoctorItem(
            doctorSummary: doctorList[index],
            onTap: () async {
              ref.read(doctorIdProvider.notifier).state =
                  doctorList[index].doctorId;
              context.pushNamed(Routes.doctorDetailsScreen);
            },
          );
        }),
      ),
    );
  }
}
