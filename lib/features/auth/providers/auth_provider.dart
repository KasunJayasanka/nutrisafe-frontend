// File: lib/features/auth/providers/auth_providers.dart

import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:frontend_v2/core/providers/api_provider.dart' show apiProvider;
import 'package:frontend_v2/core/providers/secure_storage_provider.dart';
import 'package:frontend_v2/features/auth/data/auth_repository.dart';
import 'package:frontend_v2/features/auth/data/auth_service.dart';
import 'package:frontend_v2/features/auth/controllers/auth_controller.dart';

/// 1) AuthService singleton
final authServiceProvider = Provider<AuthService>((ref) {
  final baseUrl = dotenv.env['API_BASE_URL'] ?? '';
  return AuthService(baseUrl: baseUrl);
});

/// 2) AuthRepository singleton (uses ApiService + SecureStorage)
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService     = ref.read(apiProvider);
  final storageService = ref.read(secureStorageProvider);
  return AuthRepository(
    apiService:      apiService,
    storageService:  storageService,
  );
});

/// 3) AuthController singleton (takes AuthService + SecureStorage)
final authControllerProvider = Provider<AuthController>((ref) {
  final service = ref.read(authServiceProvider);
  final storage = ref.read(secureStorageProvider);
  return AuthController(
    service: service,
    storage: storage,     // ← use 'storage', not 'secureStorage'
  );
});
