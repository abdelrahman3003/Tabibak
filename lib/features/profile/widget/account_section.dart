import 'package:flutter/material.dart';

class AccountSection extends StatelessWidget {
  const AccountSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildLogoutTile(context),
      ],
    );
  }

  Widget _buildLogoutTile(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: ListTile(
        leading: const Icon(Icons.logout, color: Colors.red),
        title: const Text("تسجيل الخروج"),
        onTap: () {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: const Text("تأكيد تسجيل الخروج"),
              content: const Text("هل أنت متأكد أنك تريد تسجيل الخروج؟"),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("إلغاء"),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text("خروج"),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
