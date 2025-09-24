import 'package:flutter/material.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class BookingHeader extends StatelessWidget {
  const BookingHeader({super.key, required this.doctorModel});
  final DoctorModel doctorModel;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        ImageCircle(urlImage: doctorModel.image),
        SizedBox(width: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              doctorModel.name ?? "",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            Text(doctorModel.specialties?.name ?? "",
                style: Theme.of(context)
                    .textTheme
                    .titleMedium!
                    .copyWith(color: Theme.of(context).colorScheme.secondary)),
            Text(
                doctorModel.clinicData?.consultationFee == null
                    ? AppStrings.consultationPriceNotAvailable
                    : "${AppStrings.consultationPrice} : ${doctorModel.clinicData?.consultationFee} ${AppStrings.egp}",
                style: TextStyle(color: Colors.blue)),
          ],
        )
      ],
    );
  }
}
