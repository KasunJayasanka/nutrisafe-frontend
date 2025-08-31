// lib/features/meal_logging/widgets/nutrition_preview_sheet.dart

import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/theme/app_colors.dart';
import '../data/food_model.dart';
import '../data/nutrition_preview.dart';
import '../provider/meal_provider.dart';

class NutritionPreviewSheet extends ConsumerStatefulWidget {
  final Food food;
  final String initialMeasureUri;
  final double initialQuantity;

  const NutritionPreviewSheet({
    Key? key,
    required this.food,
    this.initialMeasureUri =
    'http://www.edamam.com/ontologies/edamam.owl#Measure_gram',
    this.initialQuantity = 100,
  }) : super(key: key);

  @override
  ConsumerState<NutritionPreviewSheet> createState() =>
      _NutritionPreviewSheetState();
}

class _NutritionPreviewSheetState extends ConsumerState<NutritionPreviewSheet> {
  static const Map<String, String> _measures = {
    'Gram'       : 'http://www.edamam.com/ontologies/edamam.owl#Measure_gram',
    'mL'         : 'http://www.edamam.com/ontologies/edamam.owl#Measure_milliliter',
    'Teaspoon'   : 'http://www.edamam.com/ontologies/edamam.owl#Measure_teaspoon',
    'Tablespoon' : 'http://www.edamam.com/ontologies/edamam.owl#Measure_tablespoon',
    'Cup'        : 'http://www.edamam.com/ontologies/edamam.owl#Measure_cup',
    'Ounce'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_ounce',
    'Pound'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_pound',
    'Kilogram'   : 'http://www.edamam.com/ontologies/edamam.owl#Measure_kilogram',
    'Serving'    : 'http://www.edamam.com/ontologies/edamam.owl#Measure_serving',
    'Whole'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_unit',
    // optional, food-specific:
    'Slice'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_slice',
    'Piece'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_piece',
    'Wedge'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_wedge',
    'Stick'      : 'http://www.edamam.com/ontologies/edamam.owl#Measure_stick',
    'Pat'        : 'http://www.edamam.com/ontologies/edamam.owl#Measure_pat',
    'Package'    : 'http://www.edamam.com/ontologies/edamam.owl#Measure_package',
  };


  late String _measureUri;
  late double _qty;

  bool _loading = false;
  String? _error;
  NutritionPreview? _data;

  @override
  void initState() {
    super.initState();
    _measureUri = widget.initialMeasureUri;
    _qty = widget.initialQuantity;
    _fetch();
  }

