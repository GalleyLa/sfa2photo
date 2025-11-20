// presentation/page/calendar_page.dart
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:share_plus/share_plus.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';

import '../../domain/entity/schedule_entity.dart';
import '../../domain/entity/image_entity.dart';
import '../../domain/mapper/schedule_mapper.dart';
import '../../domain/value/schedule_type.dart';
import '../../application/usecases/group_schedules_usecase.dart';
import '../provider/common_providers.dart';

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
  Future<void> _shareImage(String path) async {
    final file = File(path);
    if (await file.exists()) {
      await Share.shareXFiles([XFile(path)], text: 'スケジュール写真を共有');
    } else {
      debugPrint('ファイルが存在しません: $path');
    }
  }

  @override
  void _showPhotoModal(
    BuildContext context,
    List<ImageEntity> photos,
    String scheduleId,
    Color color,
  ) {
    final viewModel = ref.read(scheduleViewModelProvider.notifier);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // 上のハンドルバー
                  Container(
                    height: 4,
                    width: 40,
                    margin: const EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  Text(
                    '撮影写真 (${photos.length})',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),

                  if (photos.isEmpty)
                    const Padding(
                      padding: EdgeInsets.all(24.0),
                      child: Text('このスケジュールには写真がありません'),
                    )
                  else
                    GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 8,
                            mainAxisSpacing: 8,
                          ),
                      itemCount: photos.length,
                      itemBuilder: (context, index) {
                        final photo = photos[index];
                        return Stack(
                          children: [
                            // 画像本体
                            GestureDetector(
                              onTap: () {
                                // 拡大表示ダイアログ
                                showDialog(
                                  context: context,
                                  builder: (_) => Dialog(
                                    child: Image.file(
                                      File(photo.imagePath),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                );
                              },
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.file(
                                  File(photo.imagePath),
                                  fit: BoxFit.cover,
                                  width: double.infinity,
                                  height: double.infinity,
                                ),
                              ),
                            ),

                            // 🔧 右上アクションボタン
                            Positioned(
                              right: 2,
                              top: 2,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // 📤 共有ボタン
                                  IconButton(
                                    icon: const Icon(
                                      Icons.share,
                                      color: Colors.white,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      await _shareImage(photo.imagePath);
                                    },
                                  ),
                                  const SizedBox(width: 4),
                                  // 🗑 削除ボタン
                                  IconButton(
                                    icon: const Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                      size: 20,
                                    ),
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    onPressed: () async {
                                      final confirmed =
                                          await showDialog<bool>(
                                            context: context,
                                            builder: (context) => AlertDialog(
                                              title: const Text('写真を削除しますか？'),
                                              content: const Text(
                                                'この操作は元に戻せません。',
                                              ),
                                              actions: [
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        false,
                                                      ),
                                                  child: const Text('キャンセル'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.pop(
                                                        context,
                                                        true,
                                                      ),
                                                  child: const Text(
                                                    '削除する',
                                                    style: TextStyle(
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ) ??
                                          false;

                                      if (confirmed) {
                                        //await viewModel.deleteImage(photo);
                                        setState(() {
                                          photos.removeAt(index);
                                        });
                                        ScaffoldMessenger.of(
                                          context,
                                        ).showSnackBar(
                                          const SnackBar(
                                            content: Text('写真を削除しました'),
                                          ),
                                        );
                                      }
                                    },
                                  ),
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),

                  const SizedBox(height: 12),
                ],
              ),
            );
          },
        );
      },
    );
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
                          // ✅ 写真（📸 + 枚数）マーカー
                          if (hasPhotos)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: scheduleColor, // スケジュール色と統一
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    const Icon(
                                      Icons.camera_alt,
                                      color: Colors.white,
                                      size: 10,
                                    ),
                                    const SizedBox(width: 2),
                                    Text(
                                      '${photoEntities.length}',
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                          /*
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
                            */
                          /*                           if (hasPhotos)
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(2),
                                decoration: BoxDecoration(
                                  color: scheduleColor, // スケジュール色と連動
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.camera_alt,
                                  color: Colors.white,
                                  size: 12,
                                ),
                              ),
                            ),
                        */
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
                          final scheduleColor = Color(type.colorValue);

                          // スケジュールIDに紐づく写真リストを取得
                          final viewModel = ref.watch(
                            scheduleViewModelProvider.notifier,
                          );
                          final photos = viewModel.photoMap.values
                              .expand((list) => list)
                              .where((img) => img.scheduleId == e.scheduleId)
                              .toList();

                          return ListTile(
                            //leading: CircleAvatar( leading(CircleAvatar) をタップしたら撮影開始
                            leading: GestureDetector(
                              onTap: () async {
                                final saved = await viewModel
                                    .captureAndSaveImage(
                                      context,
                                      e.scheduleId,
                                      _selectedDay!,
                                    );
                                if (saved) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text('画像を保存しました')),
                                  );
                                  setState(() {}); // カレンダー再描画
                                } else {
                                  print('撮影がキャンセルされました');
                                }
                              },
                              child: CircleAvatar(
                                backgroundColor: scheduleColor,
                                child: Text(
                                  type.label,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                            title: Text(e.mouseTitle),
                            subtitle: Text(
                              e.allDay == 1
                                  ? '終日'
                                  : '${dateFormat.format(e.startDate)} 〜 ${dateFormat.format(e.endDate)}',
                              style: const TextStyle(fontSize: 12),
                            ),

                            // 📸 スケジュール右側に写真アイコン＋バッジを表示
                            trailing: photos.isEmpty
                                ? null
                                : IconButton(
                                    icon: Stack(
                                      clipBehavior: Clip.none,
                                      children: [
                                        const Icon(Icons.camera_alt, size: 28),
                                        Positioned(
                                          right: -4,
                                          top: -4,
                                          child: Container(
                                            padding: const EdgeInsets.all(3),
                                            decoration: BoxDecoration(
                                              color: scheduleColor,
                                              shape: BoxShape.circle,
                                            ),
                                            child: Text(
                                              '${photos.length}',
                                              style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 10,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    onPressed: () {
                                      _showPhotoModal(
                                        context,
                                        photos,
                                        e.scheduleId,
                                        scheduleColor,
                                      );
                                    },
                                  ),
                            /*
                                ? IconButton(
                                    icon: const Icon(
                                      Icons.camera_alt,
                                      size: 28,
                                    ),
                                    onPressed: () {
                                      _showPhotoModal(
                                        context,
                                        photos,
                                        e.id,
                                        scheduleColor,
                                      );
                                    },
                                  )
                                : null,
                */
                            /*
                            trailing: IconButton(
                              icon: Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  const Icon(Icons.camera_alt, size: 28),
                                  if (photos.isNotEmpty)
                                    Positioned(
                                      right: -4,
                                      top: -4,
                                      child: Container(
                                        padding: const EdgeInsets.all(3),
                                        decoration: BoxDecoration(
                                          color: scheduleColor,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Text(
                                          '${photos.length}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                            fontSize: 10,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              onPressed: () {
                                _showPhotoModal(
                                  context,
                                  photos,
                                  e.id,
                                  scheduleColor,
                                );
                              },
                            ),
                            */
                            // 🟢 タップで撮影
                            /*
                            onTap: () async {
                              final saved = await viewModel.captureAndSaveImage(
                                e.id,
                                _selectedDay!,
                              );
                              if (saved) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text('画像を保存しました')),
                                );
                                setState(() {}); // カレンダー再描画
                              } else {
                                print('撮影がキャンセルされました');
                              }
                            },
                            */
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
