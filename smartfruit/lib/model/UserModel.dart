class User {
  final String fullName;
  final String phone;
  final String password;

  User({required this.fullName, required this.phone, required this.password});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      fullName: json['fullname'],
      phone: json['phonenumber'],
      password: json['password'],
    );
  }
}

class UserLogin {
  final String fullName;
  final String phone;
  final int userId;
  final String? email;
  final String? avatarUrl;
  final String token;

  UserLogin({required this.fullName, required this.phone, required this.userId, this.email, this.avatarUrl, required this.token});
  factory UserLogin.fromJson(Map<String, dynamic> json) {
    return UserLogin(
      fullName: json['user']['fullname'],
      phone: json['user']['phonenumber'],
      userId: json['user']['user_id'],
      email: json['user']['email'],
      avatarUrl: json['user']['avatar_url'],
      token: json['access_token'],
    );
  }
}

class UpdateProfileUserModel {
  final int userId;
  final String fullname;
  final String phonenumber;
  final String? email;
  final String? avatar;
  final String? avatarUrl;

  UpdateProfileUserModel({
    required this.userId,
    required this.fullname,
    required this.phonenumber,
    this.email,
    this.avatar,
    this.avatarUrl,
  });

  factory UpdateProfileUserModel.fromJson(Map<String, dynamic> json) {
    return UpdateProfileUserModel(
      userId: json['user_id'],
      fullname: json['fullname'],
      phonenumber: json['phonenumber'],
      email: json['email'],
      avatar: json['avatar'],
      avatarUrl: json['avatar_url'],
    );
  }
}

class UserGoogleModel {
  final int userId;
  final String userCode;
  final String fullname;
  final String? phonenumber;
  final String email;
  final String? googleId;
  final String? avatar;
  final String isActive;
  final String createdAt;
  final String updatedAt;
  final int roleId;

  UserGoogleModel({
    required this.userId,
    required this.userCode,
    required this.fullname,
    required this.phonenumber,
    required this.email,
    required this.googleId,
    required this.avatar,
    required this.isActive,
    required this.createdAt,
    required this.updatedAt,
    required this.roleId,
  });

  factory UserGoogleModel.fromJson(Map<String, dynamic> json) {
    return UserGoogleModel(
      userId: json['user']['user_id'],
      userCode: json['user']['user_code'],
      fullname: json['user']['fullname'],
      phonenumber: json['user']['phonenumber'],
      email: json['user']['email'],
      googleId: json['user']['google_id'],
      avatar: json['user']['avatar'],
      isActive: json['user']['is_active'],
      createdAt: json['user']['created_at'],
      updatedAt: json['user']['updated_at'],
      roleId: json['user']['role_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'user_code': userCode,
      'fullname': fullname,
      'phonenumber': phonenumber,
      'email': email,
      'google_id': googleId,
      'avatar': avatar,
      'is_active': isActive,
      'created_at': createdAt,
      'updated_at': updatedAt,
      'role_id': roleId,
    };
  }
}





