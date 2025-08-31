class BmiResult {
  final double bmi;
  final String category;
  final double heightCm;
  final double weightKg;
  final bool usedOverride;

  const BmiResult({
    required this.bmi,
    required this.category,
    required this.heightCm,
    required this.weightKg,
    required this.usedOverride,
  });

  factory BmiResult.fromJson(Map<String, dynamic> json) => BmiResult(
    bmi: (json['bmi'] as num).toDouble(),
    category: json['category'] as String,
    heightCm: (json['height_cm'] as num).toDouble(),
    weightKg: (json['weight_kg'] as num).toDouble(),
    usedOverride: json['used_override'] as bool? ?? false,
  );
}
