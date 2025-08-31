import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/features/profile/provider/profile_provider.dart';
import 'package:frontend_v2/features/profile/service/profile_service.dart';

final notificationsEnabledProvider =
StateNotifierProvider.autoDispose<NotificationsEnabledNotifier, AsyncValue<bool>>((ref) {
  final svc   = ref.watch(profileServiceProvider);
  final tokenFut = ref.watch(authTokenProvider.future);
  return NotificationsEnabledNotifier(svc, tokenFut);
});

class NotificationsEnabledNotifier extends StateNotifier<AsyncValue<bool>> {
  final ProfileService _svc;
  final Future<String?> _tokenFuture;

  NotificationsEnabledNotifier(this._svc, this._tokenFuture)
      : super(const AsyncValue.data(false)); // default OFF until user flips

  Future<void> setEnabled(bool enabled) async {
    final prev = state;
    state = AsyncValue.data(enabled); // optimistic

    try {
      final token = await _tokenFuture;
      if (token == null || token.isEmpty) {
        throw Exception('Not authenticated');
      }
      final ok = await _svc.toggleNotifications(token: token, enabled: enabled);
      if (!ok) throw Exception('Server rejected toggle');
      // keep optimistic value
    } catch (e, st) {
      state = prev; // rollback
      state = AsyncValue.error(e, st);
    }
  }
}
