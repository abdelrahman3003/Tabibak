import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/doctors_list/doctor_item.dart';

class DoctorList extends StatelessWidget {
  const DoctorList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 6,
      itemBuilder: (context, index) => DoctorItem(),
    );
  }
}
