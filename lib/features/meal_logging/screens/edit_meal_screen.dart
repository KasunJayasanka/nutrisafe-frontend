// lib/features/meal_logging/screens/edit_meal_screen.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../provider/meal_provider.dart';
import '../data/meal_model.dart';
import '../data/meal_request.dart';
import '../data/food_model.dart';

/// A local holder for a newly‐added food item.
class SelectedFood {
  final Food food;
  String measureUri;
  double quantity;
  SelectedFood({
    required this.food,
    required this.measureUri,
    required this.quantity,
  });
}

class EditMealScreen extends ConsumerStatefulWidget {
  final int mealId;
  const EditMealScreen({Key? key, required this.mealId}) : super(key: key);

  @override
  ConsumerState<EditMealScreen> createState() => _EditMealScreenState();
}

class _EditMealScreenState extends ConsumerState<EditMealScreen> {
  bool _inited = false;
  late String _type;
  late DateTime _ateAt;
  late List<MealItem> _existing;
  final List<SelectedFood> _newItems = [];

  // simple nutrients‐chip
  Widget _nutChip(String label, String val, Color c) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: c.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(label,
            style: TextStyle(fontSize: 12, color: c, fontWeight: FontWeight.w500)),
        const SizedBox(height: 4),
        Text(val,
            style: TextStyle(fontSize: 14, color: c, fontWeight: FontWeight.bold)),
      ]),
    );
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(mealProvider).fetchMealById(widget.mealId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final prov = ref.watch(mealProvider);

    // once we have the meal, init local state
    if (!prov.editingLoading && !_inited && prov.editingMeal != null) {
      final m = prov.editingMeal!;
      _inited = true;
      _type = m.type;
      _ateAt = m.ateAt.toLocal();
      _existing = List.from(m.items);
    }

    // loading?
    if (prov.editingLoading || !_inited) {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.uploadButtonBackground,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: AppColors.emerald700),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: const Text(
            'Edit Meal',
            style: TextStyle(
              color: AppColors.emerald700,
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          centerTitle: false,
        ),

        body: const Center(child: CircularProgressIndicator()),
      );
    }

    // compute totals
    final totalCal = _existing.fold<double>(0, (s, it) => s + it.calories);
    final totalP = _existing.fold<double>(0, (s, it) => s + it.protein);
    final totalC = _existing.fold<double>(0, (s, it) => s + it.carbs);
    final totalF = _existing.fold<double>(0, (s, it) => s + it.fat);
    final totalNa = _existing.fold<double>(0, (s, it) => s + it.sodium);
    final totalSu = _existing.fold<double>(0, (s, it) => s + it.sugar);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.uploadButtonBackground,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppColors.emerald700),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text(
          'Edit Meal',
          style: TextStyle(
            color: AppColors.emerald700,
            fontSize: 20,
            fontWeight: FontWeight.w800,
          ),
        ),
        centerTitle: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.only(bottom: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── header card ─────────────────────────────
              Container(
                width: double.infinity,
                margin: const EdgeInsets.all(16),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.emerald50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    // type
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Type', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(_type,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                    // when
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text('When', style: TextStyle(fontSize: 12)),
                          const SizedBox(height: 4),
                          Text(
                            '${TimeOfDay.fromDateTime(_ateAt).format(context)} · '
                                '${_ateAt.year}-${_ateAt.month.toString().padLeft(2, '0')}-${_ateAt.day.toString().padLeft(2, '0')}',
                            style: const TextStyle(fontSize: 16),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.edit),
                      onPressed: () async {
                        final d = await showDatePicker(
                          context: context,
                          initialDate: _ateAt,
                          firstDate: DateTime.now().subtract(const Duration(days: 7)),
                          lastDate: DateTime.now(),
                        );
                        if (d == null) return;
                        final t = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.fromDateTime(_ateAt));
                        if (t == null) return;
                        setState(() {
                          _ateAt =
                              DateTime(d.year, d.month, d.day, t.hour, t.minute);
                        });
                      },
                    ),
                  ],
                ),
              ),

              // ── nutrition breakdown ─────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Nutrition Breakdown',
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(children: [
                  _nutChip('Calories', '${totalCal.toStringAsFixed(0)} kcal',
                      AppColors.emerald600),
                  const SizedBox(width: 8),
                  _nutChip('Protein', '${totalP.toStringAsFixed(0)} g',
                      AppColors.orange600),
                  const SizedBox(width: 8),
                  _nutChip('Carbs', '${totalC.toStringAsFixed(0)} g',
                      AppColors.blue600),
                  const SizedBox(width: 8),
                  _nutChip('Fat', '${totalF.toStringAsFixed(0)} g',
                      AppColors.pink600),
                  const SizedBox(width: 8),
                  _nutChip('Sodium', '${totalNa.toStringAsFixed(0)} mg',
                      AppColors.teal600),
                  const SizedBox(width: 8),
                  _nutChip('Sugar', '${totalSu.toStringAsFixed(0)} g',
                      AppColors.purple600),
                ]),
              ),

              const SizedBox(height: 16),
              const Divider(),

              // ── search & add foods ────────────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Add Food', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              FoodSearchList(
                onAdd: (food, measureUri, qty) {
                  setState(() {
                    _newItems.add(SelectedFood(
                        food: food, measureUri: measureUri, quantity: qty));
                  });
                },
              ),

              const SizedBox(height: 16),
              const Divider(),

              // ── existing + new item cards ─────────────
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text('Items', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
              ),
              const SizedBox(height: 8),
              // existing items (full nutrition)
            ..._existing.map((it) => _buildMealItemCard(it, isExisting: true)),

                  // newly added foods (no macros yet)
                  ..._newItems.map((sel) {
                    final unit = sel.measureUri
                        .split('#')
                        .last
                        .split('_')
                        .last
                        .toLowerCase();
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.cardBackground,
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: AppColors.inputBorder),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.02),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            )
                          ],
                        ),
                        child: Stack(children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(sel.food.label,
                                  style: const TextStyle(
                                      fontSize: 16, fontWeight: FontWeight.w600)),
                              const SizedBox(height: 4),
                              Text('${sel.quantity.toStringAsFixed(0)} $unit',
                                  style:
                                      TextStyle(color: AppColors.textSecondary)),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            top: 0,
                            child: IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _newItems.remove(sel);
                                });
                              },
                            ),
                          ),
                        ]),
                      ),
                    );
                  }),

              const SizedBox(height: 24),

              // ── save button ──────────────────────────
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: (_existing.isEmpty && _newItems.isEmpty)
                        ? null
                        : () async {
                      // build request from both lists
                      final reqItems = [
                        ..._existing.map((it) => MealItemRequest(
                          foodId: it.foodId,
                          measureUri: it.measureUri,
                          quantity: it.quantity,
                        )),
                        ..._newItems.map((n) => MealItemRequest(
                          foodId: n.food.edamamFoodId,
                          measureUri: n.measureUri,
                          quantity: n.quantity,
                        )),
                      ];
                      final req = MealRequest(
                        type: _type,
                        ateAt: _ateAt,
                        items: reqItems,
                      );
                      await ref
                          .read(mealProvider)
                          .updateMeal(widget.mealId, req);
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.emerald600,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Save Changes',
                        style: TextStyle(fontSize: 16)),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealItemCard(MealItem it,
      {required bool isExisting, VoidCallback? onDelete}) {
    final unit = it.measureUri.split('#').last.split('_').last.toLowerCase();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: AppColors.inputBorder),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 2),
            )
          ],
        ),
        child: Stack(children: [
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(it.foodLabel,
                style:
                const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('${it.quantity.toStringAsFixed(0)} $unit',
                style: TextStyle(color: AppColors.textSecondary)),
            const SizedBox(height: 8),
            Wrap(spacing: 6, children: [
              _nutChip('Cal', it.calories.toStringAsFixed(0), AppColors.emerald600),
              _nutChip('P', '${it.protein.toStringAsFixed(0)}g', AppColors.orange600),
              _nutChip('C', '${it.carbs.toStringAsFixed(0)}g', AppColors.blue600),
              _nutChip('F', '${it.fat.toStringAsFixed(0)}g', AppColors.pink600),
            ]),
          ]),
          Positioned(
            right: 0,
            top: 0,
            child: IconButton(
              icon: Icon(Icons.delete,
                  color: isExisting ? Colors.red.shade300 : Colors.red),
              onPressed: onDelete ??
                      () => setState(() => _existing.remove(it)),
            ),
          ),
        ]),
      ),
    );
  }
}

