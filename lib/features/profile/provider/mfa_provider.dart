import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/features/profile/data/mfa_response.dart';
import 'package:frontend_v2/features/profile/service/profile_service.dart';
import 'package:frontend_v2/features/profile/provider/profile_provider.dart';

/// Exposes current MFA enabled state and a toggle() method.
final mfaProvider = StateNotifierProvider<MfaNotifier, AsyncValue<bool>>((ref) {
  final service = ref.watch(profileServiceProvider);
  final tokenFuture = ref.watch(authTokenProvider.future);
  return MfaNotifier(service, tokenFuture, ref);
});

class MfaNotifier extends StateNotifier<AsyncValue<bool>> {
  final ProfileService _service;
  final Future<String?> _tokenFuture;
  final Ref _ref;

  MfaNotifier(this._service, this._tokenFuture, this._ref)
      : super(const AsyncValue.loading()) {
    _init();
  }

  Future<void> _init() async {
    try {
      final prof = await _ref.watch(profileFutureProvider.future);
      state = AsyncValue.data(prof.mfaEnabled);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  Future<void> toggle(bool enable) async {
    state = const AsyncValue.loading();
    final token = await _tokenFuture;
    if (token == null) {
      state = AsyncValue.error('No auth token', StackTrace.current);
      return;
    }
    try {
      final resp = await _service.updateMfa(token: token, enable: enable);
      state = AsyncValue.data(resp.mfaEnabled);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}
