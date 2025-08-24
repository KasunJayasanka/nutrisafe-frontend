// lib/features/meal_logging/widgets/meal_card.dart
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../data/meal_model.dart';
import '../provider/meal_provider.dart';
import '../screens/edit_meal_screen.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';

Future<void> _confirmAndDelete(
    BuildContext context,
    WidgetRef ref,
    int mealId,
    MealProvider prov,
    ) async {
  final shouldDelete = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      backgroundColor: Colors.white,
      title: const Text('Delete meal?', style: TextStyle(color: Colors.black)),
      content: const Text(
        'This will permanently remove this meal and its items.',
        style: TextStyle(color: Colors.black87),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: const Text('Cancel', style: TextStyle(color: Colors.black)),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(ctx, true),
          child: const Text('Delete', style: TextStyle(color: Colors.white)),
        ),
      ],
    ),
  );

  if (shouldDelete == true) {
    await ref.read(mealProvider).deleteMeal(mealId);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Meal deleted')),
      );
    }
  }
}

class MealCard extends StatefulWidget {
  final Meal meal;
  final String timeLabel;
  final double totalCalories;
  final bool isSafe;
  final MealProvider prov;
  final WidgetRef ref;

  const MealCard({
    Key? key,
    required this.meal,
    required this.timeLabel,
    required this.totalCalories,
    required this.isSafe,
    required this.prov,
    required this.ref,
  }) : super(key: key);

  @override
  State<MealCard> createState() => _MealCardState();
}

class _MealCardState extends State<MealCard> with TickerProviderStateMixin {
  bool _expanded = true;

  @override
  Widget build(BuildContext context) {
    final m = widget.meal;
    final safe = widget.isSafe;

    final accent = safe ? AppColors.emerald600 : AppColors.orange600;
    final safeBg = safe ? AppColors.emerald50 : AppColors.orange600.withOpacity(.12);
    final safeFg = safe ? AppColors.emerald600 : AppColors.orange600;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: AppColors.cardBackground,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 6),
          ),
        ],
        border: Border.all(color: AppColors.inputBorder),
      ),

      // Use Stack for the left accent; avoids IntrinsicHeight and overflow issues
      child: Stack(
        children: [
          // full-height accent bar
          Positioned.fill(
            left: 0,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: 5,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            ),
          ),

          // content
          Padding(
            padding: const EdgeInsets.only(left: 5), // account for accent bar
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header: icon + title/time + calories
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.emerald50,
                        child: const Icon(
                          Icons.restaurant,
                          color: AppColors.emerald600,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              m.type,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              widget.timeLabel,
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        '${widget.totalCalories.toStringAsFixed(0)} cal',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 12),

                  // ── Chips on left; actions on right (no vertical stack)
                  Row(
                    children: [
                      Expanded(
                        child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: safeBg,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Icon(
                                    safe
                                        ? Icons.check_circle
                                        : Icons.warning_amber_rounded,
                                    size: 16,
                                    color: safeFg,
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    safe ? 'Safe' : 'Unsafe',
                                    style: TextStyle(
                                      color: safeFg,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 5,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.inputFill,
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                '${m.items.length} item${m.items.length == 1 ? '' : 's'}',
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Wrap(
                        spacing: 8,
                        children: [
                          OutlinedButton.icon(
                            onPressed: widget.prov.isLoading
                                ? null
                                : () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (_) =>
                                      EditMealScreen(mealId: m.id),
                                ),
                              );
                            },
                            icon: Icon(
                              Icons.edit,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            label: Text(
                              'Edit',
                              style: TextStyle(
                                color: AppColors.textSecondary,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: BorderSide(color: AppColors.textSecondary),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                          OutlinedButton.icon(
                            onPressed: widget.prov.isLoading
                                ? null
                                : () => _confirmAndDelete(
                              context,
                              widget.ref,
                              m.id,
                              widget.prov,
                            ),
                            icon: const Icon(
                              Icons.delete_outline,
                              size: 16,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.red,
                                fontSize: 14,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              side: const BorderSide(color: Colors.red),
                              shape: const StadiumBorder(),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              visualDensity: VisualDensity.compact,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 8),
                  Divider(color: AppColors.inputBorder, height: 20),
                  const SizedBox(height: 4),

                  // ── Expand / collapse toggle
                  InkWell(
                    onTap: () => setState(() => _expanded = !_expanded),
                    borderRadius: BorderRadius.circular(8),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 6),
                      child: Row(
                        children: [
                          Icon(
                            _expanded ? Icons.expand_less : Icons.expand_more,
                            size: 20,
                            color: AppColors.textSecondary,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            _expanded ? 'Hide items' : 'View items',
                            style: TextStyle(
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                    ),
                  ),

                  // ── Items: use AnimatedSize (only one child laid out) ──
                  AnimatedSize(
                    duration: const Duration(milliseconds: 180),
                    alignment: Alignment.topCenter,
                    clipBehavior: Clip.hardEdge,
                    child: _expanded
                        ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 4),
                        ...m.items.map((it) {
                          final unit = it.measureUri
                              .split('#')
                              .last
                              .split('_')
                              .last
                              .toLowerCase();
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 3),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('• ',
                                    style: TextStyle(
                                        color: AppColors.textPrimary)),
                                Expanded(
                                  child: Text(
                                    '${it.foodLabel} (${it.quantity.toStringAsFixed(0)} $unit)',
                                    style: TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }).toList(),
                      ],
                    )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
