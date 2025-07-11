// custom_bottom_nav.dart
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class CustomBottomNav extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTabSelected;

  const CustomBottomNav({
    Key? key,
    required this.currentIndex,
    required this.onTabSelected,
  }) : super(key: key);

  Widget buildNavIcon(IconData icon, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.3 : 1.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: FaIcon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTabSelected,
      selectedItemColor: Colors.green[700],
      unselectedItemColor: Colors.grey[600],
      type: BottomNavigationBarType.fixed,
      backgroundColor: Colors.white,
      items: [
        BottomNavigationBarItem(
          icon: buildNavIcon(FontAwesomeIcons.house, currentIndex == 0),
          label: 'Trang chủ',
        ),
        BottomNavigationBarItem(
          icon: buildNavIcon(FontAwesomeIcons.qrcode, currentIndex == 1),
          label: 'Quét trái cây',
        ),
        BottomNavigationBarItem(
          icon: buildNavIcon(FontAwesomeIcons.clockRotateLeft, currentIndex == 2),
          label: 'Lịch sử',
        ),
        BottomNavigationBarItem(
          icon: buildNavIcon(FontAwesomeIcons.headset, currentIndex == 3),
          label: 'Hỗ trợ',
        ),
        BottomNavigationBarItem(
          icon: buildNavIcon(FontAwesomeIcons.circleUser, currentIndex == 4),
          label: 'Tài khoản',
        ),
      ],
    );
  }
}
