import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/extensions/ref_extension.dart';
import 'package:bookmarks_manager/gen/assets.gen.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/app_text_field.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/form_validator.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:bookmarks_manager/ui/features/auth/login/view_model/login_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _isFormValid = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(loginMutation).isPending;

    ref.listen(loginMutation, (_, next) {
      if (next case MutationError(:final error)) {
        context.showErrorToast(error.asErrorMessage);
      }
      if (next case MutationSuccess()) {
        context.go(const BookmarksScreenRoute().location);
      }
    });

    return AppScaffold(
      showLoader: isLoading,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Form(
            key: _formKey,
            onChanged: () {
              _isFormValid.value = _formKey.currentState?.validate() ?? false;
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                56.verticalSpace,
                Center(
                  child: Assets.images.icon.image(
                    width: 64.w,
                    height: 64.h,
                    fit: BoxFit.contain,
                  ),
                ),
                40.verticalSpace,
                Text(
                  'Welcome back',
                  style: AppTextStyles.display.xs.bold.copyWith(
                    color: AppColors.neutrals.shade900,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Sign in to continue to your bookmarks',
                  style: AppTextStyles.text.md.regular.copyWith(
                    color: AppColors.neutrals.shade600,
                  ),
                ),
                32.verticalSpace,
                AppTextField(
                  hintText: 'Email address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  inputAction: TextInputAction.next,
                  autoCorrect: false,
                  validator: (value) => value?.validateEmail(),
                ),
                16.verticalSpace,
                AppTextField(
                  hintText: 'Password',
                  controller: _passwordController,
                  isPassword: true,
                  inputAction: TextInputAction.done,
                  validator: (value) => value == null || value.isEmpty
                      ? 'Password is required'
                      : null,
                ),
                12.verticalSpace,
                Align(
                  alignment: Alignment.centerRight,
                  child: TouchableOpacity(
                    onTap: () => const ResetPasswordRoute().push<void>(context),
                    child: Text(
                      'Forgot password?',
                      style: AppTextStyles.text.sm.semibold.copyWith(
                        color: AppColors.green.shade700,
                      ),
                    ),
                  ),
                ),
                32.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, _) {
                    return AppButton(
                      label: 'Sign in',
                      isDisabled: !isValid,
                      onPressed: () async {
                        await loginMutation.run(ref, (tsx) async {
                          return tsx
                              .get(loginViewmodelProvider.notifier)
                              .login(
                                email: _emailController.text,
                                password: _passwordController.text,
                              );
                        }).suppress();
                      },
                    );
                  },
                ),
                32.verticalSpace,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Don't have an account? ",
                        style: AppTextStyles.text.sm.regular.copyWith(
                          color: AppColors.neutrals.shade600,
                        ),
                      ),
                      TouchableOpacity(
                        onTap: () => const RegisterScreenRoute().go(context),
                        child: Text(
                          'Sign up',
                          style: AppTextStyles.text.sm.semibold.copyWith(
                            color: AppColors.green.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                24.verticalSpace,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
