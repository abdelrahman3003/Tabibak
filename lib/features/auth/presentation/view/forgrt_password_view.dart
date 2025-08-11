import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/helper/extention.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_text_formfiled.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';
import 'package:tabibak/features/home/presentation/views/widget/specialist_screen/app_bar_widget.dart';

class ForgrtPasswordView extends ConsumerStatefulWidget {
  const ForgrtPasswordView({super.key});

  @override
  ConsumerState<ForgrtPasswordView> createState() => _ForgrtPasswordViewState();
}

final sendOtpKey = GlobalKey<FormState>();

class _ForgrtPasswordViewState extends ConsumerState<ForgrtPasswordView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarWidget(
        title: "نسيت كلمة المرور",
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: sendOtpKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("أدخل بريدك الإلكتروني لاستلام رمز التحقق",
                  style: Apptextstyles.font20BlackRegular),
              20.hBox,
              AppTextFormFiled(
                  hint: "البريد الالكتروني",
                  controller: ref.read(emailConrtollerprovider),
                  validator: (value) => Validation.validateEmail(value),
                  prefixIcon: Icon(Icons.email_outlined, size: 24)),
              20.hBox,
              sendOtpbuttonStates()
            ],
          ),
        ),
      ),
    );
  }

  sendOtpbuttonStates() {
    final sendOtpState = ref.watch(authControllerProvider);
    bool isLoading = sendOtpState is SendOtpLoading;
    return AppButton(
      title: isLoading ? "جاري ارسال الرمز..." : "ارسال الرمز",
      isLoading: isLoading,
      onPressed: () {
        if (!isLoading && sendOtpKey.currentState!.validate()) {
          ref.read(authControllerProvider.notifier).sendOtp(context);
        }
      },
    );
  }
}
