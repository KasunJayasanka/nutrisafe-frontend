import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class GradientBorderSection extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double radius;
  final double stroke;

  const GradientBorderSection({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.radius = 16,
    this.stroke = 1.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: margin,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.emerald400, AppColors.sky400, AppColors.indigo500],
        ),
        borderRadius: BorderRadius.circular(radius),
      ),
      padding: EdgeInsets.all(stroke),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(radius - 0.5),
        ),
        padding: padding ?? const EdgeInsets.fromLTRB(16, 12, 16, 16),
        child: child,
      ),
    );
  }
}
