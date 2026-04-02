import 'package:bookmarks_manager/app/routing/app_routes.dart';
import 'package:bookmarks_manager/domain/error/app_exception.dart';
import 'package:bookmarks_manager/extensions/ref_extension.dart';
import 'package:bookmarks_manager/ui/core/extensions/toast_extension.dart';
import 'package:bookmarks_manager/ui/core/theme/colors.dart';
import 'package:bookmarks_manager/ui/core/theme/typography.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_button.dart';
import 'package:bookmarks_manager/ui/core/widgets/app_scaffold.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/app_text_field.dart';
import 'package:bookmarks_manager/ui/core/widgets/form/form_validator.dart';
import 'package:bookmarks_manager/ui/core/widgets/touchable_opacity.dart';
import 'package:bookmarks_manager/ui/features/auth/register/view_model/register_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/experimental/mutation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _isFormValid = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _isFormValid.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isLoading = ref.watch(registerMutation).isPending;
    ref.listen(registerMutation, (previous, next) {
      if (next case MutationError(:final error)) {
        context.showErrorToast(error.asErrorMessage);
      }
      if (next case MutationSuccess()) {
        context.go(const BookmarksScreenRoute().location);
      }
    });
    return AppScaffold(
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
                24.verticalSpace,
                Text(
                  'Create account',
                  style: AppTextStyles.display.xs.bold.copyWith(
                    color: AppColors.neutrals.shade900,
                  ),
                ),
                8.verticalSpace,
                Text(
                  'Join and start organising your bookmarks',
                  style: AppTextStyles.text.md.regular.copyWith(
                    color: AppColors.neutrals.shade600,
                  ),
                ),
                32.verticalSpace,
                Row(
                  children: [
                    Expanded(
                      child: AppTextField(
                        hintText: 'First name',
                        controller: _firstNameController,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'First name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                    12.horizontalSpace,
                    Expanded(
                      child: AppTextField(
                        hintText: 'Last name',
                        controller: _lastNameController,
                        inputAction: TextInputAction.next,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Last name is required';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                16.verticalSpace,
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
                  inputAction: TextInputAction.next,
                  validator: (value) => value?.validatePassword(),
                ),
                16.verticalSpace,
                AppTextField(
                  hintText: 'Confirm password',
                  controller: _confirmPasswordController,
                  isPassword: true,
                  inputAction: TextInputAction.done,
                  validator: (value) => value?.validateConfirmPassword(
                    _passwordController.text,
                  ),
                ),
                32.verticalSpace,
                ValueListenableBuilder(
                  valueListenable: _isFormValid,
                  builder: (context, isValid, _) {
                    return AppButton(
                      label: 'Create account',
                      onPressed: () async {
                        await registerMutation.run(ref, (tsx) async {
                          final notifier = tsx.get(
                            registerViewmodelProvider.notifier,
                          );
                          return notifier.createAccount(
                            firstName: _firstNameController.text,
                            lastName: _lastNameController.text,
                            password: _passwordController.text,
                            email: _emailController.text,
                          );
                        }).suppress();
                      },
                      isDisabled: !isValid,
                    );
                  },
                ),
                24.verticalSpace,
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Already have an account? ',
                        style: AppTextStyles.text.sm.regular.copyWith(
                          color: AppColors.neutrals.shade600,
                        ),
                      ),
                      TouchableOpacity(
                        onTap: () => const LoginScreenRoute().go(context),
                        child: Text(
                          'Sign in',
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
      showLoader: isLoading,
    );
  }
}
