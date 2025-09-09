/*
fid	"-1"
fvid	"-1"
cid	"69421"
layout	"detail"
type	"plan"
*/
// UseCaseで抽出する例
class ExtractKeyUseCase {
  String execute(Map<String, dynamic> data) {
    // 取得データから必要なキーを選択（例: tenantId）
    return data['tenant_id'] as String;
  }
}
