import 'package:flutter/material.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/booking/appointment_success_arg.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/image_circle.dart';

class BookingSuccessScreen extends StatelessWidget {
  const BookingSuccessScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appointmentSuccessArg =
        ModalRoute.of(context)?.settings.arguments as AppointmentSuccessArg;
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
