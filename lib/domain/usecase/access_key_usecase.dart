import 'package:shared_preferences/shared_preferences.dart';
import '../model/access_key_model.dart';

abstract class AccessKeyUsecase {
  Future<bool> store(String token, String databaseId);
  Future<AccessKeyModel> load();
}

class AccessKeyUsecaseImpl implements AccessKeyUsecase {
  final String tokenKey = 'notion-token';
  final String databaseIdKey = 'notion-database-id';

  @override
  Future<bool> store(String token, String databaseId) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString(tokenKey, token);
    await prefs.setString(databaseIdKey, databaseId);
    // TODO: エラーハンドリング

    return true;
  }

  @override
  Future<AccessKeyModel> load() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    return AccessKeyModel(
      token: prefs.getString(tokenKey) ?? '',
      databaseId: prefs.getString(databaseIdKey) ?? ''
    );
  }
}
