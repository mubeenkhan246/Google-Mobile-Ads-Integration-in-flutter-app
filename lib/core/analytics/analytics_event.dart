class AnalyticsEvent {
  const AnalyticsEvent(this.name, {this.parameters = const <String, Object>{}});

  final String name;
  final Map<String, Object> parameters;
}
