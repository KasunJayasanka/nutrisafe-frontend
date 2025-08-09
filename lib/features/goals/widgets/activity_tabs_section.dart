import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import 'package:frontend_v2/features/auth/widgets/gradient_button.dart';
import 'goals_section_card.dart';
import 'gradient_border_section.dart';

class ActivityTabsSection extends HookWidget {
  const ActivityTabsSection({
    super.key,
    required this.hydrationTarget,
    required this.hydrationConsumed,
    required this.exerciseTarget,
    required this.exerciseConsumed,
    required this.hydrationCtl,
    required this.exerciseCtl,
    required this.onSaveHydration,
    required this.onSaveExercise,
  });

  final int hydrationTarget;
  final double hydrationConsumed;
  final int exerciseTarget;
  final double exerciseConsumed;

  final TextEditingController hydrationCtl;
  final TextEditingController exerciseCtl;

  final Future<void> Function(int value) onSaveHydration;
  final Future<void> Function(int value) onSaveExercise;

  @override
  Widget build(BuildContext context) {
    final isEditing = useState<bool>(false);

    // Seed sensible defaults for editors (only once)
    useEffect(() {
      if (hydrationCtl.text.isEmpty) {
        hydrationCtl.text = hydrationTarget.toString();
      }
      if (exerciseCtl.text.isEmpty) {
        exerciseCtl.text = exerciseTarget.toString();
      }
      return null;
    }, const []);

    Future<void> _saveBoth() async {
      final h = int.tryParse(hydrationCtl.text);
      final e = int.tryParse(exerciseCtl.text);
      if (h != null) await onSaveHydration(h);
      if (e != null) await onSaveExercise(e);
      isEditing.value = false;
    }

    return GradientBorderSection(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header + right-aligned Edit/Cancel button
          Row(
            children: [
              const Icon(Icons.today, color: Colors.purple),
              const SizedBox(width: 8),
              Expanded(
                child: Text('Daily Activity',
                    style: Theme.of(context).textTheme.titleMedium),
              ),
              SizedBox(
                height: 40,
                width: 110,
                child: GradientButton(
                  text: isEditing.value ? 'Cancel' : 'Edit',
                  onPressed: () {
                    if (!isEditing.value) {
                      // prefill on entering edit
                      if (hydrationCtl.text.isEmpty) {
                        hydrationCtl.text = hydrationTarget.toString();
                      }
                      if (exerciseCtl.text.isEmpty) {
                        exerciseCtl.text = exerciseTarget.toString();
                      }
                    }
                    isEditing.value = !isEditing.value;
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // View cards (read-only progress)
          if (!isEditing.value) ...[
            GoalsSectionCard(
              title: 'Hydration',
              icon: Icons.opacity,
              iconColor: Colors.blue,
              isEditing: false,
              unitLabel: 'glasses',
              targetValue: hydrationTarget,
              currentValue: hydrationConsumed,
            ),
            const SizedBox(height: 12),
            GoalsSectionCard(
              title: 'Exercise',
              icon: Icons.directions_run,
              iconColor: Colors.purple,
              isEditing: false,
              unitLabel: 'min',
              targetValue: exerciseTarget,
              currentValue: exerciseConsumed,
            ),
          ],

          // Edit form (both fields visible together)
          if (isEditing.value) ...[
            // Inputs in a responsive column; keep them clearly visible
            const SizedBox(height: 8),
            Text('Set today’s activity', style: Theme.of(context).textTheme.bodyMedium),

            const SizedBox(height: 10),
            TextFormField(
              controller: hydrationCtl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Hydration (glasses)',
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: exerciseCtl,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Exercise (min)',
                isDense: true,
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),

            const SizedBox(height: 14),
            SizedBox(
              height: 44,
              child: GradientButton(
                text: 'Save activity',
                onPressed: _saveBoth,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
