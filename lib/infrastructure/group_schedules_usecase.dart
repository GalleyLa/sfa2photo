// group_schedules_usecase.dart
import '../domain/entity/schedule_entity.dart';

class GroupSchedulesByDayUseCase {
  Map<DateTime, List<ScheduleEntity>> execute(List<ScheduleEntity> schedules) {
    final map = <DateTime, List<ScheduleEntity>>{};

    for (final schedule in schedules) {
      DateTime day = schedule.startDate;
      while (!day.isAfter(schedule.endDate)) {
        final normalized = DateTime(day.year, day.month, day.day);
        map.putIfAbsent(normalized, () => []);
        map[normalized]!.add(schedule);
        day = day.add(const Duration(days: 1));
      }
    }

    return map;
  }
}
