import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/profile/widgets/bmi_card.dart';
import 'package:frontend_v2/features/profile/provider/profile_provider.dart'
    show bmiFutureProvider, BmiArgs;

class PersonalInfoSection extends ConsumerWidget {
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

  // ── Helpers ──────────────────────────────────────────────────────────────
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
          Expanded(
            child: Text(
              '$value $suffix',
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(fontSize: 14, color: Colors.black),
            ),
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
        fillColor: Colors.white,
        hintText: hintText,
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
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      color: AppColors.white,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Column(
        children: [
          // ─── Section Header ───────────────────────────
          const ListTile(
            leading: Icon(Icons.person, color: AppColors.textSecondary),
            title: Text(
              'Personal Information',
              style: TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black),
            ),
          ),

          // ─── Fields ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            child: Column(
              children: [
                // Full Name
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Full Name',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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

                // Email
                const Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Email',
                      style: TextStyle(fontSize: 14, color: AppColors.textSecondary)),
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

                // Age & Weight
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Age',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary)),
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
                          const Text('Weight',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary)),
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

                // Birthday & Height
                Row(
                  children: [
                    // Birthday
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Birthday',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary)),
                          const SizedBox(height: 4),
                          isEditing
                              ? GestureDetector(
                            onTap: onBirthdayTap,
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

                    // Height
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Height',
                              style: TextStyle(
                                  fontSize: 14, color: AppColors.textSecondary)),
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

                // ─── BMI action (aligned with fields) ─────────────────
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.monitor_weight_outlined,
                        size: 18, color: AppColors.textSecondary),
                    const SizedBox(width: 8),
                    const Expanded(
                      child: Text(
                        'Body Mass Index (BMI)',
                        style: TextStyle(
                            fontSize: 14, color: AppColors.textSecondary),
                      ),
                    ),


                  ],
                ),

                // ─── BMI result card (inside this card) ───────────────
                const SizedBox(height: 8),
                Consumer(
                  builder: (context, ref, _) {
                    final bmiAsync = ref.watch(bmiFutureProvider(const BmiArgs()));
                    return bmiAsync.when(
                      loading: () => const Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 18, height: 18,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              ),
                              SizedBox(width: 12),
                              Text('Calculating BMI...'),
                            ],
                          ),
                        ),
                      ),
                      error: (e, __) => const Card(
                        elevation: 0,
                        margin: EdgeInsets.zero,
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: Text('Could not compute BMI'),
                        ),
                      ),
                      data: (result) => BmiCard(result: result),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
