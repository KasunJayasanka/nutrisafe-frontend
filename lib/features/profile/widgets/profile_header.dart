import 'dart:io';
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String userName;
  final String userEmail;
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final VoidCallback onEditPressed;
  final VoidCallback onSavePressed;
  final String userId;
  final String profilePictureUrl;
  final File? pickedImage;
  final VoidCallback? onAvatarTap;

  const ProfileHeader({
    Key? key,
    required this.userName,
    required this.userEmail,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.onEditPressed,
    required this.onSavePressed,
    required this.userId,
    required this.profilePictureUrl,
    this.pickedImage,
    this.onAvatarTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Determine which image to show: picked file, network URL, or placeholder asset
    ImageProvider<Object> imageProvider;
    if (pickedImage != null) {
      imageProvider = FileImage(pickedImage!);
    } else if (profilePictureUrl.isNotEmpty) {
      imageProvider = NetworkImage(profilePictureUrl);
    } else {
      imageProvider = const AssetImage('assets/images/logo.png');
    }

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
        child: Row(
          children: [
            // Avatar with tap to change
            GestureDetector(
              onTap: onAvatarTap,
              child: CircleAvatar(
                radius: 28,
                backgroundImage: imageProvider,
                child: imageProvider is AssetImage
                    ? const Icon(Icons.person, size: 28, color: Colors.black)
                    : null,
              ),
            ),

            const SizedBox(width: 16),

            // Name, Email, Badge
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (isEditing)
                    TextField(
                      controller: nameController,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Full Name',
                      ),
                    )
                  else
                    Text(
                      userId,
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
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 8, horizontal: 12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        hintText: 'Email',
                      ),
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

                  Container(
                    padding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD1FAE5), // emerald-100
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Premium Member',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF065F46), // emerald-800
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Edit / Save Button
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.textSecondary),
                minimumSize: const Size(80, 36),
              ),
              onPressed: isEditing ? onSavePressed : onEditPressed,
              icon: Icon(
                isEditing ? Icons.save : Icons.edit,
                size: 18,
                color: AppColors.textSecondary,
              ),
              label: Text(
                isEditing ? 'Save' : 'Edit',
                style: const TextStyle(color: AppColors.textSecondary),
              ),
            ),
          ],
        ),
      ),
    );
  }
}