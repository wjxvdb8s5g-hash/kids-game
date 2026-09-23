class AnalyticsService {
  final List<String> _events = [];

  void track(String event, {Map<String, Object?> payload = const {}}) {
    _events.add('$event::$payload');
  }

  List<String> drain() {
    final copy = List<String>.from(_events);
    _events.clear();
    return copy;
  }
}
