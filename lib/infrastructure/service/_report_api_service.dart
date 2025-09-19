import 'base_api_service.dart';

class ReportApiService {
  final BaseApiService baseApiService;

  ReportApiService(this.baseApiService);

  Future<Map<String, dynamic>> fetchReportData() async {
    final response = await baseApiService.get(
      '/data/detail',
      queryParameters: {
        'fid': '-1',
        'fvid': '-1',
        'cid': '69420',
        'layout': 'detail',
        'type': 'plan',
      },
    );
    if (response.data == null) return {};
    return response.data;
  }
}

///oec/?module=sfa&controller=report&exec=get-regist&time=1757301433558
/*
fid	"-1"
fvid	"-1"
cid	"69420" //ここが変わる
layout	"detail"
type	"plan"
*/
