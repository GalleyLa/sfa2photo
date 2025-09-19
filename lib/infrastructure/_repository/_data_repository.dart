/*
import '../../domain/entity/data_entity.dart';
import 'data_repository.dart';
import '../../domain/service/data_api_service.dart';
import '../../domain/service/detail_api_service.dart';
import '../../domain/service/local_database_service.dart';

class DataRepositoryImpl implements DataRepository {
  final DataApiService dataApiService;
  final DetailApiService detailApiService;
  final LocalDatabaseService localDb;

  DataRepositoryImpl(this.dataApiService, this.detailApiService, this.localDb);

  @override
  Future<DataEntity?> loadLocal() async {
    final map = await localDb.loadData();
    if (map == null) return null;
    return DataEntity.fromMap(map);
  }

  @override
  Future<DataEntity?> fetchRemote() async {
    try {
      // 2. 内部IDでデータ取得
      final list = await dataApiService.fetchDataList();

      // 3. 一時識別子抽出（例: tenantId）
      final tenantId = list['tenant_id'] as String;

      // 4. tenantId を使って追加データ取得
      final detail = await detailApiService.fetchDetail(tenantId);

      // Domain Entity に変換
      return DataEntity.fromMap(detail);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> saveLocal(DataEntity entity) async {
    await localDb.saveData(entity.toMap());
  }
}
*
*/
