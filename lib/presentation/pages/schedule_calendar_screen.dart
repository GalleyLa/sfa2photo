// presentation/page/calendar_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/schedule_entity.dart';
import '../../application/usecases/group_schedules_usecase.dart';
import '../provider/common_providers.dart';
import '../../domain/mapper/schedule_mapper.dart';
import '../../domain/value/schedule_type.dart';
//import '../../application/viewmodel/schedule_view_model.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  Map<DateTime, List<ScheduleEntity>> scheduleMap = {};

  @override
  void initState() {
    super.initState();
    final today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day);
    _focusedDay = _selectedDay!;
  }

  List<ScheduleEntity> _getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return scheduleMap[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(scheduleViewModelProvider);
    final schedulesAsync = ref.watch(schedulesProvider);
    final viewModel = ref.watch(scheduleViewModelProvider.notifier);
    //final viewModelAsync = ref.watch(initializedScheduleViewModelProvider);
    final dateFormat = DateFormat('MM/dd HH:mm');

    return Scaffold(
      appBar: AppBar(
        title: const Text("スケジュールカレンダー"),
        centerTitle: true,
        leadingWidth: 85,
        leading: TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('〈 戻る', style: TextStyle(fontSize: 18)),
        ),
      ),
      body: schedulesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
        data: (schedules) {
          scheduleMap = GroupSchedulesByDayUseCase().execute(schedules);
          final events = _selectedDay != null
              ? _getEventsForDay(_selectedDay!)
              : [];

          return Column(
            children: [
              TableCalendar<ScheduleEntity>(
                locale: 'ja_JP',
                firstDay: DateTime.utc(2020, 1, 1),
                lastDay: DateTime.utc(2030, 12, 31),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) => isSameDay(_selectedDay, day),

                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },

                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                eventLoader: _getEventsForDay,
                calendarBuilders: CalendarBuilders(
                  markerBuilder: (context, date, events) {
                    final viewModel = ref.watch(
                      scheduleViewModelProvider.notifier,
                    );

                    final dateKey = DateTime(date.year, date.month, date.day);
                    final photoEntities = viewModel.photoMap[dateKey];

                    final hasPhotos =
                        photoEntities != null && photoEntities.isNotEmpty;
                    final hasSchedules = events.isNotEmpty;

                    if (!hasSchedules && !hasPhotos) {
                      return null;
                    }

                    //  その日のスケジュール色を取得（複数ある場合は最初の色）
                    Color scheduleColor = Colors.red; // default fallback
                    if (hasSchedules) {
                      final type = ScheduleMapper.toType(events.first.mode);
                      scheduleColor = Color(type.colorValue);
                    }
                    return SizedBox(
                      height: 32,
                      child: Stack(
                        children: [
                          // スケジュールマーカー（小さい丸）
                          if (hasSchedules)
                            Align(
                              alignment: Alignment.center,
                              child: Wrap(
                                spacing: 2,
                                runSpacing: 2,
                                children: events.take(3).map((e) {
                                  final type = ScheduleMapper.toType(e.mode);
                                  return Container(
                                    width: 6,
                                    height: 6,
                                    decoration: BoxDecoration(
                                      color: Color(type.colorValue),
                                      shape: BoxShape.circle,
                                    ),
                                  );
                                }).toList(),
                              ),
                            ),

                          // 写真バッジ（右下に固定）
                          if (hasPhotos)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(1),
                                decoration: BoxDecoration(
                                  color: scheduleColor, //  スケジュール色と連動
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                constraints: const BoxConstraints(
                                  minWidth: 12,
                                  minHeight: 12,
                                ),
                                child: Text(
                                  '${photoEntities!.length}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ),
                          /*                           if (hasPhotos)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: scheduleColor, // ✅ スケジュール色と連動
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  },
                ),
              ),*/
                        ],
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: events.isEmpty
                    ? const Center(child: Text('予定はありません'))
                    : ListView.builder(
                        itemCount: events.length,
                        itemBuilder: (context, index) {
                          final e = events[index];
                          final type = ScheduleMapper.toType(e.mode);
                          return ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Color(type.colorValue),
                              child: Text(
                                type.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            title: Text(e.mouseTitle),
                            subtitle: Text(
                              '${dateFormat.format(e.startDate)} 〜 ${dateFormat.format(e.endDate)}',
                              style: const TextStyle(fontSize: 12),
                            ),
                            onTap: () async {
                              final saved = await viewModel.captureAndSaveImage(
                                e.id,
                              );
                              if (saved) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('画像を保存しました')),
                                );
                                setState(() {}); // カレンダー再描画
                              } else {
                                // キャンセル時は何もしない、もしくは任意で通知
                                print('撮影がキャンセルされました');
                              }
                            },
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