  Future<void> _fetch() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final res = await ref
          .read(mealProvider)
          .previewNutrition(widget.food.edamamFoodId, _measureUri, _qty);
      setState(() => _data = res);
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    // Sheet background stays white for readability
    return SafeArea(
      child: Container(
        color: Colors.white,
        child: SingleChildScrollView(
          padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // ───────────────── Header (Gradient like your app bar)
              _Header(
                title: widget.food.label,
                subtitle: widget.food.category,
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: const [
                    AppColors.emerald600,
                    Color(0xFF10B981), // emerald-500 style
                  ],
                ),
                trailingBadge:
                _data == null ? null : '${_data!.summary.calories.toStringAsFixed(0)} kcal',
              ),

              // ───────────────── Body
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Controls row
                    Row(
                      children: [
                        // Measure
                        Expanded(
                          child: DropdownButtonFormField<String>(
                            value: _measureUri,
                            style: const TextStyle(color: Colors.black87, fontSize: 15),
                            iconEnabledColor: Colors.black54,
                            iconDisabledColor: Colors.black26,
                            dropdownColor: Colors.white,
                            decoration: _fieldDecoWhite('Measure'),
                            items: _measures.entries
                                .map((e) => DropdownMenuItem(
                              value: e.value,
                              child: Text(e.key),
                            ))
                                .toList(),
                            onChanged: (v) {
                              if (v != null) setState(() => _measureUri = v);
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Quantity
                        SizedBox(
                          width: 120,
                          child: TextFormField(
                            initialValue: _qty.toStringAsFixed(0),
                            keyboardType:
                            const TextInputType.numberWithOptions(
                                decimal: true),
                            decoration: _fieldDeco('Quantity'),
                            onChanged: (v) =>
                            _qty = double.tryParse(v.trim()) ?? _qty,
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Update/Refresh button
                        ElevatedButton.icon(
                          onPressed: _loading ? null : _fetch,
                          icon: const Icon(Icons.refresh, color: Colors.white),
                          label: const Text('Update',
                              style: TextStyle(color: Colors.white)),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.emerald600,
                            minimumSize: const Size(110, 48),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),

                    if (_loading)
                      const _LoadingCard()
                    else if (_error != null)
                      _ErrorCard(message: _error!)
                    else if (_data != null) ...[
                        _SummaryCard(data: _data!),
                        const SizedBox(height: 12),
                        _MacroBar(data: _data!),
                        const SizedBox(height: 12),
                        _NutrientChips(data: _data!),
                      ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _fieldDeco(String label) => InputDecoration(
    labelText: label,
    labelStyle: TextStyle(color: AppColors.textSecondary),
    filled: true,
    fillColor: AppColors.inputFill,
    contentPadding:
    const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
  );
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Header with gradient background (mirrors your GradientAppBar vibe)
class _Header extends StatelessWidget {
  final String title;
  final String subtitle;
  final Gradient gradient;
  final String? trailingBadge;

  const _Header({
    required this.title,
    required this.subtitle,
    required this.gradient,
    this.trailingBadge,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
        borderRadius:
        const BorderRadius.vertical(top: Radius.circular(16)),
      ),
      padding: const EdgeInsets.fromLTRB(16, 14, 8, 16),
      child: Column(
        children: [
          // drag handle + close
          Row(
            children: [
              const SizedBox(width: 8),
              Expanded(
                child: Center(
                  child: Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(.7),
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).maybePop(),
                tooltip: 'Close',
              )
            ],
          ),
          // title row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.restaurant, color: Colors.white),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        )),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withOpacity(.9),
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              if (trailingBadge != null)
                Container(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(.15),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: Colors.white24),
                  ),
                  child: Text(
                    trailingBadge!,
                    style: const TextStyle(
                        color: Colors.white, fontWeight: FontWeight.w700),
                  ),
                ),
              const SizedBox(width: 8),
            ],
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Loading + Error cards
class _LoadingCard extends StatelessWidget {
  const _LoadingCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Row(
        children: const [
          SizedBox(
            height: 22,
            width: 22,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
          SizedBox(width: 12),
          Text('Calculating nutrition…'),
        ],
      ),
    );
  }
}

class _ErrorCard extends StatelessWidget {
  final String message;
  const _ErrorCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: _cardDeco().copyWith(
        border: Border.all(color: Colors.red.withOpacity(.25)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Icon(Icons.error_outline, color: Colors.red),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: Colors.red),
            ),
          ),
        ],
      ),
    );
  }
}

/// ─────────────────────────────────────────────────────────────────────────────
/// Summary card (white)
class _SummaryCard extends StatelessWidget {
  final NutritionPreview data;
  const _SummaryCard({required this.data});

  @override
  Widget build(BuildContext context) {
    final s = data.summary;

    Widget metric(String title, String val, [IconData? icon]) {
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 18, color: AppColors.textSecondary),
            const SizedBox(width: 6),
          ],
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: TextStyle(color: AppColors.textSecondary)),
              const SizedBox(height: 3),
              Text(val,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      );
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Summary for ${data.quantity.toStringAsFixed(0)} ${_unitFromUri(data.measureUri)}',
            style: const TextStyle(
                fontWeight: FontWeight.w700, fontSize: 16),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 22,
            runSpacing: 14,
            children: [
              metric('Calories', '${s.calories.toStringAsFixed(0)} kcal',
                  Icons.local_fire_department_outlined),
              metric('Protein', '${s.protein.toStringAsFixed(1)} g',
                  Icons.fitness_center),
              metric('Carbs', '${s.carbs.toStringAsFixed(1)} g',
                  Icons.breakfast_dining),
              metric('Fat', '${s.fat.toStringAsFixed(1)} g',
                  Icons.water_drop_outlined),
              metric('Sodium', '${s.sodium.toStringAsFixed(1)} mg',
                  Icons.soup_kitchen_outlined),
              metric('Sugar', '${s.sugar.toStringAsFixed(1)} g',
                  Icons.cake_outlined),
            ],
          ),
        ],
      ),
    );
  }

