class LocalDatabaseService {
  Future<void> saveData(Map<String, dynamic> data) async {
    // DriftやSqfliteで永続化
  }

  Future<Map<String, dynamic>> loadData() async {
    // DBから読み出し
    return {};
  }
}
