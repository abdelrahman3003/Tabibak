import 'package:flutter/material.dart';
import 'package:tabibak/core/helper/dialogs.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/features/booking/widget/booking_date.dart';
import 'package:tabibak/features/booking/widget/booking_header.dart';
import 'package:tabibak/features/booking/widget/booking_time.dart';
import 'package:tabibak/features/home/presentation/views/widget/home_screen/titel_text.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class BookingScreen extends StatefulWidget {
  const BookingScreen({super.key});

  @override
  State<BookingScreen> createState() => _BookingScreenState();
}

class _BookingScreenState extends State<BookingScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(title: "حجز كشف"),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            20.hBox,
            BookingHeader(),
            20.hBox,
            TitelText(title: "اختر التاريخ"),
            8.hBox,
            BookingDate(),
            20.hBox,
            TitelText(title: "اختر الساعة"),
            8.hBox,
            BookingTime(),
            Spacer(),
            AppButton(
              title: "تأكيد الحجز",
              onPressed: () {
                // Dialogs.errorDialog(
                //     context, "يرجى اختيار التاريخ والساعة قبل المتابعة");
                Dialogs.successDialog(
                    context, "تم الحجز", "تم حجز الكشف بنجاح!");
              },
            )
          ],
        ),
      ),
    );
  }
}
