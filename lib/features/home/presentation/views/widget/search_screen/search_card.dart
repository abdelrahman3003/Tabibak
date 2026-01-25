import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/features/home/data/model/doctor_summary.dart';
import 'package:tabibak/features/home/presentation/manager/search_provider/search_provider.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';
import 'package:tabibak/features/home/presentation/views/widget/search_screen/delete_bottom_sheet.dart';

class SearchCard extends ConsumerWidget {
  const SearchCard(
      {super.key, required this.doctorSummary, this.onTap, this.onDelete});
  final DoctorSummary doctorSummary;
  final Function()? onTap;
  final void Function()? onDelete;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ListTile(
        contentPadding: EdgeInsets.zero,
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
          doctorSummary.clinicData?.clinicAddress?.address ?? "",
          style: Theme.of(context).textTheme.bodySmall,
        ),
        trailing: IconButton(
          icon: const Icon(Icons.more_vert, size: 18),
          onPressed: () {
            showModalBottomSheet(
              context: context,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
              ),
              builder: (context) {
                return DeleteBottomSheet(
                  doctorSummary: doctorSummary,
                  onDelete: () {
                    context.pop();
                    ref
                        .read(searchProviderNotifer.notifier)
                        .removeDoctorFromCache(doctorSummary.id);
                  },
                );
              },
            );
          },
        ));
  }
}
