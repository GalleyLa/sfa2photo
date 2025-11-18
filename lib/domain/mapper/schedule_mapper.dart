// lib/domain/mapper/schedule_mapper.dart

//import '../entity/schedule_entity.dart';
import '../value/schedule_type.dart';

class ScheduleMapper {
  static ScheduleType toType(String mode) {
    switch (mode) {
      case 'member':
        return ScheduleType.member;
      case 'report':
        return ScheduleType.report;
      case 'circular':
        return ScheduleType.circular;
      default:
        return ScheduleType.unknown; // 未知の値はグレー表示
    }
  }
}
