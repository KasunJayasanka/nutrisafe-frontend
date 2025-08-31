// File: lib/features/profile/widgets/profile_header.dart

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

/// Reuse the exact gradient your GradientAppBar uses.
const kAppBarGradient = LinearGradient(
  begin: Alignment.topLeft,
  end: Alignment.bottomRight,
  colors: [
    AppColors.emerald400,
    AppColors.sky400,
    AppColors.indigo500,
  ],
);

class ProfileHeader extends StatelessWidget {
  final String userName; // not shown in view mode; kept to match your API
  final String userEmail;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback? onEditPressed;
  final VoidCallback? onSavePressed;
  final String userId; // shown in view mode (as in your current design)
  final String profilePictureUrl;
  final File? pickedImage;
  final VoidCallback? onAvatarTap;
  final bool saving;

  const ProfileHeader({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.userId,
    required this.profilePictureUrl,
    this.onEditPressed,
    this.onSavePressed,
    this.pickedImage,
    this.onAvatarTap,
    this.saving = false,
  }) : super(key: key);

  InputDecoration _headerInputDecoration(String hint) {
    final radius = BorderRadius.circular(8);
    return InputDecoration(
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      filled: true,
      fillColor: Colors.white,
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.textSecondary),
      enabledBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.emerald200, width: 1.2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.emerald600, width: 1.6),
      ),
      border: OutlineInputBorder(
        borderRadius: radius,
        borderSide: const BorderSide(color: AppColors.emerald200, width: 1.2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Determine which image to show: picked file, network URL, or placeholder asset.
    ImageProvider<Object> imageProvider;
    if (pickedImage != null) {
      imageProvider = FileImage(pickedImage!);
    } else if (profilePictureUrl.isNotEmpty) {
      imageProvider = NetworkImage(profilePictureUrl);
    } else {
      imageProvider = const AssetImage('assets/images/logo.png');
    }

    final Widget actionButton = isEditing
        ? _GradientActionButton(
      onPressed: onSavePressed,
      label: saving ? 'Saving…' : 'Save',
      icon: saving ? Icons.hourglass_bottom : Icons.save_rounded,
      disabled: saving || onSavePressed == null,
      gradient: kAppBarGradient, // exact match to app bar
    )
        : OutlinedButton.icon(
      style: OutlinedButton.styleFrom(
        side: const BorderSide(color: AppColors.textSecondary),
        minimumSize: const Size(88, 40),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: onEditPressed,
      icon: const Icon(
        Icons.edit,
        size: 18,
        color: AppColors.textSecondary,
      ),
      label: const Text(
        'Edit',
        style: TextStyle(color: AppColors.textSecondary),
      ),
    );

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: AppColors.emerald200),
      ),
      elevation: 0,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [AppColors.emerald50, AppColors.sky50],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.all(Radius.circular(12)),
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.emerald200),
          ),
        ),
        padding: const EdgeInsets.all(16),

        // Responsive: stack on narrow, row on wide
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isNarrow = constraints.maxWidth < 380; // tweak breakpoint

            final avatar = GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: imageProvider,
                child: imageProvider is AssetImage
                    ? const Icon(Icons.person, size: 28, color: Colors.black)
                    : null,
              ),
            );

            final fields = _HeaderFields(
              isEditing: isEditing,
              nameController: nameController,
              emailController: emailController,
              userId: userId,
              userEmail: userEmail,
              buildInput: _headerInputDecoration,
            );

            if (isNarrow) {
              // Button moves below inputs to avoid overlap.
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      avatar,
                      const SizedBox(width: 16),
                      Expanded(child: fields),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: Alignment.centerRight,
                    child: actionButton,
                  ),
                ],
              );
            }

            // Wide: keep side-by-side, top-aligned.
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                avatar,
                const SizedBox(width: 16),
                Expanded(child: fields),
                const SizedBox(width: 12),
                actionButton,
              ],
            );
          },
        ),
      ),
    );
  }
}

class _HeaderFields extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final String userId;
  final String userEmail;
  final InputDecoration Function(String) buildInput;

  const _HeaderFields({
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.userId,
    required this.userEmail,
    required this.buildInput,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isEditing)
          TextField(
            controller: nameController,
            decoration: buildInput('Full Name'),
            textInputAction: TextInputAction.next,
            maxLines: 1,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          )
        else
          Text(
            userId, // kept as-is per your current design
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        const SizedBox(height: 4),
        if (isEditing)
          TextField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.done,
            maxLines: 1,
            decoration: buildInput('Email'),
            style: const TextStyle(color: Colors.black, fontSize: 14),
          )
        else
          Text(
            userEmail,
            style: const TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        const SizedBox(height: 8),
      ],
    );
  }
}

/// Compact gradient button that matches the AppBar gradient.
/// Keeps the footprint small for the header, with ripple & disabled state.
class _GradientActionButton extends StatelessWidget {
  final VoidCallback? onPressed;
  final String label;
  final IconData icon;
  final bool disabled;
  final Gradient? gradient;

  const _GradientActionButton({
    required this.onPressed,
    required this.label,
    required this.icon,
    this.disabled = false,
    this.gradient,
  });

  @override
  Widget build(BuildContext context) {
    final radius = BorderRadius.circular(10);

    Widget child = Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        gradient: gradient ?? kAppBarGradient,
        borderRadius: radius,
        boxShadow: const [
          BoxShadow(
            blurRadius: 10,
            offset: Offset(0, 4),
            color: Color(0x22000000),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 18, color: Colors.white),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (disabled) {
      child = Opacity(opacity: 0.65, child: child);
    }

    return Material(
      color: Colors.transparent,
      borderRadius: radius,
      child: InkWell(
        onTap: disabled ? null : onPressed,
        borderRadius: radius,
        child: child,
      ),
    );
  }
}
