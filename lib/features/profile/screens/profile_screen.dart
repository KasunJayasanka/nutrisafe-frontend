// File: lib/features/profile/screens/profile_screen.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/core/widgets/top_bar.dart';
import 'package:frontend_v2/core/widgets/bottom_nav_bar.dart';
import 'package:frontend_v2/features/profile/provider/profile_provider.dart';
import 'package:frontend_v2/features/profile/data/user_profile.dart';
import 'package:frontend_v2/features/profile/widgets/profile_header.dart';
import 'package:frontend_v2/features/profile/widgets/personal_info_section.dart';
import 'package:frontend_v2/features/profile/widgets/notification_settings_section.dart';
import 'package:frontend_v2/features/profile/widgets/app_settings_section.dart';
import 'package:frontend_v2/features/profile/widgets/app_info_section.dart';
import 'package:frontend_v2/features/auth/providers/auth_provider.dart';
import 'dart:io';
import 'dart:convert';
import 'package:image_picker/image_picker.dart';
import 'package:frontend_v2/features/profile/screens/privacy_security_screen.dart';
import 'package:frontend_v2/features/profile/provider/notifications_toggle_provider.dart';
import 'package:frontend_v2/features/profile/provider/profile_provider.dart' show bmiFutureProvider, BmiArgs;
import 'package:frontend_v2/features/profile/widgets/bmi_card.dart';



import 'package:intl/intl.dart';

import '../../auth/screens/auth_screen.dart';

/// Top‐level screen: watches the FutureProvider and delegates to [ProfileContent].
class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(profileFutureProvider);

    return profileAsync.when(
      loading: () => const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      ),
      error: (err, _) => Scaffold(
        body: Center(child: Text('Error loading profile: $err')),
      ),
      data: (profile) => ProfileContent(profile: profile),
    );
  }
}

/// Stateful widget that holds the form controllers and UI.
class ProfileContent extends ConsumerStatefulWidget {
  final UserProfile profile;

  const ProfileContent({required this.profile, super.key});

  @override
  ConsumerState<ProfileContent> createState() => _ProfileContentState();
}

class _ProfileContentState extends ConsumerState<ProfileContent> {
  bool _isEditing = false;

  bool _isDirty   = false;   // ← track if fields changed
  bool _saving    = false;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _ageController;
  late final TextEditingController _weightController;
  late final TextEditingController _heightController;
  late final TextEditingController _birthdayController;

  File? _pickedImage;
  String? _profilePicBase64;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;

    _nameController   = TextEditingController(text: p.name);
    _emailController  = TextEditingController(text: p.email);
    _ageController    = TextEditingController(text: p.age.toString());
    _weightController = TextEditingController(text: p.weight.toString());
    _heightController   = TextEditingController(text: p.height.toString());

