class LocalDatabaseService {
  Future<void> saveSchedules(List<Map<String, dynamic>> schedules) async {
    // schedules テーブルに一括保存
  }

  Future<List<Map<String, dynamic>>> loadSchedules() async {
    return [];
  }

  Future<void> saveCustomers(List<Map<String, dynamic>> customers) async {
    // customers テーブルに一括保存
  }

  Future<Map<String, dynamic>?> loadCustomer(String id) async {
    // idで検索
    return null;
  }
}
