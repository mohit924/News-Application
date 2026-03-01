import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';
import 'package:news_app/constants/app_assets.dart';
import 'package:news_app/constants/app_colors.dart';
import 'package:news_app/constants/app_strings.dart';
import 'package:news_app/features/providers/auth_provider.dart';
import 'package:news_app/utils/validators.dart';
import 'package:news_app/widgets/app_button.dart';
import 'package:news_app/widgets/app_textfield.dart';

class LoginPage extends ConsumerWidget {
  LoginPage({super.key});

  final email = TextEditingController();
  final pass = TextEditingController();
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
                    Container(
                      width: 54,
                      height: 54,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.18),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white.withOpacity(0.35),
                          width: 1.5,
                        ),
                      ),
                      child: ClipOval(
                        child: Image.asset(
                          AppAssets.newsLogo,
                          width: 54,
                          height: 54,
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => const Icon(
                            Icons.newspaper_rounded,
                            color: Colors.white,
                            size: 28,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      AppStrings.loginTitle,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      AppStrings.loginSubtitle,
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

Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: EdgeInsets.zero,
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            AppStrings.loginForgotPassword,
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      AppButton(
                        title: AppStrings.loginButton,
                        loading: state.loading,
                        onTap: () async {
                          if (!_formKey.currentState!.validate()) return;

                          final success = await ref
                              .read(authProvider.notifier)
                              .login(email.text.trim(), pass.text);

                          if (success && context.mounted) {
                            final box = Hive.box('authBox');
                            box.put('loggedIn', true);
                            context.go('/app/home');
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
                            AppStrings.loginNoAccount,
                            style: TextStyle(
                              color: AppColors.textMedium,
                              fontSize: 14,
                            ),
                          ),
                          GestureDetector(
                            onTap: () => context.push('/register'),
                            child: const Text(
                              AppStrings.registerTitle,
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
