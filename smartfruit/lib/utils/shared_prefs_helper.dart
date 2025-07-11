import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'dart:convert';

class SharedPrefsHelper {
  static Future<void> saveUserId(int userId) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', userId);
  }

  static Future<int?> getUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt('user_id');
  }

  static Future<void> clearUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
  }

  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('access_token', token);
  }

  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  //
  static Future<void> saveUserProfile(UpdateProfileUserModel user) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('user_id', user.userId);
    await prefs.setString('fullname', user.fullname);
    await prefs.setString('phonenumber', user.phonenumber);
    await prefs.setString('email', user.email ?? '');

    if (user.avatar != null) {
      await prefs.setString('avatar', user.avatar!);
    }
    if (user.avatarUrl != null) {
      await prefs.setString('avatar_url', user.avatarUrl!);
    }
  }

  static Future<UpdateProfileUserModel?> getUserProfile() async {
    final prefs = await SharedPreferences.getInstance();

    final userId = prefs.getInt('user_id');
    final fullname = prefs.getString('fullname');
    final phonenumber = prefs.getString('phonenumber');
    final email = prefs.getString('email');
    final avatar = prefs.getString('avatar');
    final avatarUrl = prefs.getString('avatar_url');

    if (userId != null && fullname != null && phonenumber != null) {
      return UpdateProfileUserModel(
        userId: userId,
        fullname: fullname,
        phonenumber: phonenumber,
        email: email,
        avatar: avatar,
        avatarUrl: avatarUrl,
      );
    }
    return null;
  }

  static Future<String?> getFullname() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('fullname');
  }

  static Future<void> clearUserProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_id');
    await prefs.remove('fullname');
    await prefs.remove('phonenumber');
    await prefs.remove('email');
    await prefs.remove('avatar');
    await prefs.remove('avatar_url');
  }

  static const String _userKey = 'user';
  static const String _tokenKey = 'token';

  static Future<void> saveUser(UserGoogleModel user) async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = jsonEncode(user.toJson());
    await prefs.setString(_userKey, userJson);
  }

  static Future<UserGoogleModel?> getUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userJson = prefs.getString(_userKey);
    if (userJson != null) {
      return UserGoogleModel.fromJson(jsonDecode(userJson));
    }
    return null;
  }

  static Future<void> saveTokenGoogle(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  static Future<String?> getTokenGoogle() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
  }

}
