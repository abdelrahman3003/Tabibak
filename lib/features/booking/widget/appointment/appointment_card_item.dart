import 'package:flutter/material.dart';
import 'package:tabibak/core/theme/app_colors.dart';

class AppointmentCardItem extends StatelessWidget {
  const AppointmentCardItem({super.key, required this.booking});
  final Map<String, dynamic> booking;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.primary,
          child: const Icon(Icons.calendar_today, color: Colors.white),
        ),
        title: Text(
          booking["doctor"],
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          "${booking["specialty"]} • ${booking["date"]} • ${booking["time"]}",
          style: const TextStyle(fontSize: 13),
        ),
        trailing: _buildStatusChip(booking["status"]),
      ),
    );
  }

  Widget _buildStatusChip(String status) {
    Color chipColor;
    switch (status) {
      case "مؤكد":
        chipColor = Colors.green;
        break;
      case "ملغي":
        chipColor = Colors.red;
        break;
      default:
        chipColor = Colors.orange;
    }
    return Chip(
      label: Text(status, style: const TextStyle(color: Colors.white)),
      backgroundColor: chipColor,
    );
  }
}
