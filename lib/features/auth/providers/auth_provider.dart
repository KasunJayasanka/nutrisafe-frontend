import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';
import 'package:frontend_v2/features/auth/data/auth_repository.dart';
import 'package:frontend_v2/core/providers/api_provider.dart';

/// A provider that gives a singleton SecureStorageService
final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});

/// A provider that gives a singleton AuthRepository
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final apiService = ref.read(apiProvider);
  final storageService = ref.read(secureStorageProvider);
  return AuthRepository(apiService: apiService, storageService: storageService);
});


