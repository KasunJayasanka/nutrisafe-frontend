import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:frontend_v2/features/notifications/service/device_service.dart';

final alertsProvider = StateProvider<List<Map<String, String>>>((_) => []);

final notificationSetupProvider = FutureProvider<void>((ref) async {
  final deviceSvc = ref.read(deviceServiceProvider);

  // Request permission (iOS)
  await FirebaseMessaging.instance.requestPermission();

  // Get FCM token
  final token = await FirebaseMessaging.instance.getToken();
  if (token != null) {
    final platform = Platform.isIOS ? "ios" : "android";
    await deviceSvc.registerDevice(platform, token);
  }

  // Listen for foreground messages
  FirebaseMessaging.onMessage.listen((msg) {
    if (msg.notification != null) {
      final alert = {
        'type': (msg.data['type'] ?? 'warning').toString(),
        'message': msg.notification!.title ?? "New Alert",
        'time': DateTime.now().toIso8601String(),
      };
      final current = ref.read(alertsProvider).toList();
      current.insert(0, alert);
      ref.read(alertsProvider.notifier).state = current;
    }
  });
});
