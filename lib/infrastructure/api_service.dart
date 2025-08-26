// infrastructure/api_service.dart
import 'package:dio/dio.dart';
import 'package:dio_cookie_manager/dio_cookie_manager.dart';
import 'package:cookie_jar/cookie_jar.dart';

class ApiService {
  final String baseUrl;
  final String orgId;
  late Dio _dio;
  late CookieJar _cookieJar;

  ApiService({required this.baseUrl, required this.orgId}) {
    _dio = Dio(BaseOptions(baseUrl: baseUrl));
    _cookieJar = CookieJar();
    _dio.interceptors.add(CookieManager(_cookieJar));
  }

  Future<Map<String, dynamic>> loginAndFetch(
    String userId,
    String password,
  ) async {
    try {
      // Step 1: ログイン
      await _dio.post(
        '',
        data: {'user_id': userId, 'password': password, 'login_form': '2'},
        options: Options(
          contentType: Headers.formUrlEncodedContentType,
          followRedirects: false,
          validateStatus: (status) => status != null && status < 400,
        ),
      );

      // Cookieからmember_idを抽出
      final cookies = await _cookieJar.loadForRequest(Uri.parse(baseUrl));
      final memberCookie = cookies.firstWhere(
        (c) => c.name == 'member_id',
        orElse: () => Cookie('', ''),
      );
      if (memberCookie.name.isEmpty)
        throw Exception("member_idがCookieに含まれていません");

      final memberId = memberCookie.value;
      final timestamp = (DateTime.now().millisecondsSinceEpoch ~/ 1000)
          .toString();

      // Step 2: スケジュール取得
      final pageRes = await _dio.post(
        '?module=office&controller=schedule&exec=get-graph-data&time=$timestamp',
        data: {
          '_search_pattern': 'month',
          'schedule_date_from': '2025/08/08',
          'schedule_mode': 'member',
          '_search_org_id': orgId,
          'schedule_member_id': memberId,
        },
        options: Options(contentType: Headers.formUrlEncodedContentType),
      );

      return {"success": true, "data": pageRes.data};
    } catch (e) {
      return {"success": false, "data": e.toString()};
    }
  }
}
