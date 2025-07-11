import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:smartfruit/model/UserModel.dart';

class MySQLService {
  final String host = '192.168.2.129';
  final String user = 'root';
  final String password = '1234';
  final String db = 'smartfruit';

  Future<MySqlConnection> _getConnection() async {
    return await MySqlConnection.connect(ConnectionSettings(
      host: host,
      port: 316,
      user: user,
      password: password,
      db: db,
    ));
  }

  Future<void> insertUser(User user) async {
    final conn = await _getConnection();

    try {
      await conn.query(
        'INSERT INTO users (fullname, phonenumber, password) VALUES (?, ?, ?)',
        [user.fullName, user.phone, user.password],
      );
    } catch (e) {
      throw Exception("Lỗi khi thêm người dùng: $e");
    } finally {
      await conn.close();
    }
  }
}