  String _unitFromUri(String uri) {
    if (uri.endsWith('_gram'))        return 'g';
    if (uri.endsWith('_milliliter'))  return 'ml';
    if (uri.endsWith('_teaspoon'))    return 'tsp';
    if (uri.endsWith('_tablespoon'))  return 'tbsp';
    if (uri.endsWith('_cup'))         return 'cup';
    if (uri.endsWith('_ounce'))       return 'oz';
    if (uri.endsWith('_pound'))       return 'lb';
    if (uri.endsWith('_kilogram'))    return 'kg';
    if (uri.endsWith('_serving'))     return 'serving';
    if (uri.endsWith('_unit'))        return 'whole';
    if (uri.endsWith('_slice'))       return 'slice';
    if (uri.endsWith('_piece'))       return 'pc';
    if (uri.endsWith('_wedge'))       return 'wedge';
    if (uri.endsWith('_stick'))       return 'stick';
    if (uri.endsWith('_pat'))         return 'pat';
    if (uri.endsWith('_package'))     return 'pkg';
    return '';
  }

}

/// A slim macro progress bar (visual)
class _MacroBar extends StatelessWidget {
  final NutritionPreview data;
  const _MacroBar({required this.data});

  @override
  Widget build(BuildContext context) {
    // safe fallback to avoid NaN
    final p = data.summary.protein.abs();
    final c = data.summary.carbs.abs();
    final f = data.summary.fat.abs();
    final total = (p + c + f).clamp(1, double.infinity);

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: _cardDeco(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Macros', style: TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SizedBox(
              height: 10,
              child: Row(
                children: [
                  Expanded(
                    flex: (p / total * 1000).round(),
                    child: Container(color: Colors.indigo.shade400),
                  ),
                  Expanded(
                    flex: (c / total * 1000).round(),
                    child: Container(color: Colors.teal.shade400),
                  ),
                  Expanded(
                    flex: (f / total * 1000).round(),
                    child: Container(color: Colors.orange.shade400),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _legendDot('Protein', Colors.indigo.shade400),
              _legendDot('Carbs', Colors.teal.shade400),
              _legendDot('Fat', Colors.orange.shade400),
            ],
          ),
        ],
      ),
    );
  }

  Widget _legendDot(String label, Color color) {
    return Row(
      children: [
        Container(width: 10, height: 10, decoration: BoxDecoration(
          color: color, shape: BoxShape.circle,
        )),
        const SizedBox(width: 6),
        Text(label, style: TextStyle(color: AppColors.textSecondary)),
      ],
    );
  }
}

/// Optional micronutrients as chips
class _NutrientChips extends StatelessWidget {
  final NutritionPreview data;
  const _NutrientChips({required this.data});

  @override
  Widget build(BuildContext context) {
    final picks = {
      'FIBTG': 'Fiber',
      'FASAT': 'Sat. Fat',
      'FAMS': 'Mono',
      'FAPU': 'Poly',
      'CHOLE': 'Chol',
      'K': 'Potassium',
      'CA': 'Calcium',
      'FE': 'Iron',
      'ZN': 'Zinc',
      'VITC': 'Vit C',
      'VITD': 'Vit D',
    };

    final chips = <Widget>[];
    for (final e in picks.entries) {
      final v = data.nutrients[e.key];
      if (v == null) continue;
      chips.add(Chip(
        label: Text(
          '${e.value}: ${v.toStringAsFixed(1)}',
          style: const TextStyle(
            color: Colors.black87,        // ← make it black
            fontWeight: FontWeight.w600,  // optional: a bit bolder
          ),
        ),
        backgroundColor: AppColors.inputFill,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: AppColors.inputBorder),
        ),
      ));
    }

    if (chips.isEmpty) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: _cardDeco(),
      child: Wrap(spacing: 8, runSpacing: 8, children: chips),
    );
  }
}

BoxDecoration _cardDeco() => BoxDecoration(
  color: Colors.white,
  borderRadius: BorderRadius.circular(12),
  boxShadow: [
    BoxShadow(
      color: Colors.black.withOpacity(.04),
      blurRadius: 10,
      offset: const Offset(0, 6),
    ),
  ],
  border: Border.all(color: AppColors.inputBorder),
);

InputDecoration _fieldDecoWhite(String label) => InputDecoration(
  labelText: label,
  labelStyle: const TextStyle(color: Colors.black54),
  filled: true,
  fillColor: Colors.white, // ← field background white
  contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
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
);
