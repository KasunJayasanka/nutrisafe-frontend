import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../provider/goals_provider.dart';

class GoalsHeader extends HookConsumerWidget {
  const GoalsHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(goalsNotifierProvider);
    final notifier = ref.read(goalsNotifierProvider.notifier);

    return state.when(
      loading: () => const SizedBox.shrink(),
      error: (e, _) => Text('Error: $e'),
      data: (s) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(children: [
            Container(
              width: 40, height: 40,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(colors: [Color(0xFF10B981), Color(0xFF06B6D4)]),
              ),
              child: const Icon(Icons.my_location, color: Colors.white),
            ),
            const SizedBox(width: 12),
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('Health Goals', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
              Text('Track your daily targets', style: Theme.of(context).textTheme.bodySmall),
            ]),
          ]),
          OutlinedButton.icon(
            icon: Icon(s.isEditing ? Icons.save : Icons.edit),
            label: Text(s.isEditing ? 'Save' : 'Edit'),
            onPressed: () async {
              if (s.isEditing) {
                await notifier.save();
                // optional: show a small SnackBar
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Goals updated successfully')));
                }
              } else {
                notifier.toggleEdit(true);
              }
            },
          ),
        ],
      ),
    );
  }
}
