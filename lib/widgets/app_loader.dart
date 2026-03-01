import 'package:flutter/material.dart';
import 'package:news_app/constants/app_colors.dart';

class AppLoader extends StatelessWidget {
  final Color? color;
  final double size;

  const AppLoader({super.key, this.color, this.size = 36});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: size,
        height: size,
        child: CircularProgressIndicator(
          color: color ?? AppColors.primary,
          strokeWidth: 3,
        ),
      ),
    );
  }
}

class AppOverlayLoader extends StatelessWidget {
  const AppOverlayLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withOpacity(0.35),
      child: const AppLoader(color: Colors.white),
    );
  }
}
