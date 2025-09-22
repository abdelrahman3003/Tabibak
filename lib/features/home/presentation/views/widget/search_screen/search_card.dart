import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class SearchCard extends StatelessWidget {
  const SearchCard({super.key, required this.doctorSummary, this.onTap});
  final DoctorSummary doctorSummary;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: ImageCircle(
        radius: 18.r,
        urlImage: doctorSummary.image,
      ),
      title: Text(
        doctorSummary.name ?? "",
        style: Theme.of(context).textTheme.bodyLarge,
      ),
      subtitle: Text(
        doctorSummary.clinicData?.address ?? "",
        style: Theme.of(context).textTheme.bodySmall,
      ),
    );
  }
}
