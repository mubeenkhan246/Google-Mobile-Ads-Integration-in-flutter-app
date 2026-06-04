import 'analytics_service.dart';

class AnalyticsLocator {
  const AnalyticsLocator._();

  static AnalyticsService instance = const NoopAnalyticsService();
}
