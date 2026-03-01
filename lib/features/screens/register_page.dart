import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/auth_provider.dart';
import 'package:news_app/utils/validators.dart';
import 'package:news_app/widgets/app_button.dart';
import 'package:news_app/widgets/app_textfield.dart';

class RegisterPage extends ConsumerWidget {
  RegisterPage({super.key});

  final email = TextEditingController();
  final pass = TextEditingController();
  final confirmPass = TextEditingController();
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
                    const Text(
                      AppStrings.registerTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.registerSubtitle,
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
                        controller: pass,
                        hint: AppStrings.passwordHint,
                        obscure: true,
                        prefixIcon: Icons.lock_outline_rounded,
                        validator: Validators.password,
                      ),

                      AppTextField(
                        controller: confirmPass,
                        hint: AppStrings.confirmPasswordLabel,
                        obscure: true,
                        prefixIcon: Icons.lock_reset_rounded,
                        validator: (val) =>
                            Validators.confirmPassword(val, pass.text),
                      ),

                      const SizedBox(height: 8),

                      AppButton(
                        title: AppStrings.registerButton,
                        loading: state.loading,
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await ref
                              .read(authProvider.notifier)
                              .register(email.text.trim(), pass.text);

                          if (success && context.mounted) {
                            context.pop();
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

                      const SizedBox(height: 32),

Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            AppStrings.registerHaveAccount,
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.pop(),
                            child: const Text(
                              AppStrings.registerSignIn,
                              style: TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w700,
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ],
                      ),
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
