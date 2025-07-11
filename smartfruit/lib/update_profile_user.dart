import 'package:flutter/material.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'utils/shared_prefs_helper.dart';

class UpdateProfileUserScreen extends StatefulWidget {
  final UpdateProfileUserModel user;

  const UpdateProfileUserScreen({super.key, required this.user});

  @override
  State<UpdateProfileUserScreen> createState() => _UpdateProfileUserScreenState();
}

class _UpdateProfileUserScreenState extends State<UpdateProfileUserScreen> {
  late TextEditingController _fullnameController;
  late TextEditingController _phoneController;
  late TextEditingController _emailController;

  @override
  void initState() {
    super.initState();
    _fullnameController = TextEditingController(text: widget.user.fullname);
    _phoneController = TextEditingController(text: widget.user.phonenumber);
    _emailController = TextEditingController(text: widget.user.email);
  }

  @override
  void dispose() {
    _fullnameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cập nhật thông tin', style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              CircleAvatar(
                radius: 50.r,
                backgroundColor: Colors.grey[300],
                backgroundImage: widget.user.avatarUrl != null && widget.user.avatarUrl!.isNotEmpty
                    ? NetworkImage(widget.user.avatarUrl!)
                    : null,
                child: widget.user.avatarUrl == null || widget.user.avatarUrl!.isEmpty
                    ? Icon(Icons.person, size: 50.r, color: Colors.white)
                    : null,
              ),
              SizedBox(height: 20.h),
              TextField(controller: _fullnameController, decoration: InputDecoration(labelText: 'Họ tên')),
              SizedBox(height: 15.h),
              TextField(controller: _phoneController, decoration: InputDecoration(labelText: 'Số điện thoại')),
              SizedBox(height: 15.h),
              TextField(controller: _emailController, decoration: InputDecoration(labelText: 'Email')),
              SizedBox(height: 20.h),
              ElevatedButton(
                onPressed: () async {
                  final fullname = _fullnameController.text.trim();
                  final phone = _phoneController.text.trim();
                  final email = _emailController.text.trim();

                  String? base64Avatar;

                  try {
                    final updatedUser = await ApiService().updateProfile(
                      userId: widget.user.userId,
                      fullname: fullname,
                      phonenumber: phone,
                      email: email,
                      base64Avatar: base64Avatar,
                    );

                    if (updatedUser != null) {
                      await SharedPrefsHelper.saveUserProfile(updatedUser);

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cập nhật thành công')),
                      );

                      Navigator.pop(context, updatedUser);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Cập nhật thất bại')),
                      );
                    }
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: ${e.toString()}')),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[600],
                  padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 32.w),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  elevation: 5,
                ),
                child: Text(
                  'Cập nhật',
                  style: TextStyle(fontSize: 12.sp, color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
