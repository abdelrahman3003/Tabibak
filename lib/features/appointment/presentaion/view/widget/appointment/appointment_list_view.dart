import 'package:flutter/material.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/appointment/data/model/appointment_model.dart';
import 'package:tabibak/features/appointment/presentaion/view/widget/appointment/appointment_card_item.dart';

class AppointmentListView extends StatelessWidget {
  const AppointmentListView({super.key, required this.appointmentList});
  final List<AppointmentModel> appointmentList;
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.zero,
      itemCount: appointmentList.length,
      itemBuilder: (context, index) {
        return AppointmentCardItem(
          appointment: appointmentList[index],
          onTap: () {
            context.pushNamed(Routes.appointmentDetailsScreen,
                arguments: appointmentList[index]);
          },
        );
      },
    );
  }
}
