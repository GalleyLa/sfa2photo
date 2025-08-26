# sfa2photo

A new Flutter project.


lib/
 ├── main.dart          # エントリーポイント
 ├── ui/                # UI層 (画面, Widget)
 │    └── login_page.dart
 ├── application/       # アプリケーション層 (状態管理, UseCase)
 │    └── login_usecase.dart
 ├── domain/            # ドメイン層 (モデル定義, エンティティ)
 │    └── user.dart
 └── infrastructure/    # インフラ層 (API通信, DB, 外部接続)
      └── api_service.dart
