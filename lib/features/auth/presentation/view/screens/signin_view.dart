import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:tabibak/core/constatnt/app_string.dart';
import 'package:tabibak/core/extenstion/naviagrion.dart';
import 'package:tabibak/core/extenstion/spacing.dart';
import 'package:tabibak/core/helper/validation.dart';
import 'package:tabibak/core/routing/routes.dart';
import 'package:tabibak/core/theme/appTextStyles.dart';
import 'package:tabibak/core/theme/app_colors.dart';
import 'package:tabibak/core/widgets/app_button.dart';
import 'package:tabibak/core/widgets/app_text_formfiled.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_controller.dart';
import 'package:tabibak/features/auth/presentation/manager/auth_states.dart';
import 'package:tabibak/features/auth/presentation/view/widget/do_you_have_account.dart';
import 'package:tabibak/features/auth/presentation/view/widget/password_textfiled.dart';
import 'package:tabibak/gen/assets.gen.dart';

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
late AnimationController signinWithGoogelAnimationController;
late Animation<Offset> signinWithGoogelAnimation;
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

    signinWithGoogelAnimationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    signinWithGoogelAnimation = Tween<Offset>(
      begin: const Offset(1, 0),
      end: Offset.zero,
    ).animate(CurvedAnimation(
        parent: signinWithGoogelAnimationController, curve: Curves.easeOut));
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
        signinWithGoogelAnimationController.forward();
      }
    });
  }

  @override
  void dispose() {
    emailAnimationController.dispose();
    passwordAnimationController.dispose();
    signinAnimationController.dispose();
    signinWithGoogelAnimationController.dispose();
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
                  hint: AppStrings.email,
                  controller:
                      ref.read(authControllerProvider.notifier).emailController,
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
              controller:
                  ref.read(authControllerProvider.notifier).passwordController,
            ),
          ),
          const SizedBox(height: 20),
          InkWell(
            onTap: () {
              context.pushNamed(Routes.forgrtPasswordView);
            },
            child: Align(
              alignment: Alignment.centerRight,
              child: Text(
                AppStrings.forgotPassword,
                style: Apptextstyles.font16blackRegular
                    .copyWith(color: AppColors.primary),
              ),
            ),
          ),
          const SizedBox(height: 30),
          loginbuttonStates(),
          20.hBox,
          signinWuthGoogleButton(context),
          const SizedBox(height: 60),
          DoHaveAccount(
            title: AppStrings.noAccount,
            subtitle: AppStrings.createAccount,
            onTap: () {
              context.pop();
              context.pushNamed(Routes.singupView);
              ref.read(authControllerProvider.notifier).cleartextformData();
            },
          )
        ],
      ),
    );
  }

  InkWell signinWuthGoogleButton(BuildContext context) {
    return InkWell(
      onTap: () {
        ref.read(authControllerProvider.notifier).nativeGoogleSignIn(context);
      },
      child: SlideTransition(
        position: signinWithGoogelAnimation,
        child: Consumer(builder: (context, ref, _) {
          final state = ref.watch(authControllerProvider);
          return Container(
            padding: EdgeInsets.symmetric(vertical: 16),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius: 8.radius,
              border: Border.all(color: AppColors.textLight),
            ),
            child: state is LoginWithGoogleLoading
                ? SizedBox(
                    height: 30.h,
                    width: 30.h,
                    child: Center(
                        child: CircularProgressIndicator(
                      color: AppColors.primary,
                    )),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SvgPicture.asset(Assets.icons.googleIcon,
                          width: 24.h, height: 24.w),
                      10.wBox,
                      Text(
                        AppStrings.loginWithGoogle,
                        style: Apptextstyles.font16blackRegular,
                      )
                    ],
                  ),
          );
        }),
      ),
    );
  }

  SlideTransition loginbuttonStates() {
    final loginState = ref.watch(authControllerProvider);
    bool isLoading = loginState is LoginLoading;
    return SlideTransition(
        position: signinAnimation,
        child: AppButton(
          title: isLoading ? "${AppStrings.loggingIn}.." : AppStrings.login,
          isLoading: isLoading,
          onPressed: () {
            if (!isLoading && signinKey.currentState!.validate()) {
              ref.read(authControllerProvider.notifier).login(context);
            }
          },
        ));
  }
}
