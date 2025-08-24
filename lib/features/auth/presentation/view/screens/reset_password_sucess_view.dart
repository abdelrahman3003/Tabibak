import 'package:flutter/material.dart';
import 'package:tabibak/core/utls/extention.dart';
import 'package:tabibak/core/utls/routes.dart';
import 'package:tabibak/core/widgets/app_button.dart';

class ResetPasswordSucessView extends StatelessWidget {
  const ResetPasswordSucessView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle,
                  color: Colors.lightGreen, size: 120),
              const SizedBox(height: 20),
              const Text(
                "تم تغيير كلمة المرور بنجاح 🎉",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              const Text(
                "يمكنك الآن تسجيل الدخول باستخدام كلمة المرور الجديدة.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              AppButton(
                title: "الذهاب لتسجيل الدخول",
                onPressed: () {
                  context.pushNamedAndRemoveUntil(
                    Routes.singinView,
                    predicate: (route) => false,
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
