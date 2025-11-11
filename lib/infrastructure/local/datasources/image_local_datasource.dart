//import 'dart:js_interop';

import 'package:sqflite/sqflite.dart';
import '../../../domain/entity/image_entity.dart';
import '../../local/db/tables/image_table.dart';
import '../../../domain/models/image_db_model.dart';

class ImageLocalDatasource {
  final Database db;
  static const tableName = ImageTable.tableName;

  ImageLocalDatasource(this.db);

  /// 画像を1件保存
  Future<void> insertImage(ImageEntity image) async {
    final dbModel = ImageDbModel.fromEntity(image);
    await db.insert(
      tableName,
      dbModel.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  /// 複数画像をまとめて保存
  Future<void> saveImages(List<ImageEntity> images) async {
    final batch = db.batch();
    for (final img in images) {
      final dbModel = ImageDbModel.fromEntity(img);
      batch.insert(
        tableName,
        dbModel.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace,
      );
    }
    await batch.commit(noResult: true);
  }

  /// 全画像をロード
  Future<List<ImageEntity>> loadImages() async {
    final maps = await db.query(tableName);
    return maps.map((e) => ImageDbModel.fromMap(e).toEntity()).toList();
  }

  /// 全画像を取得（並び順あり）
  Future<List<ImageEntity>> getImages() async {
    final rows = await db.query(
      tableName,
      orderBy: '${ImageTable.createdAt} ASC',
    );
    return rows.map((r) => ImageDbModel.fromMap(r).toEntity()).toList();
  }

  /// スケジュールIDに紐づく画像を取得
  Future<List<ImageEntity>> getImagesByScheduleId(String scheduleId) async {
    final rows = await db.query(
      tableName,
      where: '${ImageTable.scheduleId} = ?',
      whereArgs: [scheduleId],
    );
    return rows.map((r) => ImageDbModel.fromMap(r).toEntity()).toList();
  }

  /*
  /// 開始日時で並べた一覧を取得
  Future<List<ImageEntity>> getAllImages() async {
    final rows = await db.query(
      tableName,
      orderBy: '${ImageTable.createdAt} ASC',
    );
    return rows
        .map((r) => ImageDbModel.fromMap(r).toEntity()) //  同様
        .toList();
  }
*/
  /// 全削除
  Future<void> clearImages() async {
    await db.delete(tableName);
  }
}
