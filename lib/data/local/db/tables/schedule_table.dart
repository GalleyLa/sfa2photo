class ScheduleTable {
  static const String tableName = 'schedules';
  static const String id = 'id';
  static const String mode = 'mode';
  static const String member_id = 'member_id';
  // id
  static const String title = 'title';
  static const String mouse_title = 'mouse_title';
  static const String start = 'start';
  static const String end = 'end';
  static const String editable = 'editable';
  static const String clickable = 'clickable';
  static const String schedule_date = 'schedule_date';
  static const String allDay = 'allDay';
  static const String schedule_loop_type = 'schedule_loop_type';
  static const String className = 'className';
  static const String apl_resource_id = 'apl_resource_id';
  static const String apl_act_module = 'apl_act_module';
  static const String apl_act_control = 'apl_act_control';
  static const String apl_act_action = 'apl_act_action';
  static const String apl_act_para = 'apl_act_para';
  static const String update_controller = 'update_controller';
  static const String detail_link = 'detail_link';
  static const String gschedule_id = 'gschedule_id';
  static const String holiday_type = 'holiday_type';
  static const String apl_resource = 'apl_resource';
  //-- ローカル管理用
  static const String created_at = 'created_at';
  static const String updated_at = 'updated_at';
  static const String deleted_at = 'deleted_at';

  // CREATE TABLE 文などもまとめることが可能
  static const String createTableQuery =
      '''
    CREATE TABLE $tableName (
      $id INTEGER PRIMARY KEY AUTOINCREMENT,
      $mode TEXT NOT NULL,
      $member_id INTEGER NOT NULL,
      $title TEXT,
      $mouse_title TEXT,
      $start TEXT,
      $end TEXT,
      $editable INTEGER NOT NULL DEFAULT 0,
      $clickable INTEGER NOT NULL DEFAULT 0,
      $schedule_date TEXT,
      $allDay INTEGER NOT NULL DEFAULT 0,
      $schedule_loop_type INTEGER,
      $className TEXT,
      $apl_resource_id INTEGER,
      $apl_act_module TEXT,
      $apl_act_control TEXT,
      $apl_act_action TEXT,
      $apl_act_para TEXT,
      $update_controller TEXT,
      $detail_link TEXT,
      $gschedule_id TEXT,
      $holiday_type TEXT,
      $apl_resource INTEGER,
       //-- ローカル管理用
      $created_at = TEXT,
      $updated_at = TEXT,
      $deleted_at = TEXT
    )
  ''';
}
