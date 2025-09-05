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

```
再整理
lib/
├── Application(Logic) // ユースケース（サービス）
│   ├── usecase //アプリケーションのロジック本体
│   └── Interface //アプリケーションと外部APIロジックの仲立ち
│
├── domain/  //エンティティ、リポジトリの抽象（interface）
│   ├── entity //オブジェクト・アプリ共通のモデル定義
│   ├── value  //列挙型(enum)
│   ├── repository: 外部リソースアクセスの仲介インターフェースの定義
│   ├── usecase: アプリケーションロジックインターフェースの定義
│   ├──factory: ドメインエンティティ生成インターフェースの定義
│
├── data // リポジトリ実装・DTO・モデル変換
│   ├── repositories_impl/
│   └─ models/ (DTO, Mapper)
│
├── Infrastructure(Repository)　// APIクライアント・DB・外部サービス実装
│   ├── mock
│   ├── local
│   │   └── db
│   │       └──  
│   ├── remote
│   ├── datasource: 実際に外部リソースとやりとりするインターフェースの定義と実装
│   ├── model: データソースモデル定義
│   ├── repository: ドメイン層で定義したrepositoryの実装
│   ├── factory: ドメイン層で定義したfactoryの実装
│
├── presentation/
│   ├── screens/  (page)
│   │   └── login_screen.dart
│   ├── viewmodels/
│   │   └── login_viewmodel.dart
│   ├── provider
│   ├── navigation (画面遷移を関数に)
│   ├── extension (アイコンを列挙するなど)
│   ├── component 
│   ├── state

```


```
lib/
├── domain/
│   ├── entities/ // ビジネスオブジェクトの定義
│   │   ├── password.dart
│   │   └── user.dart   
│   ├── repositories/  // データソースへのアクセスを抽象化するインターフェース
│   │   └── password_repository.dart
│   ├── usecases/
│   │   ├── save_password_usecase.dart
│   │   └── get_password_usecase.dart
│   ├── exceptions 　//  想定される例外の定義
│   │   └──　
│   └── services    // ビジネスロジックではないが、アプリを作成するのに必要なクラス
│   
├── data/
│   ├── datasources/
│   │   └── secure_storage_datasource.dart
│   ├── repositories/
│   │   └──password_repository_impl.dart
│   ├── local/
│   │   ├── db/
│   │   │   ├── app_database.dart      // DB初期化、接続
│   │   │   └── tables/
│   │   │       └── user_table.dart   // カラム名定義
│   │   └── dao/                      // DAO (Data Access Object) の定義
│   │       └── user_dao.dart         // DB操作（CRUD）
│   ├── models/
│   │   └── user_model.dart           // DB ↔ アプリのModel
│   ├── repositories/ 
│   │   └──　
│   └── services  // ビジネスロジックではないが、アプリを作成するのに必要なクラス
│ 
├── Infrastructure //API呼び出し・外部依存
│
├── presentation/
│   ├── screens/
│   │   └── login_screen.dart
│   ├── viewmodels/
│       └── login_viewmodel.dart

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

## セキュアストレージがからパスワードを取り出す手順
Presentation → Domain (UseCase) → Data (Repository) → DataSource (SecureStorage)
- SecureStorageDataSource が FlutterSecureStorage.read を呼ぶ
- RepositoryImpl がそれを受け取って Password エンティティに包む
- UseCase がそのエンティティを返す
- ViewModel が state にセットする
- UI がそれを表示する
