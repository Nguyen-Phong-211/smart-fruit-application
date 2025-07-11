import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:smartfruit/model/DetectionHistoryModel.dart';
import 'api_constants.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'package:smartfruit/model/FruitModel.dart';
import 'package:smartfruit/model/BlogModel.dart';
import 'package:smartfruit/utils/shared_prefs_helper.dart';
import 'package:smartfruit/model/ScanFruitModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter/material.dart';

class ApiService {
  // Method đăng ký
  Future<bool> signup(String fullName, String phone, String password) async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/signup");
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "fullname": fullName,
        "phonenumber": phone,
        "password": password,
      }),
    );

    if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  }

  // GET USER_ID
  Future<int?> getSavedUserId() async {
    return await SharedPrefsHelper.getUserId();
  }

  // API LOGIN
  Future<UserLogin?> login(String phone, String password) async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/login");
    var response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({
        "phonenumber": phone,
        "password": password,
      }),
    );

    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      var jsonData = json.decode(response.body);
      UserLogin userLogin = UserLogin.fromJson(jsonData);

      await SharedPrefsHelper.saveUserId(userLogin.userId);
      await SharedPrefsHelper.saveToken(userLogin.token);
      await SharedPrefsHelper.getToken();


      print('Token Login: ${userLogin.token}');

      return userLogin;
    } else {
      throw Exception('Số điện thoại hoặc mật khẩu không đúng');
    }
  }


  // API GET fruits
  Future<List<FruitModel>> getFruits() async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/fruits");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List data = jsonData['data'];
      return data.map((item) => FruitModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load fruits');
    }
  }

 // API GET BLOGS
  Future<List<BlogModel>> getBlogs() async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/blogs");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List data = jsonData['data'];
      return data.map((item) => BlogModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load blogs');
    }
  }

  // API GET DETAIL BLOG
  Future<BlogDetailModel> getBlogDetail(int blogId) async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/blogs/$blogId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data'];
      return BlogDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load blog detail');
    }
  }

  // API GET LIST DECTECTION HISTORY
  Future<List<DetectionHistoryModel>> getDetectionHistoryList() async {
    int? userId = await SharedPrefsHelper.getUserId();

    if (userId == null) {
      throw Exception('User not logged in');
    }

    var url = Uri.parse("${AppConstants.apiBaseUrl}/detection-history/$userId");

    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      List<dynamic> data = jsonData['data'];

      return data.map((item) => DetectionHistoryModel.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load detection history');
    }
  }

  // API GET LIST DETAIL OF DETECTION HISTORY
  Future<DetectionHistoryDetailModel> getDetectionHistoryDetail(int deTectionHistoryId) async {
    var url = Uri.parse("${AppConstants.apiBaseUrl}/detection-history/detail/$deTectionHistoryId");
    var response = await http.get(url);

    if (response.statusCode == 200) {
      var jsonData = jsonDecode(response.body);
      var data = jsonData['data'];
      return DetectionHistoryDetailModel.fromJson(data);
    } else {
      throw Exception('Failed to load detail detection history');
    }
  }

  // API PREDICT
  Future<ScanFruitResult?> scanFruit(String base64Image) async {
    try {
      final prefs = await SharedPrefsHelper.getToken();
      print('Token: ${prefs}');

      if (prefs == null || prefs.isEmpty) {
        print('Token không tồn tại, người dùng chưa đăng nhập');
        return null;
      }

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/detection-history/predict'),
        body: jsonEncode({'image': base64Image}),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $prefs',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if (jsonData != null && jsonData['status'] == 'success' && jsonData['data'] != null) {
          return ScanFruitResult.fromJson(jsonData);
        } else {
          print('API trả về dữ liệu không hợp lệ hoặc thất bại: $jsonData');
          return null;
        }
      } else {
        print('Lỗi server: ${response.statusCode} - ${response.body}');
        return null;
      }
    } catch (e) {
      print('Lỗi gọi API: $e');
      return null;
    }
  }
  // API SAVE RESULT BEFORE PREDICTING
  Future<bool> saveScanResult(ScanSaveRequest request) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/detection-history/save');
    final prefs = await SharedPrefsHelper.getToken();

    final int? userId = await SharedPrefsHelper.getUserId();

    if (userId == null) {
      print("user_id không tồn tại");
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $prefs',
        'Accept': 'application/json',
      },
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      print('Lưu thất bại: ${response.body}');
      return false;
    }
  }


  //API CHATBOX
  Future<String> getAnswer(String question) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/chatbox/getAnswer');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({'query': question}),
    );

    print('Status code: ${response.statusCode}');
    print('Response body: ${response.body}');

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['answer'] ?? 'Không có câu trả lời';
    } else {
      return 'Lỗi khi gọi API: ${response.statusCode}';
    }
  }

  //API GET COUNT FRUIT FRESHNESS BY DAY
  Future<Map<String, int>> getDailyFruitStats() async {
    final int? userId = await SharedPrefsHelper.getUserId();

    final response = await http.get(
      Uri.parse('${AppConstants.apiBaseUrl}/home/getStatistics?user_id=$userId'),
      headers: {
        'Accept': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      return {
        'fresh': json['fresh'] ?? 0,
        'spoiled': json['spoiled'] ?? 0,
      };
    } else {
      throw Exception('Failed to load stats');
    }
  }

  // API UPDATE PROFILE USER
  Future<UpdateProfileUserModel?> updateProfile({
    required int userId,
    required String fullname,
    required String phonenumber,
    required String email,
    String? base64Avatar,
  }) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/user/updateProfile?user_id=$userId');

    final Map<String, dynamic> body = {
      'fullname': fullname,
      'phonenumber': phonenumber,
      'email': email,
    };

    if (base64Avatar != null) {
      body['avatar'] = base64Avatar;
    }

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      },
      body: jsonEncode(body),
    );

    print("Update profile response: ${response.body}");

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final userJson = jsonData['user'];
      return UpdateProfileUserModel.fromJson(userJson);
    } else {
      throw Exception('Cập nhật thông tin thất bại');
    }
  }

  Future<bool> sendOtp(String email) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/auth/send-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Gửi OTP thất bại');
    }
  }

  Future<bool> verifyOtp(String email, String otp) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/auth/verify-otp');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'otp': otp}),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'OTP không hợp lệ');
    }
  }

  Future<bool> changePassword({
    required String email,
    required String otp,
    required String newPassword,
    required String confirmPassword,
  }) async {
    final url = Uri.parse('${AppConstants.apiBaseUrl}/password/change');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'otp': otp,
        'password': newPassword,
        'password_confirmation': confirmPassword,
      }),
    );

    if (response.statusCode == 200) {
      return true;
    } else {
      throw Exception(jsonDecode(response.body)['message'] ?? 'Đổi mật khẩu thất bại');
    }
  }

  final GoogleSignIn _googleSignIn = GoogleSignIn(
    scopes: ['email'],
    serverClientId: '323403720129-qgikfsv9lrg22rs1meev58l2c135gouv.apps.googleusercontent.com',
  );

  Future<Map<String, dynamic>> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        return {'success': false, 'message': 'User cancelled Google sign-in'};
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final idToken = googleAuth.idToken;

      if (idToken == null) {
        return {'success': false, 'message': 'Cannot get idToken from Google'};
      }

      final response = await http.post(
        Uri.parse('${AppConstants.apiBaseUrl}/google/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'id_token': idToken}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['user'] != null && data['token'] != null) {
          final user = UserGoogleModel.fromJson(data['user']);
          final token = data['token'];

          await SharedPrefsHelper.saveUser(user);
          await SharedPrefsHelper.saveToken(token);

          return {'success': true, 'data': data};
        } else {
          return {'success': false, 'message': 'Invalid response from server'};
        }
      } else {
        final error = jsonDecode(response.body);
        return {'success': false, 'message': error['message'] ?? 'Login failed'};
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }


}
