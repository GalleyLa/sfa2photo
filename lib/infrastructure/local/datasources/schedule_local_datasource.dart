import 'package:sqflite/sqflite.dart';
import '../../../domain/entity/schedule_entity.dart';
import '../../local/db/tables/schedule_table.dart';
import '../../../domain/models/schedule_db_model.dart';
//import '../../../domain/models/schedule_api_model.dart';

class ScheduleLocalDataSource {
  final Database db;
  static const tableName = ScheduleTable.tableName;

  ScheduleLocalDataSource(this.db);

  /// スケジュールをDBに保存
  Future<void> saveSchedules(List<ScheduleEntity> schedules) async {
    final batch = db.batch();
    for (final s in schedules) {
      //print("DB insert allDay = ${s.allDay}");

      final dbModel = ScheduleDbModel.fromEntity(s); // Entity→DBModel変換
      batch.insert(
        tableName,
        dbModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 全スケジュールをロード
  Future<List<ScheduleEntity>> loadSchedules() async {
    final maps = await db.query(tableName);
    return maps
        .map((e) => ScheduleDbModel.fromMap(e).toEntity()) // DBModel→Entity変換
        .toList();
  }

  /// 開始日時で並べたスケジュール一覧を取得
  Future<List<ScheduleEntity>> getSchedules() async {
    final rows = await db.query(
      tableName,
      orderBy: '${ScheduleTable.startDate} ASC',
    );
    return rows
        .map((r) => ScheduleDbModel.fromMap(r).toEntity()) //  同様
        .toList();
  }

  /// ID指定で1件取得
  Future<ScheduleEntity?> getScheduleById(int id) async {
    final rows = await db.query(tableName, where: 'id = ?', whereArgs: [id]);
    if (rows.isEmpty) return null;
    return ScheduleDbModel.fromMap(rows.first).toEntity(); // 同様
  }

  /// 全削除
  Future<void> clearSchedules() async {
    await db.delete(tableName);
  }
}
