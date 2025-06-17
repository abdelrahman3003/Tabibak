import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/class/naviagtion.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_text_formfiled.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_textfiled.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

late AnimationController nameAnimationController;
late Animation<Offset> nameAnimation;
late AnimationController emailAnimationController;
late Animation<Offset> emailAnimation;

late AnimationController passwordAnimationController;
late Animation<Offset> passwordAnimation;

late AnimationController signupAnimationController;
late Animation<Offset> signupAnimation;

class _SignupViewState extends ConsumerState<SignupView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();
    nameAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    nameAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // من اليمين
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: nameAnimationController, curve: Curves.easeOut));
    emailAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    emailAnimation = Tween<Offset>(
      begin: const Offset(1, 0), // من اليمين
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: emailAnimationController, curve: Curves.easeOut));

    passwordAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    passwordAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: passwordAnimationController, curve: Curves.easeOut));

    signupAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    signupAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: signupAnimationController, curve: Curves.easeOut));

    nameAnimationController.forward();
    nameAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        emailAnimationController.forward();
      }
    });
    emailAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        passwordAnimationController.forward();
      }
    });
    passwordAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        signupAnimationController.forward();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: signupBody(context),
    ));
  }

  Column signupBody(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SlideTransition(
          position: nameAnimation,
          child: AppTextFormFiled(
              controller: ref.read(nameConrtollerprovider),
              hint: "الإسم",
              prefixIcon: Icon(Icons.person_3_outlined, size: 24)),
        ),
        const SizedBox(height: 15),
        SlideTransition(
          position: emailAnimation,
          child: AppTextFormFiled(
              hint: "الايميل",
              controller: ref.read(emailConrtollerprovider),
              prefixIcon: Icon(Icons.email_outlined, size: 24)),
        ),
        const SizedBox(height: 15),
        SlideTransition(
            position: passwordAnimation,
            child: PasswordTextfiled(
              controller: ref.read(passordConrtollerprovider),
            )),
        const SizedBox(height: 60),
        signupButtonStates(),
        const SizedBox(height: 40),
        DoHaveAccount(
            title: "هل لديك حساب بالفعل؟",
            subtitle: "تسجيل الدخول",
            onTap: () {
              context.pushNamed(Routes.singinView);
            })
      ],
    );
  }

  SlideTransition signupButtonStates() {
    final signupState = ref.watch(authControllerProvider);
    bool isLoading = signupState is SignUpLoading;
    return SlideTransition(
        position: signupAnimation,
        child: AppButton(
          title: isLoading ? "جاري إنشاء الحساب..." : "إنشاء الحساب",
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading) {
              ref.read(authControllerProvider.notifier).singUp(context);
            }
          },
        ));
  }
}
