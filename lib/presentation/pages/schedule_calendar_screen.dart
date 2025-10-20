import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/schedule_entity.dart';
import '../../domain/value/schedule_type.dart';
import '../../domain/mapper/schedule_mapper.dart';

import '../../application/usecases/group_schedules_usecase.dart';
//import '../provider/database_provider.dart';
import '../../presentation/provider/common_providers.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;

  Map<DateTime, List<ScheduleEntity>> scheduleMap = {};

  //late final List<ScheduleEntity> schedules;
  //late final Map<DateTime, List<ScheduleEntity>> scheduleMap;

  @override
  void initState() {
    super.initState();

    final today = DateTime.now();
    _selectedDay = DateTime(today.year, today.month, today.day); // ← 今日を初期選択
    _focusedDay = _selectedDay!;
    // Map<DateTime, List<ScheduleEntity>> scheduleMap = {};
    // scheduleMap の初期化などもここで
    // scheduleMap = GroupSchedulesByDayUseCase().execute(schedules);

    // 仮データ
    /*
    schedules = [
      ScheduleEntity(
        mode: 'member',
        memberId: '1',
        id: '101',
        mouseTitle: '訪問先１',
        startDate: DateTime(2025, 10, 22),
        endDate: DateTime(2025, 10, 22),
        aplResourceDataKey: 'meeting',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      ),
      ScheduleEntity(
        mode: 'report',
        memberId: '1',
        id: '102',
        mouseTitle: '訪問先２',
        startDate: DateTime(2025, 10, 23),
        endDate: DateTime(2025, 10, 25),
        aplResourceDataKey: 'meeting',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      ),
      ScheduleEntity(
        mode: 'meeting', // 未知の値
        memberId: '1',
        id: '103',
        mouseTitle: '訪問先３',
        startDate: DateTime(2025, 10, 25),
        endDate: DateTime(2025, 10, 26),
        aplResourceDataKey: 'meeting',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        deletedAt: null,
      ),
    ];
    */

    //scheduleMap = GroupSchedulesByDayUseCase().execute(schedules);
  }

  List<ScheduleEntity> _getEventsForDay(DateTime day) {
    final normalized = DateTime(day.year, day.month, day.day);
    return scheduleMap[normalized] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    //final events = _selectedDay != null ? _getEventsForDay(_selectedDay!) : [];
    final dateTimeFormat = DateFormat('MM/dd HH:mm'); // 例: 09/22 09:00
    // RiverpodからUseCaseを取得（非同期初期化）
    final useCaseAsync = ref.watch(scheduleUseCaseProvider);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("スケジュールカレンダー"),
        leadingWidth: 85, //leadingWidthを設定する
        leading: TextButton(
          child: const Text(
            '〈 戻る',
            style: TextStyle(
              //color: Colors.white, //文字の色を白にする
              fontWeight: FontWeight.bold, //文字を太字する
              fontSize: 18.0, //文字のサイズを調整する
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
          //automaticallyImplyLeading: false, // 戻るボタンを非表示にする
          //leading: null, // 完全に戻るボタンを無くす
        ),
      ),
      body: useCaseAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('エラー: $err')),
        data: (useCase) {
          // DBからスケジュールをロード
          return FutureBuilder<List<ScheduleEntity>>(
            future: useCase.execute(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError) {
                return Center(child: Text('読み込みエラー: ${snapshot.error}'));
              }
              final schedules = snapshot.data ?? [];

              // Group by day
              scheduleMap = GroupSchedulesByDayUseCase().execute(schedules);

              final events = _selectedDay != null
                  ? _getEventsForDay(_selectedDay!)
                  : [];

              return Column(
                children: [
                  /// --- カレンダー表示 ---
                  TableCalendar<ScheduleEntity>(
                    locale: 'ja_JP',
                    firstDay: DateTime.utc(2020, 1, 1),
                    lastDay: DateTime.utc(2030, 12, 31),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay = focusedDay;
                      });
                    },
                    eventLoader: _getEventsForDay,
                    calendarBuilders: CalendarBuilders(
                      markerBuilder: (context, date, events) {
                        if (events.isEmpty) return null;
                        return Wrap(
                          alignment: WrapAlignment.center,
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
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 8),

                  /// --- 選択した日の予定リスト ---
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
                                  '${dateTimeFormat.format(e.startDate)} 〜 ${dateTimeFormat.format(e.endDate)}',
                                  style: const TextStyle(fontSize: 12),
                                ),
                              );
                            },
                          ),
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

/*
      body: Column(
        children: [
          /// --- カレンダー表示 ---
          TableCalendar<ScheduleEntity>(
            locale: 'ja_JP',
            firstDay: DateTime.utc(2020, 1, 1),
            lastDay: DateTime.utc(2030, 12, 31),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            eventLoader: _getEventsForDay,
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, date, events) {
                if (events.isEmpty) return null;

                // 色付き丸だけ表示
                return Wrap(
                  alignment: WrapAlignment.center,
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
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          /// --- 選択した日の予定をリスト表示 ---
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
                            type.label, // ← 日本語1文字
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        title: Text(e.mouseTitle),
                        subtitle: Text(
                          !isSameDay(e.startDate, e.endDate)
                              ? '${dateTimeFormat.format(e.startDate)} 〜 ${dateTimeFormat.format(e.endDate)}'
                              : '${dateTimeFormat.format(e.startDate)} 〜 ${dateTimeFormat.format(e.endDate)}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
*/
