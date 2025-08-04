// lib/features/auth/screens/verify_mfa_screen.dart
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/otp_input_field.dart';
import 'package:frontend_v2/features/auth/widgets/resend_timer_button.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../core/providers/secure_storage_provider.dart';
import '../providers/auth_provider.dart';
import '../widgets/custom_back_button.dart';
import 'package:frontend_v2/features/home/screens/dashboard_screen.dart';
import 'package:frontend_v2/features/onboarding/screens/onboarding_screen.dart';


class VerifyMFAScreen extends HookConsumerWidget {
  final void Function(BuildContext context) onBack;
  final String mfaEmail;
  final Widget nextScreen;

  const VerifyMFAScreen({
    required this.onBack,
    required this.mfaEmail,
    required this.nextScreen,
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final code = useState('');
    final isLoading = useState(false);
    final error = useState<String?>(null);

    final authRepository = ref.read(authRepositoryProvider);

    Future<void> handleVerify() async {
      if (code.value.length != 6) return;
      isLoading.value = true;
      error.value = null;

      try {
        final response = await authRepository.verifyMFA(
          email: mfaEmail,
          code: code.value,
        );

        if (response != null && response['token'] != null) {
          final token = response['token'] as String;

          final onboardedRaw = response['onboarded'];
          final onboarded = onboardedRaw is bool
              ? onboardedRaw
              : (onboardedRaw.toString().toLowerCase() == 'true');

          final storage = ref.read(secureStorageProvider);
          await storage.write(key: 'token', value: token);
          await storage.write(key: 'onboarded', value: onboarded.toString());

          Fluttertoast.showToast(msg: 'Verification successful!');

          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => onboarded
                  ? const DashboardScreen()
                  : OnboardingScreen(
                onComplete: () async {
                  await storage.write(key: 'onboarded', value: 'true');
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const DashboardScreen(),
                    ),
                  );
                },
              ),
            ),
          );
        } else {
          error.value = 'Wrong code—please try again.';
          code.value = '';
        }
      } catch (e) {
        error.value = 'Something went wrong—please retry.';
      } finally {
        isLoading.value = false;
      }
    }


    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFECFDF5), Color(0xFFF0F9FF), Color(0xFFEEF2FF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Card(
              color: AppColors.emerald50,
              elevation: 4,
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.favorite, color: Colors.teal, size: 48),
                    const SizedBox(height: 16),
                    const Text('Two-Factor Authentication',
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: AppColors.textPrimary)),
                    const SizedBox(height: 8),
                    Text(
                      'Enter the 6-digit code we just emailed to $mfaEmail',
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: AppColors.textPrimary),
                    ),
                    const SizedBox(height: 16),

                    if (error.value != null)
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.red.shade50,
                          border: Border.all(color: Colors.red.shade100),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          error.value!,
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),

                    const SizedBox(height: 16),

                    OtpInputField(
                      code: code.value,
                      onChanged: (val) {
                        code.value = val;
                        error.value = null;
                        if (val.length == 6) {
                          Future.delayed(const Duration(milliseconds: 150), handleVerify);
                        }
                      },
                      isLoading: isLoading.value,
                    ),

                    const SizedBox(height: 12),

                    ElevatedButton(
                      onPressed: isLoading.value || code.value.length != 6 ? null : handleVerify,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.teal[300],
                        minimumSize: const Size.fromHeight(48),
                      ),
                      child: isLoading.value
                          ? const CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                          : const Text('Verify Code'),
                    ),

                    const SizedBox(height: 12),

                    ResendTimerButton(
                      onResend: () {
                        Fluttertoast.showToast(msg: "Code resent to email.");
                      },
                    ),

                    const SizedBox(height: 12),
                    CustomBackButton(
                      label: 'Back to Login',
                      onPressed: () => onBack(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
