import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfruit/scan_fruit.dart';
import 'package:smartfruit/support.dart';
import 'package:smartfruit/home.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:smartfruit/model/DetectionHistoryModel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/detection_history_detail.dart';
import 'package:smartfruit/detection_history.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'package:smartfruit/update_profile_user.dart';
import 'utils/shared_prefs_helper.dart';
import 'confirm_email.dart';
import 'login.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  int _selectedIndex = 4;

  final List<Widget> _screens = [
    HomePage(),
    ScanFruitScreen(),
    DetectionHistoryPage(),
    SupportScreen(),
    const ProfileContentPage(),
  ];

  final List<String> _titles = [
    'Trang chủ',
    'Quét',
    'Lịch sử',
    'Hỗ trợ',
    'Tài khoản',
  ];

  Widget buildNavIcon(IconData icon, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.3 : 1.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: FaIcon(icon, size: 14.sp),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: AnimatedDefaultTextStyle(
          duration: Duration(milliseconds: 300),
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 18.sp,
            fontFamily: 'MontserratMedium',
          ),
          child: Text(_titles[_selectedIndex]),
        ),
        backgroundColor: Colors.green,
        elevation: 4,
      ),
      body: PageTransitionSwitcher(
        duration: Duration(milliseconds: 500),
        transitionBuilder: (child, animation, secondaryAnimation) =>
            SharedAxisTransition(
              animation: animation,
              secondaryAnimation: secondaryAnimation,
              transitionType: SharedAxisTransitionType.horizontal,
              child: child,
            ),
        child: _screens[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (_) => DetectionHistoryScreen(initialIndex: 2)),
            );
          } else if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanFruitScreen()),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportScreen()),
            );
          } else {
            setState(() {
              _selectedIndex = index;
            });
          }
        },
        selectedFontSize: 12.sp,
        unselectedFontSize: 12.sp,
        selectedItemColor: Colors.green[700],
        unselectedItemColor: Colors.grey[600],
        type: BottomNavigationBarType.fixed,
        backgroundColor: Colors.white,
        items: [
          BottomNavigationBarItem(
            icon: buildNavIcon(FontAwesomeIcons.house, _selectedIndex == 0),
            label: 'Trang chủ',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(FontAwesomeIcons.qrcode, _selectedIndex == 1),
            label: 'Quét',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(
                FontAwesomeIcons.clockRotateLeft, _selectedIndex == 2),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(FontAwesomeIcons.headset, _selectedIndex == 3),
            label: 'Hỗ trợ',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(
                FontAwesomeIcons.circleUser, _selectedIndex == 4),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class ProfileContentPage extends StatelessWidget {
  const ProfileContentPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.all(16.w),
      children: [
        ListTile(
          leading: FaIcon(FontAwesomeIcons.user, color: Colors.green[800]),
          title: Text('Cập nhật thông tin', style: TextStyle(color: Colors.green[800]),),
          onTap: () async {
            final userProfile = await SharedPrefsHelper.getUserProfile();
            if (userProfile != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UpdateProfileUserScreen(user: userProfile),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Không tìm thấy thông tin người dùng")),
              );
            }
          },
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.unlock, color: Colors.green[800]),
          title: Text('Đổi mật khẩu', style: TextStyle(color: Colors.green[800])),
          onTap: () async {
            final userProfile = await SharedPrefsHelper.getUserProfile();
            if(userProfile != null) {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ConfirmEmailScreen(userEmail: userProfile.email),
                ),
              );
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Không tìm thấy thông tin người dùng")),
              );
            }
          },
        ),
        Divider(),
        ListTile(
          leading: FaIcon(FontAwesomeIcons.arrowRightFromBracket, color: Colors.green[800]),
          title: Text('Đăng xuất', style: TextStyle(color: Colors.green[800])),
          onTap: () {
            showDialog(
              context: context,
              builder: (context) => AlertDialog(
                title: Text('Xác nhận đăng xuất'),
                content: Text('Bạn có chắc chắn muốn đăng xuất?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: Text('Hủy'),
                  ),
                  TextButton(
                    onPressed: () async {
                      Navigator.pop(context);

                      final prefs = await SharedPreferences.getInstance();
                      await prefs.clear();

                      Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (context) => LoginPage()),
                            (route) => false,
                      );
                    },
                    child: Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                  ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }
}
