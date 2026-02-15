import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_up/sign_up_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/signup_body.dart';

class SignupView extends ConsumerStatefulWidget {
  const SignupView({super.key});

  @override
  ConsumerState<SignupView> createState() => _SignupViewState();
}

class _SignupViewState extends ConsumerState<SignupView>
    with TickerProviderStateMixin {
  late AnimationController nameAnimationController;
  late Animation<Offset> nameAnimation;
  late AnimationController emailAnimationController;
  late Animation<Offset> emailAnimation;

  late AnimationController passwordAnimationController;
  late Animation<Offset> passwordAnimation;

  late AnimationController signupAnimationController;
  late Animation<Offset> signupAnimation;

  final signUpFormKey = GlobalKey<FormState>();
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController();
    emailController = TextEditingController();
    passwordController = TextEditingController();

    nameAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    nameAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: nameAnimationController, curve: Curves.easeOut));
    emailAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    emailAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
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
  void dispose() {
    nameAnimationController.dispose();
    emailAnimationController.dispose();
    passwordAnimationController.dispose();
    signupAnimationController.dispose();
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signUpNotifierProvider, (previous, next) {
      if (next.isSignedUp) {
        context.pop();
        context.pushNamedAndRemoveUntil(Routes.layoutScreen, (route) => false);
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SignupBody(
        signUpFormKey: signUpFormKey,
        nameController: nameController,
        emailController: emailController,
        passwordController: passwordController,
        nameAnimation: nameAnimation,
        emailAnimation: emailAnimation,
        passwordAnimation: passwordAnimation,
        signupAnimation: signupAnimation,
      ),
    ));
  }
}
