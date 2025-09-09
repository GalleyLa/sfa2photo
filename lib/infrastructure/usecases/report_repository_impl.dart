/*
class ReportRepositoryImpl implements ReportRepository {
  final ReportApiService apiService;
  final LocalDatabaseService db;

  ReportRepositoryImpl(this.apiService, this.db);

  @override
  Future<ReportEntity?> getReport(String scheduleId, String customerId) async {
    // 1. ローカルDBから検索
    final local = await db.loadReport(customerId);
    if (local != null) {
      return ReportEntity.fromMap(local);
    }

    // 2. API呼び出し
    final report = await apiService.fetchReport(scheduleId);
    if (report != null) {
      await saveLocal(report);
    }
    return report;
  }

  @override
  Future<void> saveLocal(ReportEntity report) async {
    await db.saveCustomer(report.toMap());
  }
}
*/
