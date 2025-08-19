// File: lib/features/goals/widgets/exercise_timer_dialog.dart
import 'dart:async';
import 'dart:ui' show FontFeature;
import 'package:flutter/material.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';

class ExerciseTimerDialog extends StatefulWidget {
  const ExerciseTimerDialog({super.key});

  static Future<int?> show(BuildContext context) {
    return showDialog<int>(
      context: context,
      barrierDismissible: true,
      barrierColor: Colors.black54, // soft dim behind dialog
      builder: (_) => Dialog(
        // ⬇️ make it look like a white card, not a black sheet
        backgroundColor: AppColors.white,
        surfaceTintColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        child: const ExerciseTimerDialog(),
      ),
    );
  }

  @override
  State<ExerciseTimerDialog> createState() => _ExerciseTimerDialogState();
}

class _ExerciseTimerDialogState extends State<ExerciseTimerDialog> {
  final Stopwatch _stopwatch = Stopwatch();
  Timer? _ticker;

  @override
  void initState() {
    super.initState();
    _ticker = Timer.periodic(const Duration(milliseconds: 200), (_) {
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  void _toggle() =>
      setState(() => _stopwatch.isRunning ? _stopwatch.stop() : _stopwatch.start());

  void _reset() => setState(() {
    _stopwatch
      ..reset()
      ..stop();
  });

  String _format(Duration d) {
    final h = d.inHours.toString().padLeft(2, '0');
    final m = (d.inMinutes % 60).toString().padLeft(2, '0');
    final s = (d.inSeconds % 60).toString().padLeft(2, '0');
    return '$h:$m:$s';
  }

  int _roundedMinutes(Duration d) =>
      (d.inSeconds % 60) >= 30 ? d.inMinutes + 1 : d.inMinutes;

  @override
  Widget build(BuildContext context) {
    final elapsed = _stopwatch.elapsed;
    final isRunning = _stopwatch.isRunning;

    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 18, 20, 16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              children: const [
                Icon(Icons.timer, color: AppColors.sky600),
                SizedBox(width: 8),
                Text(
                  'Workout Timer',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Display panel with brand gradient
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [AppColors.sky50, AppColors.emerald50],
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: AppColors.sky100),
              ),
              child: Column(
                children: [
                  Text(
                    _format(elapsed),
                    style: const TextStyle(
                      fontSize: 36,
                      fontWeight: FontWeight.w800,
                      color: Colors.black,
                      fontFeatures: [FontFeature.tabularFigures()],
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${_roundedMinutes(elapsed)} min',
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.textPrimary,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Controls row: Start/Pause (gradient) + Reset (outline)
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: GradientButton(
                      text: isRunning ? 'Pause' : 'Start',
                      icon: isRunning ? Icons.pause : Icons.play_arrow,
                      onPressed: _toggle,
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: _reset,
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.sky600,
                      side: const BorderSide(color: AppColors.sky600),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    icon: const Icon(Icons.restart_alt),
                    label: const Text('Reset'),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Action row: Cancel (outline) + Use Time (gradient)
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(null),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textPrimary,
                      side: const BorderSide(color: AppColors.inputBorder),
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 44,
                    child: GradientButton(
                      text: 'Use Time',
                      onPressed: () => Navigator.of(context)
                          .pop(_roundedMinutes(_stopwatch.elapsed)),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
