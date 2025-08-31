// lib/core/enums/sex_option.dart

enum SexOption { male, female, ratherNotSay }

extension SexOptionX on SexOption {
  /// API value → "male" | "female" | "rather_not_say"
  String get api {
    switch (this) {
      case SexOption.male:          return 'male';
      case SexOption.female:        return 'female';
      case SexOption.ratherNotSay:  return 'rather_not_say';
    }
  }

  /// Human-readable label for UI
  String get label {
    switch (this) {
      case SexOption.male:          return 'Male';
      case SexOption.female:        return 'Female';
      case SexOption.ratherNotSay:  return 'Rather not say';
    }
  }

  /// Optional: stable key for widgets/tests
  String get key {
    switch (this) {
      case SexOption.male:          return 'sex_male';
      case SexOption.female:        return 'sex_female';
      case SexOption.ratherNotSay:  return 'sex_rather_not_say';
    }
  }

  /// List of all options (handy for building UIs)
  static List<SexOption> get all => SexOption.values;

  /// Parse from API string; returns null if unknown
  static SexOption? fromApi(String? v) {
    switch (v) {
      case 'male':             return SexOption.male;
      case 'female':           return SexOption.female;
      case 'rather_not_say':   return SexOption.ratherNotSay;
      default:                 return null;
    }
  }
}
