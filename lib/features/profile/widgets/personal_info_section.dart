import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

class PersonalInfoSection extends StatelessWidget {
  final bool isEditing;
  final TextEditingController nameController;
  final TextEditingController emailController;
  final TextEditingController ageController;
  final TextEditingController weightController;
  final TextEditingController heightController;
  final TextEditingController birthdayController;

  final VoidCallback onBirthdayTap;

  const PersonalInfoSection({
    Key? key,
    required this.isEditing,
    required this.nameController,
    required this.emailController,
    required this.ageController,
    required this.weightController,
    required this.heightController,
    required this.birthdayController,
    required this.onBirthdayTap,

  }) : super(key: key);

  Widget _buildReadOnlyField({
    required IconData icon,
    required String value,
    required String suffix,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F4F6), // gray-50
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: AppColors.textSecondary),
          const SizedBox(width: 6),
          Text(
            '$value $suffix',
            style: const TextStyle(fontSize: 14, color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget _buildEditableField({
    required TextEditingController controller,
    required TextInputType keyboardType,
    required String hintText,
  }) {
    final radius = BorderRadius.circular(8);
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      style: const TextStyle(color: Colors.black, fontSize: 14),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
        filled: true,
        fillColor: Colors.white, // sits on the gray card nicely
        hintText: hintText,
        hintStyle: const TextStyle(color: AppColors.textSecondary),

        // visible border when not focused
        enabledBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.emerald200, width: 1.2),
        ),
        // stronger border when focused
        focusedBorder: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.emerald600, width: 1.6),
        ),
        // fallback for error/disabled (optional)
        border: OutlineInputBorder(
          borderRadius: radius,
          borderSide: const BorderSide(color: AppColors.emerald200, width: 1.2),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          // ─── Section Header ───────────────────────────
          ListTile(
            leading: const Icon(Icons.person, color: AppColors.textSecondary),
            title: const Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // ─── Full Name Field ─────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Full Name',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? _buildEditableField(
                  controller: nameController,
                  keyboardType: TextInputType.text,
                  hintText: 'Full Name',
                )
                    : _buildReadOnlyField(
                  icon: Icons.person_outline,
                  value: nameController.text.trim(),
                  suffix: '',
                ),

                const SizedBox(height: 12),

                // ─── Email Field ────────────────────────────
                Align(
                  alignment: Alignment.centerLeft,
                  child: const Text(
                    'Email',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                isEditing
                    ? _buildEditableField(
                  controller: emailController,
                  keyboardType: TextInputType.emailAddress,
                  hintText: 'Email',
                )
                    : _buildReadOnlyField(
                  icon: Icons.mail_outline,
                  value: emailController.text.trim(),
                  suffix: '',
                ),

                const SizedBox(height: 12),

                // ─── Age & Weight (Side by Side) ───────────
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Age',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),

                          _buildReadOnlyField(
                            icon: Icons.calendar_today_outlined,
                            value: ageController.text.trim(),
                            suffix: 'years',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Weight',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          isEditing
                              ? _buildEditableField(
                            controller: weightController,
                            keyboardType: TextInputType.number,
                            hintText: 'Weight (kg)',
                          )
                              : _buildReadOnlyField(
                            icon: Icons.fitness_center_outlined,
                            value: weightController.text.trim(),
                            suffix: 'kg',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 12),

                Row(
                  children: [
                    // ─── Birthday Column ────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Birthday',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          isEditing
                              ? GestureDetector(
                            onTap: onBirthdayTap,        // ← use the injected callback
                            child: AbsorbPointer(
                              child: _buildEditableField(
                                controller: birthdayController,
                                keyboardType: TextInputType.datetime,
                                hintText: 'YYYY-MM-DD',
                              ),
                            ),
                          )
                              : _buildReadOnlyField(
                            icon: Icons.cake_outlined,
                            value: birthdayController.text.trim(),
                            suffix: '',
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    // ─── Height Column ──────────────────────────────────
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Height',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.textSecondary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          isEditing
                              ? _buildEditableField(
                            controller: heightController,
                            keyboardType: TextInputType.number,
                            hintText: 'Height (cm)',
                          )
                              : _buildReadOnlyField(
                            icon: Icons.height,
                            value: heightController.text.trim(),
                            suffix: 'cm',
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}
