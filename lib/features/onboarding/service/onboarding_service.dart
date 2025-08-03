// lib/features/onboarding/service/onboarding_service.dart

import 'package:flutter/foundation.dart';
import '../data/onboarding_model.dart';
import 'package:frontend_v2/core/services/api_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

class OnboardingService {
  final ApiService _api;
  OnboardingService(this._api);

  Future<bool> completeOnboarding(OnboardingModel data) async {
    final token = await SecureStorageService().read(key: 'token');
    print('🟡 Stored token: $token');


    final opts = Options(headers: {
      if (token != null && token.isNotEmpty)
        'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    });

    try {
      final resp = await _api.patch(
        '/user/onboarding',
        data.toJson(),
        options: opts,
      );

      print('🟢 [Onboarding] status: ${resp.statusCode}');
      print('🟢 [Onboarding] headers: ${resp.headers}');
      print('🟢 [Onboarding] body: ${resp.data}');

      return resp.statusCode == 200;
    } catch (e) {
      print('🔴 [Onboarding Error]: $e');
      return false;
    }
  }
}
