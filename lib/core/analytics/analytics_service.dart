import 'analytics_event.dart';

abstract interface class AnalyticsService {
  Future<void> track(AnalyticsEvent event);
}

class NoopAnalyticsService implements AnalyticsService {
  const NoopAnalyticsService();

  @override
  Future<void> track(AnalyticsEvent event) async {
    // Swap this implementation for FirebaseAnalytics without touching features.
  }
}
