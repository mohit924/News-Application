import 'package:flutter/material.dart';
import 'package:news_app/constants/app_colors.dart';

class AppTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscure;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;

  const AppTextField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscure = false,
    this.validator,
    this.prefixIcon,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  bool _isObscured = true;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: widget.controller,
        obscureText: widget.obscure ? _isObscured : false,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        validator: widget.validator,
        style: const TextStyle(color: AppColors.textDark, fontSize: 15),
        decoration: InputDecoration(
          hintText: widget.hint,
          hintStyle: const TextStyle(color: AppColors.textLight, fontSize: 14),
          filled: true,
          fillColor: AppColors.background,
          prefixIcon: widget.prefixIcon != null
              ? Icon(widget.prefixIcon, color: AppColors.primary, size: 20)
              : null,
          suffixIcon: widget.obscure
              ? IconButton(
                  icon: Icon(
                    _isObscured
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    color: AppColors.textLight,
                    size: 20,
                  ),
                  onPressed: () => setState(() => _isObscured = !_isObscured),
                )
              : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.divider, width: 1.5),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.primary, width: 2),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 1.5),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(14),
            borderSide: const BorderSide(color: AppColors.error, width: 2),
          ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 18,
            vertical: 16,
          ),
        ),
      ),
    );
  }
}