/// ─── FoodSearchList ─────────────────────────────────────────────
/// Shows a search-bar + results; on tapping “+” it fires [onAdd].
class FoodSearchList extends ConsumerWidget {
  final void Function(Food food, String measureUri, double qty) onAdd;
  const FoodSearchList({Key? key, required this.onAdd}) : super(key: key);

  static const Map<String, String> _measures = {
    'Gram': 'http://www.edamam.com/ontologies/edamam.owl#Measure_gram',
    'Tbsp': 'http://www.edamam.com/ontologies/edamam.owl#Measure_tbsp',
    'Tsp': 'http://www.edamam.com/ontologies/edamam.owl#Measure_tsp',
    'Cup': 'http://www.edamam.com/ontologies/edamam.owl#Measure_cup',
  };

  @override
  Widget build(BuildContext c, WidgetRef ref) {
    final prov = ref.watch(mealProvider);
    return Column(children: [
      // search field
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: TextField(
          decoration: InputDecoration(
            hintText: 'Search…',
            hintStyle: TextStyle(color: AppColors.textSecondary),
            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
            filled: true,
            fillColor: AppColors.inputFill,
            contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.inputBorder),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: AppColors.emerald600),
            ),
          ),
          onChanged: (q) => ref.read(mealProvider).searchFoods(q),
        ),
      ),
      const SizedBox(height: 8),
      // results list
      Container(
        constraints: const BoxConstraints(maxHeight: 240),
        margin: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.inputBorder),
        ),
        child: prov.searchResults.isEmpty
            ? Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text('No results', style: TextStyle(color: AppColors.textSecondary)),
          ),
        )
            : ListView.separated(
          padding: EdgeInsets.zero,
          itemCount: prov.searchResults.length,
          separatorBuilder: (_, __) => Divider(color: AppColors.inputBorder, height: 1),
          itemBuilder: (_, i) {
            final f = prov.searchResults[i];
            return ListTile(
              leading: Icon(Icons.restaurant, color: AppColors.emerald600),
              title: Text(f.label, style: TextStyle(color: AppColors.textPrimary)),
              subtitle: Text(f.category, style: TextStyle(color: AppColors.textSecondary)),
              trailing: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(36, 36),
                  padding: EdgeInsets.zero,
                  backgroundColor: AppColors.emerald600,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                onPressed: () async {
                  // quick bottom‐sheet to pick measure+qty
                  String selMeas = _measures.values.first;
                  double qty = 100;
                  await showModalBottomSheet(
                    context: c,
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
                        child: Column(mainAxisSize: MainAxisSize.min, children: [
                          Container(width: 40, height: 4, decoration: BoxDecoration(
                              color: AppColors.inputBorder,
                              borderRadius: BorderRadius.circular(2))),
                          const SizedBox(height: 12),
                          Text('Add ${f.label}',
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.textPrimary)),
                          const SizedBox(height: 16),
                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              labelText: 'Measure',
                              filled: true,
                              fillColor: AppColors.inputFill,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.inputBorder),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            value: selMeas,
                            items: _measures.entries
                                .map((e) => DropdownMenuItem(
                              value: e.value,
                              child: Text(e.key,
                                  style: TextStyle(color: AppColors.textPrimary)),
                            ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) selMeas = v;
                            },
                          ),
                          const SizedBox(height: 12),
                          TextFormField(
                            initialValue: qty.toStringAsFixed(0),
                            decoration: InputDecoration(
                              labelText: 'Qty',
                              filled: true,
                              fillColor: AppColors.inputFill,
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: AppColors.inputBorder),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            keyboardType: TextInputType.numberWithOptions(decimal: true),
                            onChanged: (v) => qty = double.tryParse(v) ?? qty,
                          ),
                          const SizedBox(height: 20),
                          Row(children: [
                            Expanded(
                              child: TextButton(
                                style: TextButton.styleFrom(
                                  backgroundColor: AppColors.inputFill,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child: Text('Cancel', style: TextStyle(color: AppColors.textSecondary)),
                                onPressed: () => Navigator.pop(ctx),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: AppColors.emerald600,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8)),
                                  padding:
                                  const EdgeInsets.symmetric(vertical: 14),
                                ),
                                child:
                                const Text('Add', style: TextStyle(color: Colors.white)),
                                onPressed: () {
                                  onAdd(f, selMeas, qty);
                                  Navigator.pop(ctx);
                                },
                              ),
                            ),
                          ]),
                        ]),
                      );
                    },
                  );
                },
                child: const Icon(Icons.add, size: 20, color: Colors.white),
              ),
            );
          },
        ),
      ),
    ]);
  }
}
