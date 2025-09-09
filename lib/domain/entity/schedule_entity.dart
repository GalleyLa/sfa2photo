class ScheduleEntity {
  final String id; // スケジュールID
  final DateTime date; // 開始日 or 日付
  final String title; // 表示用タイトル
  final String? customerId; // 紐づく顧客ID（APIで返るなら）

  ScheduleEntity({
    required this.id,
    required this.date,
    required this.title,
    this.customerId,
  });

  factory ScheduleEntity.fromMap(Map<String, dynamic> map) {
    return ScheduleEntity(
      id: map['id'] as String,
      date: DateTime.parse(map['date']),
      title: map['title'] as String,
      customerId: map['customer_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
    'id': id,
    'date': date.toIso8601String(),
    'title': title,
    'customer_id': customerId,
  };
}

class ReportEntity {
  final String id;
  final String name;
  final String phone;

  ReportEntity({required this.id, required this.name, required this.phone});

  factory ReportEntity.fromMap(Map<String, dynamic> map) {
    return ReportEntity(
      id: map['id'] as String,
      name: map['name'] as String,
      phone: map['phone'] as String,
    );
  }

  Map<String, dynamic> toMap() => {'id': id, 'name': name, 'phone': phone};
}
