import 'dart:async';

import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/app_text_field.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/form_validator.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:bookmarks_manager/ui/features/auth/reset_password/view_model/reset_password_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _step1FormKey = GlobalKey<FormState>();
  final _step2FormKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _isFormValid = ValueNotifier<bool>(false);

  int _step = 0;
  String _submittedEmail = '';
  int _resendCountdown = 0;
  Timer? _resendTimer;

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isFormValid.dispose();
    _resendTimer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    setState(() => _resendCountdown = 60);
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_resendCountdown == 0) {
        timer.cancel();
      } else {
        setState(() => _resendCountdown--);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewmodel = ref.read(resetPasswordViewmodelProvider.notifier);
    final vmState = ref.watch(resetPasswordViewmodelProvider);

    ref.listen(
      resetPasswordViewmodelProvider.select((s) => s.errorMessage),
      (_, error) {
        if (error != null) context.showErrorToast(error);
      },
    );

    return AppScaffold(
      showLoader: vmState.isLoading,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: _step == 0
              ? _Step1(
                  formKey: _step1FormKey,
                  emailController: _emailController,
                  isFormValid: _isFormValid,
                  onSubmit: () async {
                    final success = await viewmodel.requestOtp(
                      email: _emailController.text.trim(),
                    );
                    if (success && mounted) {
                      _isFormValid.value = false;
                      setState(() {
                        _step = 1;
                        _submittedEmail = _emailController.text.trim();
                      });
                      _startResendTimer();
                    }
                  },
                )
              : _Step2(
                  formKey: _step2FormKey,
                  email: _submittedEmail,
                  otpController: _otpController,
                  passwordController: _passwordController,
                  confirmPasswordController: _confirmPasswordController,
                  isFormValid: _isFormValid,
                  resendCountdown: _resendCountdown,
                  isResending: vmState.isResending,
                  onBack: () => setState(() {
                    _step = 0;
                    _isFormValid.value = false;
                    _resendTimer?.cancel();
                  }),
                  onResend: () async {
                    final success = await viewmodel.resendOtp(
                      email: _submittedEmail,
                    );
                    if (success && context.mounted) {
                      context.showSuccessToast(
                        'A new code has been sent to $_submittedEmail',
                      );
                      _startResendTimer();
                    }
                  },
                  onSubmit: () async {
                    final success = await viewmodel.resetPassword(
                      otp: _otpController.text.trim(),
                      password: _passwordController.text,
                      confirmedPassword: _confirmPasswordController.text,
                    );
                    if (success && context.mounted) {
                      context
                        ..showSuccessToast('Password reset successfully')
                        ..go(const LoginScreenRoute().location);
                    }
                  },
                ),
        ),
      ),
    );
  }
}

class _Step1 extends StatelessWidget {
  const _Step1({
    required this.formKey,
    required this.emailController,
    required this.isFormValid,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final TextEditingController emailController;
  final ValueNotifier<bool> isFormValid;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      onChanged: () {
        isFormValid.value = formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          Text(
            'Forgot password?',
            style: AppTextStyles.display.xs.bold,
          ),
          8.verticalSpace,
          Text(
            "Enter your email and we'll send you a reset code",
            style: AppTextStyles.text.md.regular.copyWith(
              color: AppColors.neutrals.shade600,
            ),
          ),
          40.verticalSpace,
          AppTextField(
            hintText: 'Email address',
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            inputAction: TextInputAction.done,
            autoCorrect: false,
            validator: (value) => value?.validateEmail(),
          ),
          32.verticalSpace,
          ValueListenableBuilder(
            valueListenable: isFormValid,
            builder: (_, isValid, _) => AppButton(
              label: 'Send reset code',
              isDisabled: !isValid,
              onPressed: onSubmit,
            ),
          ),
          24.verticalSpace,
          Center(
            child: TouchableOpacity(
              onTap: () => Navigator.of(context).pop(),
              child: Text(
                'Back to sign in',
                style: AppTextStyles.text.sm.semibold.copyWith(
                  color: AppColors.green.shade700,
                ),
              ),
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}

class _Step2 extends StatelessWidget {
  const _Step2({
    required this.formKey,
    required this.email,
    required this.otpController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.isFormValid,
    required this.resendCountdown,
    required this.isResending,
    required this.onBack,
    required this.onResend,
    required this.onSubmit,
  });

  final GlobalKey<FormState> formKey;
  final String email;
  final TextEditingController otpController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final ValueNotifier<bool> isFormValid;
  final int resendCountdown;
  final bool isResending;
  final VoidCallback onBack;
  final VoidCallback onResend;
  final VoidCallback onSubmit;

  String _formatCountdown(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final canResend = resendCountdown == 0 && !isResending;

    return Form(
      key: formKey,
      onChanged: () {
        isFormValid.value = formKey.currentState?.validate() ?? false;
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          24.verticalSpace,
          TouchableOpacity(
            onTap: onBack,
            child: Icon(
              Icons.arrow_back,
              size: 24.sp,
            ),
          ),
          24.verticalSpace,
          Text(
            'Reset password',
            style: AppTextStyles.display.xs.bold,
          ),
          8.verticalSpace,
          RichText(
            text: TextSpan(
              style: AppTextStyles.text.md.regular.copyWith(
                color: AppColors.neutrals.shade600,
              ),
              children: [
                const TextSpan(text: 'Enter the code sent to '),
                TextSpan(
                  text: email,
                  style: AppTextStyles.text.md.semibold,
                ),
              ],
            ),
          ),
          32.verticalSpace,
          AppTextField(
            hintText: '6-digit code',
            controller: otpController,
            keyboardType: TextInputType.number,
            inputAction: TextInputAction.next,
            inputFormatters: [
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(6),
            ],
            validator: (value) => value == null || value.length < 6
                ? 'Enter the 6-digit code'
                : null,
          ),
          16.verticalSpace,
          AppTextField(
            hintText: 'New password',
            controller: passwordController,
            isPassword: true,
            inputAction: TextInputAction.next,
            validator: (value) => value?.validatePassword(),
          ),
          16.verticalSpace,
          AppTextField(
            hintText: 'Confirm new password',
            controller: confirmPasswordController,
            isPassword: true,
            inputAction: TextInputAction.done,
            validator: (value) =>
                value?.validateConfirmPassword(passwordController.text),
          ),
          16.verticalSpace,
          Center(
            child: canResend
                ? TouchableOpacity(
                    onTap: onResend,
                    child: Text(
                      'Resend code',
                      style: AppTextStyles.text.sm.semibold.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                  )
                : RichText(
                    text: TextSpan(
                      style: AppTextStyles.text.sm.regular.copyWith(
                        color: AppColors.neutrals.shade600,
                      ),
                      children: [
                        const TextSpan(text: 'Resend code in '),
                        TextSpan(
                          text: _formatCountdown(resendCountdown),
                          style: AppTextStyles.text.sm.semibold,
                        ),
                      ],
                    ),
                  ),
          ),
          32.verticalSpace,
          ValueListenableBuilder(
            valueListenable: isFormValid,
            builder: (_, isValid, _) => AppButton(
              label: 'Reset password',
              isDisabled: !isValid,
              onPressed: onSubmit,
            ),
          ),
          24.verticalSpace,
        ],
      ),
    );
  }
}
