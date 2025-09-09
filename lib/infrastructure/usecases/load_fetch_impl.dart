/*
import '../domain/entity/data_entity.dart';
import '../domain/repository/data_repository.dart';

class LoadDataUseCase {
  final DataRepository repository;

  LoadDataUseCase(this.repository);

  /// 起動時: ローカルからロード
  Future<DataEntity?> loadFromLocal() async {
    return await repository.loadLocal();
  }

  /// ユーザ操作時: リモートから同期
  Future<DataEntity?> syncFromRemote() async {
    final data = await repository.fetchRemote();
    if (data != null) {
      await repository.saveLocal(data);
    }
    return data;
  }
}

class LocalDatabaseService {
  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    // schedules テーブルに保存
  }

  Future<List<Map<String, dynamic>>> loadSchedules() async {
    return [];
  }

  Future<void> saveCustomer(Map<String, dynamic> customer) async {
    // customers テーブルに保存
  }

  Future<Map<String, dynamic>?> loadCustomer(String id) async {
    // customers テーブルから取得
    return null;
  }
}
*/
