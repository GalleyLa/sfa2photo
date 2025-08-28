// domain/schedule.dart
class Schedule {
  final String id;
  final String customerId;
  final String title;
  final DateTime start;
  final DateTime end;

  Schedule({
    required this.id,
    required this.customerId,
    required this.title,
    required this.start,
    required this.end,
  });

  factory Schedule.fromJson(Map<String, dynamic> json) => Schedule(
    id: json['id'] as String,
    customerId: json['customer_id'] as String,
    title: json['title'] as String,
    start: DateTime.parse(json['start']),
    end: DateTime.parse(json['end']),
  );

  factory Schedule.fromMap(Map<String, Object?> map) => Schedule(
    id: map['id'] as String,
    customerId: map['customer_id'] as String,
    title: map['title'] as String,
    start: DateTime.parse(map['start'] as String),
    end: DateTime.parse(map['end'] as String),
  );

  Map<String, Object?> toMap() => {
    'id': id,
    'customer_id': customerId,
    'title': title,
    'start': start.toIso8601String(),
    'end': end.toIso8601String(),
  };
}

// domain/schedule_repository.dart
abstract class ScheduleRepository {
  Future<List<Schedule>> fetchAndCacheSchedules(String memberId);
  Future<List<Schedule>> getSchedulesFromCache(String customerId);
}
