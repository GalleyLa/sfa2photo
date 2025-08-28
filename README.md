# sfa2photo

```
lib/  
 ├── main.dart          # エントリーポイント  
 ├── ui/                # UI層 (画面, Widget)  
 │    └── login_page.dart  
 ├── application/       # アプリケーション層 (状態管理, UseCase)  
 │    └── login_usecase.dart  
 ├── domain/            # ドメイン層 (モデル定義, エンティティ)  
 │    └── user.dart  
 └── infrastructure/    # インフラ層 (API通信, DB, 外部接続)  
      ├── api_service.dart  
      ├── local_cache.dart        # SecureStorage や Hive  
      ├── database/  
      |    ├── app_database.dart # SQLite初期化  
      |    ├── user_dao.dart     # Userテーブル操作  
      |    └── schedule_dao.dart # Scheduleテーブル操作  
      └── repository/  
           ├── user_repository_impl.dart  
           └── schedule_repository_impl.dart  

```


```
.
└── main
    ├── UI
    │   └── login_page.dart
    │       ├── _doLogin -> ①
    │       └── ⑦->UIに反映
    ├── applicatin
    │   └── login_usecase.dart
    │       ├── ①-> _doLogin -> api.loginAndFatch -> ②
    │       ├── ③-> User -> ④
    │       ├── ⑤-> cach.saveUser ->⑥
    │       └── ⑦<-
    ├── infrastructure
    │   ├── api_service.dart
    │   │   ├── ②-> loginAndFatch -> wawa
    │   │   └── ③<- user
    │   └── local_cache.dart
    │       └── ⑥-> saveUser
    └── domain
        └── user.dart
            ├── ④->User
            └── ⑤<-
```

# DB の責務と配置（クリーンアーキテクチャ寄り）

- Domain 層
     - エンティティ定義（User, Schedule など）
     - Repository のインターフェース（抽象クラス）

- Application 層
     - UseCase（ログイン、データ取得、保存など）
     - Domain の Repository インターフェースを呼び出す

- Infrastructure 層
     - Repository 実装（SQLite, API, SecureStorage など具体的な処理）
     - DB 初期化処理もここに含めてOK
          例えば「SQLite のテーブル作成」「DB オープン」など

- UI 層
     - Application 層の UseCase を呼ぶ
     - UI 表示

# Infrastructure 層の責務
- AppDatabase：SQLite 初期化・テーブル作成
     - CustomerRepositoryImpl：顧客情報のCRUD
     - ScheduleRepositoryImpl：スケジュールのCRUD

- SecureStorageService / PreferenceService：ログイン情報・設定の永続化

# Domain 層
- Customer, Schedule エンティティ
- CustomerRepository, ScheduleRepository インターフェース

# Application 層
- GetCustomerListUseCase
- SaveScheduleUseCase
 などのユースケースで、インターフェースを呼ぶ


# データフローのイメージ

```
外部API (ログイン済みで取得)
       ↓
Infrastructure: RemoteDataSource (APIクライアント)
       ↓
Application: UseCase
       ↓
Infrastructure: LocalDataSource (SQLite)
       ↓
Domain: Repository (CustomerRepository, ScheduleRepository)
       ↓
UI: ViewModel / StateNotifier
```

- 差分同期は UseCase/Repository層 に持たせる
- SQLite の更新は トランザクション処理でまとめて行う
- API から updated_at フィールドが取れると差分検出が楽
- もしAPIが全件しか返さないなら「ローカルとの差分チェック」で同期


# 全件取得APIでも差分同期する方法
1.  全件取得（API）
     - 毎回サーバーから最新データを全件取得する
1. ローカルDBの全件と比較
     - id（ユニークキー）で突合せ
     - updated_at などの更新日時があれば差分判定に利用
     - 無ければ フィールド全比較（コスト大）
1. 差分をDBに反映
     - 新規 → INSERT
     - 更新 → UPDATE
     - 削除 → DELETE（サーバーに存在しないものを消す）

# 注意点
- APIが全件返す＝通信量が多くなる
     → データ量が大きいとモバイル回線に負荷になる可能性あり
- 更新判定が難しい場合
     - updated_at がないと「データ内容が変わったかどうか」を自力で比較する必要がある
     - 例：title や start が異なれば更新とみなす
- 削除検知
     - サーバーの全件からローカルに存在する id がなくなったら削除
