import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:frontend_v2/features/home/data/dashboard_models.dart';
import 'package:frontend_v2/features/home/repository/home_repository.dart';

final selectedDateProvider = StateProvider<DateTime>((_) => DateTime.now());

final dashboardProvider = FutureProvider<DashboardData>((ref) async {
  final repo = ref.read(homeRepositoryProvider);
  final date = ref.watch(selectedDateProvider);
  final ymd = DateFormat('yyyy-MM-dd').format(date);
  return repo.fetchDashboard(yyyymmdd: ymd, recentLimit: 3);
});
