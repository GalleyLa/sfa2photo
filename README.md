# sfa2photo

## クリーンアーキテクチャ寄り?

### 基本的な分離方針
Clean Architecture では大きく以下のレイヤーに分けるのが一般的です：

- Domain 層
  - ビジネスルール、ユースケース、エンティティを定義
  - 具体的なストレージ技術に依存しない
     - 例：SavePasswordUseCase, GetPasswordUseCase
- Data 層
  - リポジトリの実装
     - Secure Storage などの外部依存をここに閉じ込める
     - 例：SecureStoragePasswordRepository
- Infrastructure 層（or DataSource）
  - 実際に flutter_secure_storage を呼ぶ部分
     - 例：SecureStorageDataSource
- Presentation 層
     - UI, ViewModel, StateNotifier / Bloc
     - ユースケースを呼び出して状態を更新するだけ

クリーンアーキテクチャ構成図
```
lib/
├── application/
│   ├── usecases/
│        ├── auth_usecase.dart            //認証を行い成功したら認証結果を保存しステータスを返す（流れのみ）
│        ├── group_schedules_usecase.dart //日付を設定しスケジュールデータを取得しmapを返す（流れのみ）
│        ├── schedules_usecase.dart       //日付を設定しスケジュールデータを取得しmapを返す（流れのみ）
│
├── domain/
│   ├── entity/                          //アプリ内で使う安定した形
│   │    ├── auth_entity.dart            //認証情報
│   │    ├── schedule_entity.dart        //スケジュール情報
│   │
│   ├── mapper/
│   │    ├── schedule_mapper.dart        //スケジュールの種類の変換
│   │
│   ├── repository/                     //インターフェース
│   │    ├── auth_repository.dart       //認証関連でどの様な操作があるか
│   │    ├── schedule_repository.dart   //スケジュールでどの様な操作があるか
│　 │
│   ├── value
│   　   ├── schedule_type.dart         //スケジュールで利用するシンボル・色の定義
│
├── infrastructure/
│   ├── local/
│   │    ├── db/
│   │    │   ├── tables/                      //DBカラム名定義
│   │    │       └── schedule_table.dart   
│   │    ├── dao/　　　　　　　　　　　　　　　//SQLite操作
│   │    ├── models/　　　　　　　　　　　　　 //DB用モデル
│   │        └── schedule_model.dart         //DB ↔ アプリのModel
│   │
│   ├── remote/
│   │   ├── dto/                           //APIレスポンスの形そのまま
│   │   │    └──                           //APIアクセス処理
│   │   ├──
│   │
│   ├──  mappers/                          //DTO,Model <-> Entity 変換
│   │   ├──
│   │ 
│   ├──  repositories_impl/                //DB+APIを統合し、ドメインに提供
│   │   ├── 
│   │        
│   ├── service/
│   │    ├── auth_api_service.dart        //認証アクセス(Remoteのフォルダが良い？)
│   │    ├── base_api_service.dart        //httpアクセス共通部分
│   │    ├── schedule_repository_impl.dart //スケジュール取得 
│   │
│   ├── auth_repository_impl.dart         //認証に関係した一連の処理の実装
│   ├── group_schedules_usecase.dart      //スケジュールに関連した処理の実装
│   
├── presentation/
│   ├── pages/
│   │   ├── home_screen.dart             //ログイン後のスケジュール取得（仮）
│   │   ├── login_screen.dart            //ログイン用スクリーン
│   │   ├── schedule_calendar_screen.dart //カレンダー表示画面
│   │
│   ├── provider/
│   │   ├── auth_provider.dart       // 認証関連の Repo / UseCase / State
│   │   ├── common_provider.dart     // 共通ロジック用
│   │   ├── schedule_notifier_provider.dart   // スケジュール関連の Repo / UseCase / State
│   │  
│   ├── state/
│   │   ├── auth_state.dart       // 認証関連の Repo / UseCase / State
│   │   ├── schedule_state.dart       // 認証関連の Repo / UseCase / State
│   │
│   ├── widgets/
│   │   ├── app_text_field.dart
│   │   ├── loading_indicator.dart  //ローディングUI
│
├── shared/
│   ├── utils/
│   │   ├── date_formatter_impl.dart  　//日付処理
│   │   ├── date_formatter_provider.dart　
│   │   ├── date_formatter.dart　　　　//日付処理（repository)
│
└── main.dart

```
API × DB × アプリ の役割分離イメージ
[外部API] -----> DTO（Data層のRemoteモデル）
                       |
                       v
[アプリ内部で使いやすいModel/Entity] <-----> DBモデル（Local）

層ごとの責務整理

Data層
     RemoteDataSource：API通信
     LocalDataSource：SQLite
     RepositoryImpl：両方を統合し、UseCaseに渡す
Domain層
     Entity（アプリ内部で扱うデータ構造）
     Repositoryインターフェース（Data層実装を抽象化）
Application層
     UseCase（ビジネスルールに沿った操作。例えば「ユーザー取得」「データ同期」など）

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

