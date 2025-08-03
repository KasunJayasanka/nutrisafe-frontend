// lib/features/profile/screens/privacy_security_screen.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/profile/provider/mfa_provider.dart';
import 'package:frontend_v2/features/profile/widgets/security_settings_card.dart';
import 'package:frontend_v2/features/profile/widgets/privacy_settings_card.dart';

class PrivacySecurityScreen extends ConsumerWidget {
  const PrivacySecurityScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final mfaAsync = ref.watch(mfaProvider);
    final mfaNotifier = ref.read(mfaProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy & Security'),
        backgroundColor: AppColors.white,
        elevation: 0,
        foregroundColor: AppColors.textPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            SecuritySettingsCard(
              mfaAsync: mfaAsync,
              onToggle: (v) => mfaNotifier.toggle(v),
            ),
            const SizedBox(height: 16),
            const PrivacySettingsCard(),
          ],
        ),
      ),
    );
  }
}
