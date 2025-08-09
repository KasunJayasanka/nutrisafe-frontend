import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class GradientAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final List<Widget>? actions;
  final bool centerTitle;
  final double height;
  final Widget? leading;

  const GradientAppBar({
    super.key,
    required this.title,
    this.actions,
    this.centerTitle = false,
    this.height = kToolbarHeight,
    this.leading,
  });

  @override
  Size get preferredSize => Size.fromHeight(height);

  @override
  Widget build(BuildContext context) {
    const Color fg = Colors.white; // text/icon color

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        centerTitle: centerTitle,
        leading: leading,
        actions: actions,
        title: Text(
          title,
          style: const TextStyle(
            color: fg,
            fontSize: 20,
            fontWeight: FontWeight.w700,
          ),
        ),
        iconTheme: const IconThemeData(color: fg),
        actionsIconTheme: const IconThemeData(color: fg),
        // Gradient background without border radius
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.emerald400,
                AppColors.sky400,
                AppColors.indigo500,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
