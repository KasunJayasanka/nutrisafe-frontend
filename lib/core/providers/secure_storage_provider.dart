import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/core/services/secure_storage_service.dart';


final secureStorageProvider = Provider<SecureStorageService>((ref) {
  return SecureStorageService();
});
