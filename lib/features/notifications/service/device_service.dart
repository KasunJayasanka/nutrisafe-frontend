import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_v2/core/services/api_service.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';

import '../../../core/providers/secure_storage_provider.dart';

class DeviceService {
  final ApiService _api;
  final SecureStorageService _storage;
  DeviceService(this._api, this._storage);

  Future<void> registerDevice(String platform, String token) async {
    final jwt = await _storage.read(key: 'token');
    await _api.post(
      '/user/devices/register',
      {
        "platform": platform,
        "token": token,
      },
      options: Options(headers: {"Authorization": "Bearer $jwt"}),
    );
  }
}

final deviceServiceProvider = Provider<DeviceService>((ref) {
  final api = ref.read(apiProvider);
  final storage = ref.read(secureStorageProvider);
  return DeviceService(api, storage);
});
