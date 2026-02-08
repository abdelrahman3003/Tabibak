import 'package:flutter/material.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/home/data/model/doctor_model.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final doctorModel =
        ModalRoute.of(context)?.settings.arguments as DoctorModel;
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "تأكيد الحجز",
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              20.hBox,
              Text(
                "تم الحجز بنجاح",
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(),
              ),
              40.hBox,
              Text(
                "تم حجز موعدك بنجاح ",
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Row(
                children: [
                  ImageCircle(
                    radius: 16,
                    urlImage: doctorModel.image,
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
