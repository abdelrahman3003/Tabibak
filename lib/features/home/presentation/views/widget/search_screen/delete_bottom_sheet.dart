import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class DeleteBottomSheet extends StatelessWidget {
  const DeleteBottomSheet(
      {super.key, required this.doctorSummary, this.onDelete});
  final DoctorSummary doctorSummary;
  final Function()? onDelete;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          10.hBox,
          ListTile(
            title: Text(
              doctorSummary.name!,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            leading: ImageCircle(radius: 25.r, urlImage: doctorSummary.image),
          ),
          10.hBox,
          Divider(color: Theme.of(context).colorScheme.secondary),
          ListTile(
            leading: Container(
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Theme.of(context).colorScheme.secondary),
                child: const Icon(
                  Icons.delete,
                  size: 28,
                )),
            title: Text(
              AppStrings.delete,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge!
                  .copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Text(
              "Remove this from your search history",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
            onTap: onDelete,
          ),
        ],
      ),
    );
  }
}
