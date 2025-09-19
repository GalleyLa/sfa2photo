import '../entity/_report_entity.dart';

abstract class ReportRepository {
  Future<ReportEntity?> getReport(String scheduleId, {String? customerId});
  Future<void> saveLocal(ReportEntity report);
}
