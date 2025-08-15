import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/routes.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/doctors_list/doctor_item.dart';

class DoctorListView extends StatelessWidget {
  const DoctorListView({super.key, required this.doctorList});
  final List<DoctorModel> doctorList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: DoctorItem(
          doctorModel: doctorList[index],
          onTap: () {
            context.pushNamed(Routes.doctorDetailsScreen);
          },
        ),
      ),
    );
  }
}
