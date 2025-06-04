import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_v2/features/auth/data/auth_service.dart';
import 'package:frontend_v2/features/auth/widgets/forgot_email_step.dart';
import 'package:frontend_v2/features/auth/widgets/forgot_verify_step.dart';
import 'package:frontend_v2/features/auth/widgets/forgot_success_step.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:dio/dio.dart';

enum ForgotStep { email, verify, success }

class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback onBack;

  const ForgotPasswordScreen({super.key, required this.onBack});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  late final AuthService _authService;
  ForgotStep _currentStep = ForgotStep.email;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();

  final TextEditingController _codeController            = TextEditingController();
  final TextEditingController _newPasswordController     = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  bool _showPassword        = false;
  bool _showConfirmPassword = false;

  @override
  void initState() {
    super.initState();
    final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
    _authService = AuthService(baseUrl: baseUrl);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _codeController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submitEmail() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter your email address');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.forgotPassword(email: email);
      if (response.statusCode == 200) {
        Fluttertoast.showToast(msg: 'Password reset code sent to your email');
        setState(() => _currentStep = ForgotStep.verify);
      } else {
        Fluttertoast.showToast(msg: 'Failed to send reset code. Try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error sending reset code. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Step 2: Call POST /auth/reset-password
  Future<void> _submitReset() async {
    final code            = _codeController.text.trim();
    final newPassword     = _newPasswordController.text;
    final confirmPassword = _confirmPasswordController.text;

    if (code.length != 6) {
      Fluttertoast.showToast(msg: 'Please enter the 6-digit code');
      return;
    }
    if (newPassword.isEmpty) {
      Fluttertoast.showToast(msg: 'Please enter a new password');
      return;
    }
    if (newPassword != confirmPassword) {
      Fluttertoast.showToast(msg: 'Passwords do not match');
      return;
    }
    if (newPassword.length < 8) {
      Fluttertoast.showToast(msg: 'Password must be at least 8 characters long');
      return;
    }

    setState(() => _isLoading = true);
    try {
      final response = await _authService.resetPassword(
        token: code,
        newPassword: newPassword,
      );
      if (response.statusCode == 200) {
        setState(() => _currentStep = ForgotStep.success);
        Fluttertoast.showToast(msg: 'Password has been reset successfully!');
      } else {
        Fluttertoast.showToast(msg: 'Failed to reset password. Try again.');
      }
    } catch (e) {
      Fluttertoast.showToast(msg: 'Error resetting password. Please try again.');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  /// Clears all fields and returns to the email step (or pops back).
  void _resetToEmail() {
    _emailController.clear();
    _codeController.clear();
    _newPasswordController.clear();
    _confirmPasswordController.clear();
    setState(() => _currentStep = ForgotStep.email);
    widget.onBack();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Full-screen gradient
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFECFDF5), // emerald-50
              Color(0xFFF0F9FF), // sky-50
              Color(0xFFEEF2FF), // indigo-100
            ],
          ),
        ),
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Center(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
              child: Container(
                width: 360, // fixed card width
                decoration: BoxDecoration(
                  color: const Color.fromRGBO(255, 255, 255, 0.70),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: SingleChildScrollView(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 360,
                      maxWidth: 360,
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 24),

                        // ─── Logo & Title ─────────────────────────────
                        Column(
                          children: [
                            Container(
                              width: 80,
                              height: 80,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    AppColors.emerald400,
                                    AppColors.sky400
                                  ],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                    const Color.fromRGBO(0, 0, 0, 0.10),
                                    blurRadius: 10,
                                    offset: const Offset(0, 5),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.favorite,
                                  size: 32,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'HealthTrack',
                              style: TextStyle(
                                fontSize: 28,
                                fontWeight: FontWeight.bold,
                                foreground: Paint()
                                  ..shader = const LinearGradient(
                                    colors: [
                                      AppColors.emerald400,
                                      AppColors.sky400
                                    ],
                                  ).createShader(
                                    const Rect.fromLTWH(0, 0, 200, 70),
                                  ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              _currentStep == ForgotStep.email
                                  ? 'Reset your password'
                                  : _currentStep == ForgotStep.verify
                                  ? 'Verify & Set New Password'
                                  : 'Success!',
                              style: const TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ─── “Back” Button & Title ───────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Row(
                            children: [
                              IconButton(
                                icon:
                                const Icon(Icons.arrow_back, size: 24),
                                onPressed: _resetToEmail,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                _currentStep == ForgotStep.email
                                    ? 'Forgot Password'
                                    : _currentStep == ForgotStep.verify
                                    ? 'Reset Password'
                                    : 'Success!',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 16),

                        // ─── Step Content ────────────────────────────────
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: _buildStepContent(),
                        ),

                        const SizedBox(height: 24),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStepContent() {
    switch (_currentStep) {
      case ForgotStep.email:
        return ForgotEmailStep(
          emailController: _emailController,
          isLoading: _isLoading,
          onSubmit: _submitEmail,
        );
      case ForgotStep.verify:
        return ForgotVerifyStep(
          codeController: _codeController,
          newPasswordController: _newPasswordController,
          confirmPasswordController: _confirmPasswordController,
          showPassword: _showPassword,
          showConfirmPassword: _showConfirmPassword,
          isLoading: _isLoading,
          toggleShowPassword: () {
            setState(() => _showPassword = !_showPassword);
          },
          toggleShowConfirmPassword: () {
            setState(() => _showConfirmPassword = !_showConfirmPassword);
          },
          onSubmit: _submitReset,
          onBackToEmail: () {
            setState(() => _currentStep = ForgotStep.email);
          },
          emailAddress: _emailController.text.trim(),
        );
      case ForgotStep.success:
        return ForgotSuccessStep(
          onFinish: _resetToEmail,
        );
    }
  }
}
