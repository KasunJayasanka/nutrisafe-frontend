import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:frontend_v2/features/home/provider/home_provider.dart';
import 'package:frontend_v2/features/notifications/provider/notifications_provider.dart';

/// Pull alerts that arrive via REST (dashboard payload)
final dashboardAlertsProvider = Provider<List<Map<String, String>>>((ref) {
  final async = ref.watch(dashboardProvider);
  return async.maybeWhen(
    data: (data) => data.alerts,
    orElse: () => const <Map<String, String>>[],
  );
});

/// Merge dashboard alerts + push alerts; sort desc by time; dedupe by (message, time)
final mergedAlertsProvider = Provider<List<Map<String, String>>>((ref) {
  final push = ref.watch(alertsProvider);           // from notifications_provider.dart
  final api  = ref.watch(dashboardAlertsProvider);

  // Combine (push first so they appear on top if times are equal)
  final all = <Map<String, String>>[
    ...push,
    ...api,
  ];

  // Deduplicate by message+time
  final seen = <String>{};
  final deduped = <Map<String, String>>[];
  for (final a in all) {
    final key = '${a['message'] ?? ''}@@${a['time'] ?? ''}';
    if (seen.add(key)) deduped.add(a);
  }

  // Sort newest first (if parseable)
  deduped.sort((a, b) {
    final ta = DateTime.tryParse(a['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
    final tb = DateTime.tryParse(b['time'] ?? '') ?? DateTime.fromMillisecondsSinceEpoch(0);
    return tb.compareTo(ta);
  });

  return deduped;
});