    _birthdayController = TextEditingController(
      text: p.birthday != null
          ? DateFormat('yyyy-MM-dd').format(p.birthday as DateTime)
          : '',
    );




  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _ageController.dispose();
    _weightController.dispose();
    super.dispose();
  }

  Future<void> _selectBirthday() async {
    final initialDate = widget.profile.birthday;
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthdayController.text =
            DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickProfilePic(ImageSource source) async {
    final picker = ImagePicker();
    final xfile = await picker.pickImage(
      source: source,
      imageQuality: 80,
      maxWidth: 600,
    );
    if (xfile == null) return;

    final bytes = await File(xfile.path).readAsBytes();
    setState(() {
      _pickedImage      = File(xfile.path);
      // ← add the prefix here
      _profilePicBase64 = 'data:image/png;base64,' + base64Encode(bytes);
    });
  }



  Future<void> _saveProfile() async {
    // Build your “delta” payload from all the controllers/state you have.
    final payload = UpdatePayload(
      firstName:            _nameController.text.trim().split(' ').first,
      lastName:             _nameController.text.trim().split(' ').skip(1).join(' '),
      birthday:             DateTime.tryParse(_birthdayController.text.trim()),
      height:               double.tryParse(_heightController.text.trim()),
      weight:               double.tryParse(_weightController.text.trim()), // now exists
      healthConditions:     /* your health-conditions controller */ '',
      fitnessGoals:         /* your fitness-goals controller     */ '',
      mfaEnabled:           /* your MFA toggle boolean          */ false,
      profilePictureBase64: _profilePicBase64,   // ← pass your real Base64 here

    );

    // This calls your FutureProvider.family and waits for the updated UserProfile
    await ref.read(updateProfileProvider(payload).future);
    ref.invalidate(profileFutureProvider);
    setState(() => _isEditing = false);
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Profile updated!')));

    // Optionally: refresh your read of profileFutureProvider to show new data
    ref.invalidate(profileFutureProvider);
  }



  void _logout() {
    ref.read(authControllerProvider).logout();

    // Show success message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Logged out successfully')),
    );

    // Navigate back to the AuthScreen and remove all previous routes
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (_) => const AuthScreen()),
          (route) => false, // remove all previous routes
    );
  }




  @override
  Widget build(BuildContext context) {

    final notifState = ref.watch(notificationsEnabledProvider);
    final notifCtrl  = ref.read(notificationsEnabledProvider.notifier);

    Widget notifTile = notifState.when(
      data: (enabled) => NotificationSettingsSection(
        enabled: enabled,
        onChanged: (v) async {
          await notifCtrl.setEnabled(v);
          final s = ref.read(notificationsEnabledProvider);
          if (s is AsyncData<bool>) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(v ? 'Notifications enabled' : 'Notifications disabled')),
            );
          } else if (s is AsyncError) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Failed to update notifications')),
            );
          }
        },
      ),
      loading: () => const Card(
        margin: EdgeInsets.zero,
        child: ListTile(
          leading: Icon(Icons.notifications_none),
          title: Text('Notifications'),
          trailing: SizedBox(
            width: 20, height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      ),
      error: (e, _) => NotificationSettingsSection(
        enabled: false,
        onChanged: (_) {}, // keep UI stable if we failed to load state
      ),
    );

    return Scaffold(
      backgroundColor: AppColors.sky50,
      appBar: TopBar(onBellTap: () {}),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 16),
        child: Column(
          children: [
            ProfileHeader(
              userName:       _nameController.text,
              userEmail:      _emailController.text,
              isEditing:      _isEditing,
              nameController: _nameController,
              emailController:_emailController,
              profilePictureUrl: widget.profile.profilePicture,
              // profilePicture: widget.profile.profilePicture,
              userId:         widget.profile.userId,
              pickedImage:      _pickedImage,
              onAvatarTap:      () async {
                final src = await showModalBottomSheet<ImageSource>(
                  context: context,
                  builder: (_) => Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ListTile(
                        leading: const Icon(Icons.camera_alt),
                        title: const Text('Take Photo'),
                        onTap: () => Navigator.pop(context, ImageSource.camera),
                      ),
                      ListTile(
                        leading: const Icon(Icons.photo_library),
                        title: const Text('Choose from Gallery'),
                        onTap: () => Navigator.pop(context, ImageSource.gallery),
                      ),
                    ],
                  ),
                );
                if (src != null) await _pickProfilePic(src);
              },
              onEditPressed:  () => setState(() => _isEditing = true),
              onSavePressed:  _saveProfile,
            ),
            const SizedBox(height: 16),
            PersonalInfoSection(
              isEditing:        _isEditing,
              nameController:   _nameController,
              emailController:  _emailController,
              ageController:    _ageController,
              weightController: _weightController,
              birthdayController: _birthdayController,
              heightController: _heightController,
              onBirthdayTap: _selectBirthday,
            ),
            const SizedBox(height: 16),

            notifTile,
            const SizedBox(height: 16),
            AppSettingsSection(
              onPrivacyPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => const PrivacySecurityScreen(),
                  ),
                );
              },
              onHelpPressed:    () {},
              onSignOutPressed: _logout,
            ),
            const SizedBox(height: 16),
            const AppInfoSection(),
          ],
        ),
      ),
      // ... inside ProfileScreen's build(...)
      bottomNavigationBar: BottomNavBar(
        currentIndex: 4, // Profile tab
        onTap: (idx) {
          final current = ModalRoute.of(context)?.settings.name;

          switch (idx) {
            case 0: // Dashboard
              if (current != '/dashboard') {
                Navigator.pushReplacementNamed(context, '/dashboard');
              }
              break;
            case 1: // Food
              if (current != '/food') {
                Navigator.pushReplacementNamed(context, '/food');
              }
              break;
            case 2: // Goals
              if (current != '/goals') {
                Navigator.pushReplacementNamed(context, '/goals');
              }
              break;
            case 3: // Analytics
              if (current != '/analytics') {
                Navigator.pushReplacementNamed(context, '/analytics');
              }
              break;
            case 4: // Profile
            // already here; do nothing
              break;
          }
        },
      ),
    );
  }
}
