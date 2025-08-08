import 'package:flutter/material.dart';
import 'package:tabibak/features/home/presentation/views/home_screen/doctors_list/doctor_item.dart';

class DoctorList extends StatelessWidget {
  const DoctorList({super.key});

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate(
        childCount: 5,
        (context, index) => DoctorItem(),
      ),
    );
  }
}
