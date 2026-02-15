import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:tabibak/core/extenstion/naviagation.dart';
import 'package:tabibak/core/helper/app_snack_bar.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/features/auth/presentation/manager/sign_in/sign_in_provider.dart';
import 'package:tabibak/features/auth/presentation/view/widget/signin_body.dart';

class SigninScreen extends ConsumerStatefulWidget {
  const SigninScreen({super.key});

  @override
  ConsumerState<SigninScreen> createState() => _SigninScreenState();
}

class _SigninScreenState extends ConsumerState<SigninScreen>
    with TickerProviderStateMixin {
  late AnimationController emailAnimationController;
  late Animation<Offset> emailAnimation;

  late AnimationController passwordAnimationController;
  late Animation<Offset> passwordAnimation;

  late AnimationController signinAnimationController;
  late Animation<Offset> signinAnimation;

  late AnimationController signinWithGoogleAnimationController;
  late Animation<Offset> signinWithGoogleAnimation;

  final signinKey = GlobalKey<FormState>();
  late TextEditingController emailController;
  late TextEditingController passwordController;

  @override
  void initState() {
    super.initState();
    emailController = TextEditingController();
    passwordController = TextEditingController();

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

    signinAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    signinAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: signinAnimationController, curve: Curves.easeOut));

    signinWithGoogleAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    signinWithGoogleAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: signinWithGoogleAnimationController, curve: Curves.easeOut));

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
    signinAnimationController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        signinWithGoogleAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    emailAnimationController.dispose();
    passwordAnimationController.dispose();
    signinAnimationController.dispose();
    signinWithGoogleAnimationController.dispose();
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInNotifierProvider, (previous, next) {
      if (next.isLoggedIn) {
        context.pushNamedAndRemoveUntil(Routes.layoutScreen, (route) => false);
      } else if (next.errorMessage != null) {
        showErrorSnackBar(next.errorMessage!);
      }
    });

    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SigninBody(
        signinKey: signinKey,
        emailController: emailController,
        passwordController: passwordController,
        emailAnimation: emailAnimation,
        passwordAnimation: passwordAnimation,
        signinAnimation: signinAnimation,
        googleAnimation: signinWithGoogleAnimation,
      ),
    ));
  }
}
