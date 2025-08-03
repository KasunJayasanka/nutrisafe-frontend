// File: lib/features/profile/data/user_profile.dart

class UserProfile {
  // ─── Raw fields from your JSON ────────────────────────
  final int       id;
  final DateTime  createdAt;
  final DateTime  updatedAt;
  final String    email;
  final String    firstName;
  final String    lastName;
  final DateTime  birthday;
  final double    height;       // in cm
  final double    weight;       // in kg
  final String    healthConditions;
  final String    fitnessGoals;
  final bool      mfaEnabled;
  final String    profilePicture;
  final bool      disabled;
  final String    userId;

  UserProfile({
    required this.id,
    required this.createdAt,
    required this.updatedAt,
    required this.email,
    required this.firstName,
    required this.lastName,
    required this.birthday,
    required this.height,
    required this.weight,
    required this.healthConditions,
    required this.fitnessGoals,
    required this.mfaEnabled,
    required this.profilePicture,
    required this.disabled,
    required this.userId,
  });

  // ─── Convenience getters for your UI ─────────────────
  /// Full name so you can write `user.name`
  String get name => '$firstName $lastName';

  /// Age in whole years so you can write `user.age`
  int get age {
    final days = DateTime.now().difference(birthday).inDays;
    return (days / 365).floor();
  }

  /// Expose weight directly so you can write `user.weight`
  double get weightKg => weight;

  // ─── JSON (de)serialization ─────────────────────────
  factory UserProfile.fromJson(Map<String, dynamic> json) {
    return UserProfile(
      id:               json['id'] as int,
      createdAt:        DateTime.now(), // Or handle if backend provides these
      updatedAt:        DateTime.now(), // Same as above
      email:            json['email'] as String,
      firstName:        json['first_name'] as String? ?? '',
      lastName:         json['last_name'] as String? ?? '',
      birthday:         DateTime.parse(json['birthday'] as String),
      height:           (json['height'] as num?)?.toDouble() ?? 0.0,
      weight:           (json['weight'] as num?)?.toDouble() ?? 0.0,
      healthConditions: json['health_conditions'] as String? ?? '',
      fitnessGoals:     json['fitness_goals'] as String? ?? '',
      mfaEnabled:       json['mfa_enabled'] as bool? ?? false,
      profilePicture:   json['profile_picture'] as String? ?? '',
      disabled:         false, // Assuming backend doesn't send this
      userId: json['user_id'] as String ?? '',

    );
  }


  /// When PATCHing only part of the profile, send this:
  Map<String, dynamic> toJsonForUpdate() {
    return {
      if (firstName.isNotEmpty) 'first_name'       : firstName,
      if (lastName .isNotEmpty) 'last_name'        : lastName,
      if (birthday  != null)    'birthday'         : birthday.toIso8601String().split('T').first,
      if (height    != null)    'height'           : height,
      if (weight    != null)    'weight'           : weight,
      if (healthConditions.isNotEmpty) 'health_conditions': healthConditions,
      if (fitnessGoals    .isNotEmpty) 'fitness_goals'     : fitnessGoals,
      if (mfaEnabled      != null)    'mfa_enabled'       : mfaEnabled,
      if (profilePicture  .isNotEmpty) 'profile_picture'   : profilePicture,
    };
  }
}
