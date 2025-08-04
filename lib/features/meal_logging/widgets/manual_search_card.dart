// lib/features/meal_logging/widgets/manual_search_card.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../provider/meal_provider.dart';
import '../data/food_model.dart';
import '../data/meal_request.dart';

/// A small helper to keep track of what the user has chosen to add.
class SelectedItem {
  final Food food;
  String measureUri;
  double quantity;
  SelectedItem({
    required this.food,
    required this.measureUri,
    required this.quantity,
  });
}

/// A Card that lets the user search for foods, pick a measure & quantity,
/// assemble a list of items, choose a meal type, and submit it.
class ManualSearchCard extends ConsumerStatefulWidget {
  const ManualSearchCard({Key? key}) : super(key: key);

  @override
  ConsumerState<ManualSearchCard> createState() => _ManualSearchCardState();
}

class _ManualSearchCardState extends ConsumerState<ManualSearchCard> {
  final TextEditingController _searchCtrl = TextEditingController();
  String _mealType = 'Breakfast';
  final List<SelectedItem> _selected = [];

  // Friendly name → Edamam measure URI
  static const Map<String, String> _measures = {
    'Gram': 'http://www.edamam.com/ontologies/edamam.owl#Measure_gram',
    'Tbsp': 'http://www.edamam.com/ontologies/edamam.owl#Measure_tbsp',
    'Tsp': 'http://www.edamam.com/ontologies/edamam.owl#Measure_tsp',
    'Cup':  'http://www.edamam.com/ontologies/edamam.owl#Measure_cup',
  };

  void _search(String q) {
    ref.read(mealProvider).searchFoods(q);
  }

  Future<void> _showAddSheet(Food f) async {
    String selMeasure = _measures.values.first;
    double qty = 100;
    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.cardBackground,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 16,
            left: 16,
            right: 16,
            top: 16,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // handle
              Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: AppColors.inputBorder,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(height: 12),

              // title
              Text('Add ${f.label}',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
              const SizedBox(height: 16),

              // measure dropdown
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: 'Measure',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                value: selMeasure,
                items: _measures.entries.map((e) {
                  return DropdownMenuItem(
                    value: e.value,
                    child: Text(e.key,
                        style: TextStyle(color: AppColors.textPrimary)),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) selMeasure = v;
                },
              ),
              const SizedBox(height: 12),

              // quantity field
              TextFormField(
                initialValue: qty.toStringAsFixed(0),
                decoration: InputDecoration(
                  labelText: 'Quantity',
                  labelStyle: TextStyle(color: AppColors.textSecondary),
                  filled: true,
                  fillColor: AppColors.inputFill,
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.inputBorder),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType:
                const TextInputType.numberWithOptions(decimal: true),
                onChanged: (v) => qty = double.tryParse(v) ?? qty,
              ),
              const SizedBox(height: 20),

              // actions
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.inputFill,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () => Navigator.pop(ctx),
                      child: Text('Cancel',
                          style: TextStyle(color: AppColors.textSecondary)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                      ),
                      onPressed: () {
                        setState(() {
                          _selected.add(SelectedItem(
                            food: f,
                            measureUri: selMeasure,
                            quantity: qty,
                          ));
                        });
                        Navigator.pop(ctx);
                      },
                      child: const Text('Add',
                          style:
                          TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _logMeal() async {
    final items = _selected.map((s) {
      return MealItemRequest(
        foodId: s.food.edamamFoodId,
        measureUri: s.measureUri,
        quantity: s.quantity,
      );
    }).toList();

    await ref.read(mealProvider).logMeal(
      MealRequest(
        type: _mealType,
        ateAt: DateTime.now(),
        items: items,
      ),
    );

    setState(() => _selected.clear());
    _searchCtrl.clear();
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Meal logged!')));
  }

  @override
  Widget build(BuildContext context) {
    final prov    = ref.watch(mealProvider);
    final results = prov.searchResults;

    return Card(
      color: AppColors.cardBackground,
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12)),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── header
            Row(children: [
              Icon(Icons.search, color: AppColors.textPrimary),
              const SizedBox(width: 8),
              Text('Search Foods',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  )),
            ]),
            const SizedBox(height: 16),

            // ── meal type chips
            Wrap(
              spacing: 8,
              children: ['Breakfast','Lunch','Dinner','Snack','Other']
                  .map((t) {
                final sel = _mealType == t;
                return ChoiceChip(
                  label: Text(t),
                  selected: sel,
                  onSelected: (_) => setState(() => _mealType = t),
                  selectedColor: AppColors.emerald50,
                  backgroundColor: AppColors.inputFill,
                  labelStyle: TextStyle(
                    color: sel ? AppColors.emerald600 : AppColors.textSecondary,
                    fontWeight: sel ? FontWeight.w600 : FontWeight.w500,
                  ),
                );
              }).toList(),
            ),
            const SizedBox(height: 16),

            // ── search field
            TextField(
              controller: _searchCtrl,
              decoration: InputDecoration(
                prefixIcon:
                Icon(Icons.search, color: AppColors.textSecondary),
                hintText: 'Search for foods…',
                hintStyle: TextStyle(color: AppColors.textSecondary),
                filled: true,
                fillColor: AppColors.inputFill,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.inputBorder),
                ),
              ),
              onChanged: _search,
            ),
            const SizedBox(height: 16),

            // ── selected chips
            if (_selected.isNotEmpty) ...[
              Wrap(
                spacing: 8,
                children: _selected.map((s) {
                  return Chip(
                    label: Text(
                        '${s.food.label} (${s.quantity.toStringAsFixed(0)})'),
                    backgroundColor: AppColors.emerald50,
                    labelStyle: const TextStyle(
                        color: AppColors.emerald600,
                        fontWeight: FontWeight.w500),
                    onDeleted: () =>
                        setState(() => _selected.remove(s)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
            ],

            // ── search results
            const Text('Search Results',
                style:
                TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 8),

            // constrained & scrollable
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppColors.inputFill,
                borderRadius: BorderRadius.circular(8),
              ),
              child: results.isEmpty
                  ? Center(
                child: Text('No results yet.',
                    style: TextStyle(
                        color: AppColors.textSecondary)),
              )
                  : ListView.separated(
                padding: const EdgeInsets.only(top: 8),
                itemCount: results.length,
                separatorBuilder: (_, __) => const Divider(height: 1),
                itemBuilder: (ctx, i) {
                  final f = results[i];
                  return ListTile(
                    leading: Icon(Icons.restaurant,
                        color: AppColors.emerald600),
                    title: Text(f.label,
                        style: TextStyle(
                            color: AppColors.textPrimary,
                            fontWeight: FontWeight.w600)),
                    subtitle: Text(f.category,
                        style: TextStyle(
                            color: AppColors.textSecondary)),
                    trailing: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.emerald600,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                            BorderRadius.circular(8)),
                        minimumSize: const Size(36, 36),
                        padding: EdgeInsets.zero,
                      ),
                      onPressed: () => _showAddSheet(f),
                      child: const Icon(Icons.add,
                          size: 20, color: Colors.white),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 16),

            // ── log meal button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _selected.isEmpty ? null : _logMeal,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: const EdgeInsets.symmetric(vertical: 14),
                ),
                child: const Text('Log Meal',
                    style: TextStyle(
                        fontSize: 16, fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
