import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/auth_provider.dart';
import 'package:news_app/utils/validators.dart';
import 'package:news_app/widgets/app_button.dart';
import 'package:news_app/widgets/app_textfield.dart';

class ForgotPasswordPage extends ConsumerWidget {
  ForgotPasswordPage({super.key});

  final email = TextEditingController();
  final newPass = TextEditingController();
  final confirmNewPass = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(authProvider);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [

              Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 48, 24, 40),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.gradientStart, AppColors.gradientEnd],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    GestureDetector(
                      onTap: () => context.pop(),
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.18),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.15),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.lock_reset_rounded,
                        color: Colors.white,
                        size: 28,
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      AppStrings.forgotTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.forgotSubtitle,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white.withOpacity(0.75),
                      ),
                    ),
                  ],
                ),
              ),

Padding(
                padding: const EdgeInsets.all(24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),

                      AppTextField(
                        controller: email,
                        hint: AppStrings.emailHint,
                        prefixIcon: Icons.mail_outline_rounded,
                        validator: Validators.email,
                      ),

                      AppTextField(
                        controller: newPass,
                        hint: AppStrings.newPasswordLabel,
                        obscure: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: Validators.password,
                      ),

                      AppTextField(
                        controller: confirmNewPass,
                        hint: AppStrings.confirmPasswordLabel,
                        obscure: true,
                        prefixIcon: Icons.lock_reset_rounded,
                        validator: (val) =>
                            Validators.confirmPassword(val, newPass.text),
                      ),

                      const SizedBox(height: 8),

                      AppButton(
                        title: AppStrings.forgotButton,
                        loading: state.loading,
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;

                          await ref
                              .read(authProvider.notifier)
                              .resetPassword(email.text.trim(), newPass.text);

                          if (context.mounted) {
                            if (ref.read(authProvider).error == null) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: const Row(
                                    children: [
                                      Icon(
                                        Icons.check_circle_outline,
                                        color: Colors.white,
                                        size: 18,
                                      ),
                                      SizedBox(width: 8),
                                      Text(AppStrings.forgotSuccess),
                                    ],
                                  ),
                                  backgroundColor: AppColors.success,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                              );
                              context.pop();
                            }
                          }
                        },
                      ),

                      if (state.error != null) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.error.withOpacity(0.08),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.error.withOpacity(0.3),
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.error_outline,
                                color: AppColors.error,
                                size: 18,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Text(
                                  state.error!,
                                  style: const TextStyle(
                                    color: AppColors.error,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
