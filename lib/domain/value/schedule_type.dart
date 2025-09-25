// lib/domain/value/schedule_type.dart

enum ScheduleType { member, report, unknown }

extension ScheduleTypeColor on ScheduleType {
  String get label {
    switch (this) {
      case ScheduleType.member:
        return 'ス'; // メンバー
      case ScheduleType.report:
        return '訪'; // レポート
      case ScheduleType.unknown:
        return '？'; // 未知の種類
    }
  }

  // UI に依存しない「色のヒント」
  int get colorValue {
    switch (this) {
      case ScheduleType.member:
        return 0xFF2196F3; // ブルー
      case ScheduleType.report:
        return 0xFFFF9800; // オレンジ
      case ScheduleType.unknown:
        return 0xFF9E9E9E; // グレー
    }
  }
}
