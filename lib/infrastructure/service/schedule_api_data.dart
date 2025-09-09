import 'base_api_service.dart';

/*
class ScheduleApiService {
  final BaseApiService baseApiService;

  ScheduleApiService(this.baseApiService);

  Future<List<ScheduleEntity>> fetchScheduleList() async {
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
    final list = response.data as List<dynamic>;
    return list.map((e) => ScheduleEntity.fromMap(e)).toList();
    //return response.data;
  }
}
*/
///oec/?module=office&controller=schedule&exec=get-graph-data&time=1757301372455
/*
_search_pattern	"month"
schedule_date_from	"2025/09/08" //ここが変わる
schedule_mode	"member"
_search_org_id	"3586"
schedule_member_id	"74" //ここが変わる
_search_facility_category_id	"25"
_search_gschedule_category_id	"12"
_search_schedule_category_id	""
_search_facility_ids	""
_search_current_date	""
editable	"true"
schedule_single_print	"false"
*/
