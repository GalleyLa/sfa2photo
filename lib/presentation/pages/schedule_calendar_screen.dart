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
import '../../application/viewmodel/schedule_view_model.dart';

class CalendarPage extends ConsumerStatefulWidget {
  const CalendarPage({super.key});

  @override
  ConsumerState<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends ConsumerState<CalendarPage> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
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
    final schedulesAsync = ref.watch(schedulesProvider);
    final dateFormat = DateFormat('MM/dd HH:mm');
    final viewModelAsync = ref.watch(initializedScheduleViewModelProvider);

    //final scheduleViewModelProvider =
    //    FutureProvider.autoDispose<ScheduleViewModel>((ref) async {
    //      final saveImageUseCase = await ref.watch(
    //        saveImageUseCaseProvider.future,
    //      );
    //      return ScheduleViewModel(saveImageUseCase: saveImageUseCase);
    //    });

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
                            color: Color(type.colorValue), // タイプに応じた色に変更可能
                            shape: BoxShape.circle,
                          ),
                        );
                      }).toList(),
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
                              // TODO: implement save image functionality (use a provider or viewModel)
                              //ScaffoldMessenger.of(context).showSnackBar(
                              //  const SnackBar(content: Text('画像を保存しました')),
                              //);
                              final vm = await viewModelAsync.valueOrNull;
                              if (vm != null) {
                                await vm.captureAndSaveImage(
                                  e.id,
                                ); // ← カメラ起動→保存
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('画像を保存しました')),
                                );
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
