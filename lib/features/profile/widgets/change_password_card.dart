// lib/features/profile/widgets/change_password_card.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../provider/profile_provider.dart'
    show ChangePasswordPayload, changePasswordProvider;

class ChangePasswordCard extends ConsumerStatefulWidget {
  const ChangePasswordCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ChangePasswordCard> createState() => _ChangePasswordCardState();
}

class _ChangePasswordCardState extends ConsumerState<ChangePasswordCard> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();

  bool _showCurrent = false;
  bool _showNew = false;
  bool _showConfirm = false;
  bool _submitting = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  String? _validateCurrent(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Enter current password';
    return null;
  }

  String? _validateNew(String? v) {
    final val = (v ?? '').trim();
    if (val.isEmpty) return 'Enter a new password';

    // Minimum requirements
    final hasMinLen  = val.length >= 8;
    final hasUpper   = RegExp(r'[A-Z]').hasMatch(val);
    final hasLower   = RegExp(r'[a-z]').hasMatch(val);
    final hasDigit   = RegExp(r'\d').hasMatch(val);
    final hasSpecial = RegExp(
        r'''[!@#$%^&*(),.?":{}|<>_\-\\/[\];'`~+=]'''
    ).hasMatch(val);


    if (!hasMinLen)  return 'Must be at least 8 characters';
    if (!hasUpper)   return 'Must include at least one uppercase letter';
    if (!hasLower)   return 'Must include at least one lowercase letter';
    if (!hasDigit)   return 'Must include at least one digit';
    if (!hasSpecial) return 'Must include at least one special character';

    if (val == _currentCtrl.text.trim()) {
      return 'New password must be different from current password';
    }
    return null;
  }

  String? _validateConfirm(String? v) {
    if ((v ?? '').trim() != _newCtrl.text.trim()) {
      return 'Passwords do not match';
    }
    return null;
  }

  InputDecoration _decoration(
      String label, {
        required bool isObscured,
        required VoidCallback onToggle,
      }) {
    return InputDecoration(
      labelText: label,
      // make label (field name) black
      labelStyle: const TextStyle(color: Colors.black87),
      floatingLabelStyle: const TextStyle(color: Colors.black87),
      hintStyle: const TextStyle(color: Colors.black54),
      filled: true,
      fillColor: Colors.white, // white field background
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.inputBorder),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.emerald600, width: 1.5),
      ),
      suffixIcon: IconButton(
        onPressed: onToggle,
        icon: Icon(
          isObscured ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: Colors.black87,
        ),
      ),
    );
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    final current = _currentCtrl.text.trim();
    final next = _newCtrl.text.trim();

    setState(() => _submitting = true);
    try {
      await ref.read(
        changePasswordProvider(
          ChangePasswordPayload(
            currentPassword: current,
            newPassword: next,
          ),
        ).future,
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password updated successfully')),
      );
      _currentCtrl.clear();
      _newCtrl.clear();
      _confirmCtrl.clear();
    } catch (e) {
      final msg = e.toString();
      final display = msg.contains('current password is incorrect')
          ? 'Current password is incorrect'
          : msg.contains('at least 8')
          ? 'New password must be at least 8 characters'
          : 'Failed to change password';
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(display), backgroundColor: Colors.red),
      );
    } finally {
      if (mounted) setState(() => _submitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    const fieldTextStyle = TextStyle(color: Colors.black87);

    return Card(
      color: Colors.white,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.disabled,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: const [
                  Icon(Icons.lock_outline, color: AppColors.emerald600),
                  SizedBox(width: 8),
                  Text(
                    'Change Password',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _currentCtrl,
                style: fieldTextStyle,
                cursorColor: Colors.black87,
                obscureText: !_showCurrent,
                validator: _validateCurrent,
                textInputAction: TextInputAction.next,
                decoration: _decoration(
                  'Current Password',
                  isObscured: !_showCurrent,
                  onToggle: () => setState(() => _showCurrent = !_showCurrent),
                ),
              ),
              const SizedBox(height: 12),

              TextFormField
                (
                controller: _newCtrl,
                style: fieldTextStyle,
                cursorColor: Colors.black87,
                obscureText: !_showNew,
                validator: _validateNew,
                textInputAction: TextInputAction.next,
                decoration: _decoration(
                  'New Password',
                  isObscured: !_showNew,
                  onToggle: () => setState(() => _showNew = !_showNew),
                ),
                onChanged: (_) {
                  if (_confirmCtrl.text.isNotEmpty) {
                    _formKey.currentState!.validate();
                  }
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: _confirmCtrl,
                style: fieldTextStyle,
                cursorColor: Colors.black87,
                obscureText: !_showConfirm,
                validator: _validateConfirm,
                textInputAction: TextInputAction.done,
                decoration: _decoration(
                  'Confirm New Password',
                  isObscured: !_showConfirm,
                  onToggle: () => setState(() => _showConfirm = !_showConfirm),
                ),
              ),

              const SizedBox(height: 8),
              const Text(
                'Password must be at least 8 characters and include uppercase, '
                    'lowercase, a number, and a special character.',
                style: TextStyle(fontSize: 12, color: Colors.black54),
              ),
              const SizedBox(height: 16),

              SizedBox(
                height: 48,
                child: ElevatedButton.icon(
                  icon: _submitting
                      ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                      : const Icon(Icons.check, color: Colors.white),
                  label: Text(
                    _submitting ? 'Updating…' : 'Update Password',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.emerald600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  onPressed: _submitting ? null : _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
