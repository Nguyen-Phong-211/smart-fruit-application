import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:smartfruit/api/api_service.dart';
import 'login.dart';
import 'package:smartfruit/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Smart Fruit',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: 'Roboto',
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        inputDecorationTheme: InputDecorationTheme(
          floatingLabelStyle: TextStyle(color: Colors.green),
          filled: true,
          fillColor: Colors.green[50],
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green.shade200),
            borderRadius: BorderRadius.circular(12.r),
          ),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.green, width: 2.w),
            borderRadius: BorderRadius.circular(12.r),
          ),
        ),
      ),
      home: SignUpPage(),
    );
  }
}

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> with SingleTickerProviderStateMixin {
  final _fullNameController = TextEditingController();
  final _numberphoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isPasswordVisible = false;  // Biến theo dõi trạng thái hiển thị mật khẩu

  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _scaleAnimation = Tween<double>(begin: 0.85, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOutBack),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _numberphoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool isPassword = false,
    TextInputType inputType = TextInputType.text,
    List<TextInputFormatter>? inputFormatters,
  }) {
    return TextField(
      controller: controller,
      obscureText: isPassword && !_isPasswordVisible,  // Kiểm tra trạng thái ẩn/hiện mật khẩu
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      style: TextStyle(fontSize: 12.sp),
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        labelText: label,
        labelStyle: TextStyle(fontSize: 13.sp),
        prefixIcon: Icon(icon, size: 20.sp, color: Colors.green),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.green,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;  // Toggle trạng thái hiển thị mật khẩu
            });
          },
        )
            : null,
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Lỗi'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('OK'),
          ),
        ],
      ),
    );
  }

  Widget buildGoogleButton() {
    return InkWell(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tính năng đang phát trển')),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.w, horizontal: 16.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12.r),
          border: Border.all(color: Colors.grey.shade300, width: 1.2.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8.r,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/google_logo.png',
              height: 20.h,
              width: 20.w,
            ),
            SizedBox(width: 5.h),
            Text(
              'Đăng nhập với Google',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.black87,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green[600],
        title: Text(
            'Đăng ký',
          style: TextStyle(fontSize: 18.sp, color: Colors.white),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ),
      backgroundColor: Colors.green[100],
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SingleChildScrollView(
                padding: EdgeInsets.all(24.w),
                child: Container(
                  padding: EdgeInsets.all(28.w),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.green[50]!],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(24.r),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 20.r,
                        offset: Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Image.asset('assets/logo.png', height: 100.h, width: 150.w,),
                      SizedBox(height: 5.h),
                      Text(
                        'Smart Fruit',
                        style: TextStyle(
                          fontSize: 14.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                          letterSpacing: 1.2,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: 5.0.h),
                      Text(
                        'Đo độ tươi – Bảo vệ sức khoẻ mỗi ngày',
                        style: TextStyle(
                          fontSize: 10.0.h,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Đăng ký',
                        style: TextStyle(
                          fontSize: 15.0.sp,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                          letterSpacing: 1.2,
                          fontFamily: 'Montserrat',
                        ),
                      ),
                      SizedBox(height: 15.h),
                      buildTextField(
                        controller: _fullNameController,
                        label: 'Họ và tên',
                        icon: Icons.person,
                      ),
                      SizedBox(height: 15.h),
                      buildTextField(
                        controller: _numberphoneController,
                        label: 'Số điện thoại',
                        icon: Icons.phone,
                        inputType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                          LengthLimitingTextInputFormatter(10),
                        ],
                      ),
                      SizedBox(height: 15.h),
                      buildTextField(
                        controller: _passwordController,
                        label: 'Mật khẩu',
                        icon: Icons.lock,
                        isPassword: true,
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () async {
                          String fullName = _fullNameController.text.trim();
                          String phone = _numberphoneController.text.trim();
                          String password = _passwordController.text.trim();

                          if (fullName.isEmpty) {
                            _showErrorDialog("Họ và tên không được để trống.");
                            return;
                          }

                          if (phone.length != 10) {
                            _showErrorDialog("Số điện thoại phải gồm đúng 10 chữ số.");
                            return;
                          }

                          if (password.length < 8) {
                            _showErrorDialog("Mật khẩu phải từ 8 ký tự trở lên.");
                            return;
                          }

                          try {
                            ApiService apiService = ApiService();
                            bool success = await apiService.signup(fullName, phone, password);

                            if (success) {
                              showDialog(
                                context: context,
                                builder: (context) => AlertDialog(
                                  title: Text('Thành công'),
                                  content: Text('Đăng ký thành công.'),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        Navigator.pop(context);
                                        Navigator.push(context, MaterialPageRoute(builder: (_) => LoginPage()));
                                      },
                                      child: Text('Đăng nhập'),
                                    ),
                                  ],
                                ),
                              );
                            } else {
                              _showErrorDialog('Lỗi đăng ký.');
                            }
                          } catch (e) {
                            _showErrorDialog("Lỗi kết nối đến máy chủ: ${e.toString()}");
                          }
                        },

                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green[600],
                          padding: EdgeInsets.symmetric(vertical: 14.w, horizontal: 32.h),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12.r),
                          ),
                          elevation: 5,
                        ),
                        child: Text(
                          'Đăng ký',
                          style: TextStyle(fontSize: 12.sp, color: Colors.white),
                        ),
                      ),

                      SizedBox(height: 10.h),

                      buildGoogleButton(),

                      SizedBox(height: 10.h),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => LoginPage()),
                          );
                        },
                        child: Text(
                          'Đã có tài khoản? Đăng nhập',
                          style: TextStyle(color: Colors.green[800], fontSize: 12.sp),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
