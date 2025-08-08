import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/doctors_list/doctor_item.dart';

class DoctorListView extends StatelessWidget {
  const DoctorListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 5,
      itemBuilder: (context, index) => DoctorItem(),
    );
  }
}
