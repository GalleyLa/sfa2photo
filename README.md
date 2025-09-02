# sfa2photo

## クリーンアーキテクチャ寄り?

### ポイント
- DB層の変更がModel/Domainに影響しにくい
- カラム名変更 → UserTable だけ変更で済む
- クリーンアーキテクチャ準拠
- DAO → Repository → UseCase → Presentation
- 将来的な拡張も容易
- 新しいテーブルやカラム追加も、既存コードへの影響最小限

```
lib/
├── application/
│   └── usecases/
│       └── get_user_usecase.dart     // ユースケース
│
├── data/
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
│   └── services                     // ビジネスロジックではないが、アプリを作成するのに必要なクラス
│       └──
│
├── domain/
│   ├── entities/                     // ビジネスオブジェクトの定義
│   │   └── user.dart                 // ドメイン層のエンティティ
│   ├── repositories/                 // データソースへのアクセスを抽象化するインターフェース
│   │   └── user_repository.dart      // ドメイン用インターフェース
│   ├── exceptions 　　　　　　　　　　//  想定される例外の定義
│   │   └──　
│   └── services                     // ビジネスロジックではないが、アプリを作成するのに必要なクラス
│       └──
│
└── presentation/
    ├── pages/
    └── widgets/

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
