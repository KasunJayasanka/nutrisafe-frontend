// lib/features/profile/data/mfa_response.dart
class MfaResponse {
  final String message;
  final bool mfaEnabled;

  MfaResponse({
    required this.message,
    required this.mfaEnabled,
  });

  factory MfaResponse.fromJson(Map<String, dynamic> json) {
    return MfaResponse(
      message: json['message'] as String,
      mfaEnabled: json['mfa_enabled'] as bool,
    );
  }
}