# Repository層の責務
- ScheduleRepository
     - Future<List<ScheduleEntity>> fetchSchedules()
     - Future<void> saveSchedules(List<ScheduleEntity>)
     - Future<List<ScheduleEntity>> loadSchedules()
- CustomerRepository
     - Future<CustomerEntity?> fetchCustomer(String scheduleId)

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

## セキュアストレージがからパスワードを取り出す手順
Presentation → Domain (UseCase) → Data (Repository) → DataSource (SecureStorage)
- SecureStorageDataSource が FlutterSecureStorage.read を呼ぶ
- RepositoryImpl がそれを受け取って Password エンティティに包む
- UseCase がそのエンティティを返す
- ViewModel が state にセットする
- UI がそれを表示する


## .envは何処で行うか
### 原則

- domain層 / application層 は環境変数やAPIの詳細を知らない。
- infrastructure層 の 実装部分 (AuthApiService) が外部依存（Dio・ベースURL）を持つ。
- .env の読み込みは フレームワーク依存部分（最上位 / main.dart 付近） で行い、依存性注入（DIコンテナ経由）で AuthApiService に値を渡すのが適切。
### 実装まとめ
- .env の読み込みは framework 層（main.dart）で実行。
- そこで得た値を DI コンテナ（get_it）経由で infrastructure 層の AuthApiService に渡す。
- domain / application 層は .env の存在を意識しない。


### 方針
#### OCESS認証周りの処理
- UI 層は Riverpod の authEntityProvider から直接 id や name を参照可能。
- domain/application 層は AuthEntity という統一的な型を通じて情報を扱うため、Mapの構造に依存しない。
- 認証成功後は id / name を SecureStorage に保存
- AuthApiService が 1つの Dio + CookieJar を管理
- 他APIサービス (SomeOtherApiService) も AuthApiServiceが持つDioを使う ことで Cookie を共有
- Cookie 管理は Dio + CookieManager に一任
- 追加で必要な id は queryParameters や headers に明示的に付与
- domain 層 / application 層は「Cookie」という技術的詳細を意識せずに済む
- id 付与は必ず自動化（BaseApiService に集約）
- 必須パラメータ（id） は BaseApiService で自動付与
- 追加パラメータは柔軟に対応（呼び出し側で queryParameters 
- 呼び出し先 API ごとに仕様が違っても、共通基盤を崩さずに拡張可能
- BaseApiService では 呼び出し側のパラメータとマージするだけ


##
1. ログイン
- 認証API呼び出し → Cookie管理（Dio + CookieManager）
- 内部IDを取得・保持
1. スケジュール一覧取得（内部ID必須）
- APIから日付付きスケジュールデータを取得
- ローカルDBに保存
- UI：カレンダービューに表示
1. 顧客情報取得（スケジュールID必須）
- カレンダービューでユーザがスケジュールをタップ
- スケジュールIDをキーにAPI呼び出し（内部ID + scheduleId）
- 顧客情報を取得し、UIに表示

#### 認証後のデータ取得
1. 認証
     - 入力: ユーザID / パスワード
     - 処理: 認証API呼び出し（Cookie + 内部ID取得）
     - 出力: 内部ID
1. 保存: SecureStorage に保存
     - 内部IDに紐づいたデータ取得
     - 入力: 内部ID（自動付与）
     - 処理: BaseApiService + Cookieでデータ取得
     - 出力: データ（例: テナント一覧, プロジェクト一覧）
1. 取得データ内から特定のキーを抽出
     - 入力: 2の結果
     - 処理: プレゼンテーション層（UI or UseCase）で選択/抽出
     - 出力: 一時識別子（tenantIdやprojectIdなど）
1. キーを使って更にデータ取得
     - 入力: 内部ID + 一時識別子（例: tenantId）
     - 処理: BaseApiService の呼び出し時に queryParameters に追加
     - 出力: 特定のデータ
1. ローカルDBに保存 → アプリケーションで利用
     - 入力: 3,4で取得したデータ
     - 処理: infrastructure層の LocalDatabaseService に保存
     - 出力: domain entity として再利用可能

#### 流れ
```
起動時
 └─ LocalDatabaseService.loadData() → DBに保存済みデータを読み込み → UIに表示

同期時（ユーザ操作）
 ├─ AuthApiService で認証（必要なら再ログイン）
 ├─ BaseApiService 経由で内部ID付きAPI呼び出し
 ├─ 取得データから一時識別子（tenantIdなど）抽出
 ├─ 追加API呼び出し（内部ID + tenantId）
 ├─ LocalDatabaseService.saveData() → DB更新
 └─ Riverpod state 更新 → UI再描画
```

## OCESS仕様
 
- 認証APIは「トークン」ではなく「Cookie」を返す
- member_id が Cookie に入っており、アプリはこれを保持する必要がある
- 他のAPI呼び出しの際は
     - Cookie を添付してセッションを維持
     - さらに id をリクエストに含める

