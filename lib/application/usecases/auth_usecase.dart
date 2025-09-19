import '../../domain/entity/auth_entity.dart';
import '../../domain/repository/auth_repository.dart';

class AuthUseCase {
  final AuthRepository repository; // 依存性の注入

  AuthUseCase(this.repository);

  // domain/repository/auth_repository.dart の authenticate を呼び出す
  /*
  execute メソッドの動きは次のとおりです:
  1. 引数を受け取る
    - AuthEntity entity という認証情報を受け取ります。
  2. 認証処理を呼び出す
    - repository.authenticate(entity) を await して結果 (authEntity) を受け取ります。
    - 認証成功なら authEntity にユーザー情報が入ります。失敗なら null です。
  3. 成功時の処理
    - authEntity が null でなければ、repository.saveCredentials(authEntity) を呼び出し、例えばログイン状態やトークンを保存します。
  4. 戻り値を返す
    - authEntity を返します（成功時はユーザー情報、失敗時は null）。
  */

  Future<AuthEntity?> execute(AuthEntity entity) async {
    final authEntity = await repository.authenticate(entity);
    if (authEntity != null) {
      await repository.saveCredentials(authEntity);
    }
    return authEntity;
  }
}
