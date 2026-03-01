import 'package:flutter/material.dart';
import 'package:news_app/constants/app_colors.dart';

class AppButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;
  final bool loading;

  const AppButton({
    super.key,
    required this.title,
    required this.onTap,
    this.loading = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: DecoratedBox(
        decoration: BoxDecoration(
          gradient: loading
              ? null
              : const LinearGradient(
                  colors: [AppColors.gradientStart, AppColors.gradientEnd],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
          color: loading ? AppColors.divider : null,
          borderRadius: BorderRadius.circular(14),
          boxShadow: loading
              ? []
              : [
                  BoxShadow(
                    color: AppColors.primary.withOpacity(0.35),
                    blurRadius: 12,
                    offset: const Offset(0, 5),
                  ),
                ],
        ),
        child: ElevatedButton(
          onPressed: loading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
          ),
          child: loading
              ? const SizedBox(
                  height: 22,
                  width: 22,
                  child: CircularProgressIndicator(
                    color: Colors.white,
                    strokeWidth: 2.5,
                  ),
                )
              : Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
        ),
      ),
    );
  }
}
