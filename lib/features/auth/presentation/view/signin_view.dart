import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/class/naviagtion.dart';
import 'package:tabibak/core/class/routes.dart';
import 'package:tabibak/core/class/validation.dart';
import 'package:tabibak/core/theme/app_button.dart';
import 'package:tabibak/core/theme/app_text_formfiled.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/controllers/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_textfiled.dart';

class SigninView extends ConsumerStatefulWidget {
  const SigninView({super.key});

  @override
  ConsumerState<SigninView> createState() => _SigninViewState();
}

late AnimationController emailAnimationController;
late Animation<Offset> emailAnimation;

late AnimationController passwordAnimationController;
late Animation<Offset> passwordAnimation;

late AnimationController signinAnimationController;
late Animation<Offset> signinAnimation;
final signinKey = GlobalKey<FormState>();

class _SigninViewState extends ConsumerState<SigninView>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

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

    signinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    signinAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: signinAnimationController, curve: Curves.easeOut));

    emailAnimationController.forward();
    emailAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        passwordAnimationController.forward();
      }
    });
    passwordAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        signinAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    emailAnimationController.dispose();
    passwordAnimationController.dispose();
    signinAnimationController.dispose();
    ref.read(emailConrtollerprovider).dispose();
    ref.read(nameConrtollerprovider).dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: signinBody(context),
    ));
  }

  signinBody(BuildContext context) {
    return Form(
      key: signinKey,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SlideTransition(
              position: emailAnimation,
              child: AppTextFormFiled(
                  hint: "الإيميل",
                  controller: ref.read(emailConrtollerprovider),
                  validator: (value) {
                    return Validation.validateEmail(value);
                  },
                  prefixIcon: Icon(Icons.email_outlined, size: 24))),
          const SizedBox(height: 30),
          SlideTransition(
            position: passwordAnimation,
            child: PasswordTextfiled(
              validator: (value) {
                return Validation.validatePassord(value);
              },
              controller: ref.read(passordConrtollerprovider),
            ),
          ),
          const SizedBox(height: 30),
          loginbuttonStates(),
          const SizedBox(height: 60),
          DoHaveAccount(
            title: "هل ليس لديك حساب؟",
            subtitle: "إنشاء حساب",
            onTap: () {
              context.pop();
              context.pushNamed(Routes.singupView);
            },
          )
        ],
      ),
    );
  }

  SlideTransition loginbuttonStates() {
    final loginState = ref.watch(authControllerProvider);
    bool isLoading = loginState is LoginLoading;
    return SlideTransition(
        position: signinAnimation,
        child: AppButton(
          title: isLoading ? "جاري تسجيل الدخول..." : "تسجيل الدخول",
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading && signinKey.currentState!.validate()) {
              ref.read(authControllerProvider.notifier).login(context);
            }
          },
        ));
  }
}
