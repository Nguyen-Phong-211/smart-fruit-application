import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'signup.dart';
import 'package:smartfruit/home.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'utils/shared_prefs_helper.dart';


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
      builder: (context, child) {
        return MediaQuery(
          data: MediaQuery.of(context).copyWith(textScaleFactor: 1.0),
          child: child!,
        );
      },
      home: LoginPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> with SingleTickerProviderStateMixin {
  final _numberphoneController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _rememberMe = true;
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
      obscureText: isPassword && !_isPasswordVisible,
      keyboardType: inputType,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        isDense: true,
        contentPadding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 12.w),
        labelText: label,
        labelStyle: TextStyle(fontSize: 12.sp),
        prefixIcon: Icon(icon, color: Colors.green, size: 20.sp),
        suffixIcon: isPassword
            ? IconButton(
          icon: Icon(
            _isPasswordVisible ? Icons.visibility_off : Icons.visibility,
            color: Colors.green,
          ),
          onPressed: () {
            setState(() {
              _isPasswordVisible = !_isPasswordVisible;
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

  final apiService = ApiService();

  Widget buildGoogleButton() {
    return InkWell(
      onTap: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Tính năng đang phát trển')),
        );
      },
      borderRadius: BorderRadius.circular(12.r),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
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
      backgroundColor: Colors.green[100],
      body: Center(
        child: AnimatedBuilder(
          animation: _scaleAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _scaleAnimation.value,
              child: SingleChildScrollView(
                  // double screenWidth = MediaQuery.of(context).size.width,
                  padding: EdgeInsets.all(24.w),
                child: Container(
                  // constraints: BoxConstraints(maxWidth: 400),
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
                      Image.asset(
                          'assets/logo.png',
                          height: 100.h,
                          width: 150.w,
                      ),
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
                        'Định chuẩn độ tươi - Nâng cao trải nghiệm',
                        style: TextStyle(
                          fontSize: 10.0.sp,
                          fontStyle: FontStyle.italic,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 10.h),
                      Text(
                        'Đăng nhập',
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
                      SizedBox(height: 5.h),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Checkbox(
                                value: _rememberMe,
                                activeColor: Colors.green,
                                onChanged: (val) => setState(() => _rememberMe = val!),
                              ),
                              Text('Ghi nhớ đăng nhập'),
                            ],
                          ),
                        ],
                      ),
                      SizedBox(height: 10.h),
                      ElevatedButton(
                        onPressed: () async {
                          String phone = _numberphoneController.text.trim();
                          String password = _passwordController.text.trim();

                          if (phone.length != 10) {
                            _showErrorDialog("Số điện thoại phải gồm đúng 10 chữ số.");
                            return;
                          }

                          if (password.length < 8) {
                            _showErrorDialog("Mật khẩu phải từ 8 ký tự trở lên.");
                            return;
                          }
                          try {
                            var userLogin = await ApiService().login(phone, password);

                            if (userLogin != null) {
                              UpdateProfileUserModel userProfile = UpdateProfileUserModel(
                                userId: userLogin.userId,
                                fullname: userLogin.fullName,
                                phonenumber: userLogin.phone,
                                email: userLogin.email ?? '',
                                avatarUrl: userLogin.avatarUrl ?? '',
                              );

                              await SharedPrefsHelper.saveUserProfile(userProfile);

                            }

                            if (userLogin != null) {
                              print("Login success. UserID: ${userLogin.userId}");
                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(builder: (_) => HomeScreen()),
                              );
                            }
                          } catch (e) {
                            _showErrorDialog("Đăng nhập thất bại: $e");
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
                          'Đăng nhập',
                          style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.white
                          ),
                        ),
                      ),
                      SizedBox(height: 10.h),

                      buildGoogleButton(),

                      SizedBox(height: 10.h),

                      TextButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => SignUpPage()),
                          );
                        },
                        child: Text(
                          'Chưa có tài khoản? Đăng ký',
                          style: TextStyle(color: Colors.green[800], fontSize: 12.sp,),
                        ),
                      ),

                      // TextButton(
                      //   onPressed: () {
                      //
                      //   },
                      //   child: Text(
                      //       'Quên mật khẩu ?',
                      //     style: TextStyle(
                      //       fontWeight: FontWeight.normal,
                      //       fontSize: 12.sp,
                      //       color: Colors.green[800],
                      //     ),
                      //   ),
                      // ),
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
