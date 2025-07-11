import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/api/api_service.dart';
import 'change_password.dart';

class VerifyOtpScreen extends StatefulWidget {
  final String email;

  const VerifyOtpScreen({super.key, required this.email});

  @override
  State<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends State<VerifyOtpScreen> {
  List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());
  List<TextEditingController> _controllers = List.generate(6, (_) => TextEditingController());
  bool _isVerifying = false;

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _verifyOtp() async {
    String otpCode = _controllers.map((c) => c.text).join();
    if (otpCode.length != 6) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Vui lòng nhập đủ 6 số OTP')));
      return;
    }

    setState(() => _isVerifying = true);

    try {
      final result = await ApiService().verifyOtp(widget.email, otpCode);
      setState(() => _isVerifying = false);

      if (result == true) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ChangePasswordScreen(email: widget.email, otp: otpCode),
          ),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Mã OTP không đúng')));
      }
    } catch (e) {
      setState(() => _isVerifying = false);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Lỗi: ${e.toString()}')));
    }
  }

  Widget _buildOtpField(int index) {
    return SizedBox(
      width: 50.w,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        keyboardType: TextInputType.number,
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 20.sp, fontWeight: FontWeight.bold),
        maxLength: 1,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        decoration: InputDecoration(
          counterText: '',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10.r)),
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 5) {
            _focusNodes[index + 1].requestFocus();
          }
          if (value.isEmpty && index > 0) {
            _focusNodes[index - 1].requestFocus();
          }
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Xác minh OTP', style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          children: [
            SizedBox(height: 30.h),
            Text(
              'Nhập mã OTP gồm 6 chữ số đã gửi tới email: ${widget.email}',
              style: TextStyle(fontSize: 14.sp),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 30.h),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(6, _buildOtpField),
            ),
            SizedBox(height: 40.h),
            ElevatedButton(
              onPressed: _isVerifying ? null : _verifyOtp,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green[600],
                padding: EdgeInsets.symmetric(vertical: 14.h, horizontal: 50.w),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12.r),
                ),
              ),
              child: _isVerifying
                  ? CircularProgressIndicator(color: Colors.white)
                  : Text(
                'Xác nhận',
                style: TextStyle(fontSize: 14.sp, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
