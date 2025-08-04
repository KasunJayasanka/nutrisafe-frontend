// lib/features/auth/widgets/resend_timer_button.dart
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

class ResendTimerButton extends HookWidget {
  final VoidCallback onResend;

  const ResendTimerButton({required this.onResend, super.key});

  @override
  Widget build(BuildContext context) {
    final countdown = useState(0);

    useEffect(() {
      if (countdown.value > 0) {
        final timer = Future.delayed(const Duration(seconds: 1), () {
          countdown.value--;
        });
        return () => timer.ignore();
      }
      return null;
    }, [countdown.value]);

    return TextButton(
      onPressed: countdown.value > 0 ? null : () {
        onResend();
        countdown.value = 30;
      },
      child: Text(
        countdown.value > 0
            ? 'Resend code in ${countdown.value}s'
            : 'Resend code',
        style: TextStyle(
          color: countdown.value > 0 ? Colors.grey : Colors.teal,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }
}
