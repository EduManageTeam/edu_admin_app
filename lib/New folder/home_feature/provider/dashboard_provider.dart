import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../model/dashboard_stats.dart';
import '../service/dashboard_service.dart';

/// Loads the dashboard numbers. The screen watches this provider:
/// loading -> spinner, error -> message + retry, data -> the cards.
final dashboardStatsProvider = FutureProvider.autoDispose<DashboardStats>((
  ref,
) {
  return DashboardService.fetchStats();
});
