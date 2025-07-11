import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:smartfruit/scan_fruit.dart';
import 'package:smartfruit/support.dart';
import 'home.dart';
import 'package:smartfruit/model/DetectionHistoryModel.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/detection_history_detail.dart';

class DetectionHistoryScreen extends StatefulWidget {
  final int initialIndex;
  DetectionHistoryScreen({this.initialIndex = 0});

  @override
  _DetectionHistoryScreenState createState() => _DetectionHistoryScreenState();
}


class _DetectionHistoryScreenState extends State<DetectionHistoryScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  final List<Widget> _screens = [
    HomePage(),
    // Center(child: Text('Quét', style: TextStyle(fontWeight: FontWeight.bold))),
    ScanFruitScreen(),
    DetectionHistoryPage(),
    // Center(child: Text('Hỗ trợ', style: TextStyle(fontWeight: FontWeight.bold))),
    SupportScreen(),
    Center(child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold))),
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
      child: FaIcon(icon, size: 14.sp,),
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
      body:

      PageTransitionSwitcher(
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
            if (_selectedIndex != 2) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => DetectionHistoryScreen(initialIndex: 2)),
              );
            }
          } else if (index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanFruitScreen()),
            );
          } else if (index == 3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportScreen()),
            );
          } else {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop();
            } else {
              setState(() {
                _selectedIndex = index;
              });
            }
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
            icon: buildNavIcon(FontAwesomeIcons.clockRotateLeft, _selectedIndex == 2),
            label: 'Lịch sử',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(FontAwesomeIcons.headset, _selectedIndex == 3),
            label: 'Hỗ trợ',
          ),
          BottomNavigationBarItem(
            icon: buildNavIcon(FontAwesomeIcons.circleUser, _selectedIndex == 4),
            label: 'Tài khoản',
          ),
        ],
      ),
    );
  }
}

class DetectionHistoryPage extends StatelessWidget {
  final ApiService _apiService = ApiService();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<DetectionHistoryModel>>(
      future: _apiService.getDetectionHistoryList(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          // return Center(child: Text("Lỗi: ${snapshot.error}"));
          return Center(child: Text("Chưa có dữ liệu"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text("Không có dữ liệu nhận diện."));
        }

        final histories = snapshot.data!;

        return ListView.builder(
          padding: EdgeInsets.all(16.w),
          itemCount: histories.length,
          itemBuilder: (context, index) {
            final item = histories[index];
            return
              Card(
                color: Colors.white,
                margin: EdgeInsets.only(bottom: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16.r),
              ),

              elevation: 6,
              shadowColor: Colors.black.withOpacity(0.2),

              child: ListTile(
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(50.r),
                  child: Container(
                    color: Colors.green[100],
                    width: 60.w,
                    height: 50.h,
                    child: Image.network(
                      item.imagePath,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),

                title: Text(
                  item.fruitName,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.green[800],
                  ),
                ),

                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.calendarAlt, size: 12, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text('Ngày quét: ${item.createdAt.day}/${item.createdAt.month}/${item.createdAt.year}',
                            style: TextStyle(fontSize: 13, color: Colors.grey[800])
                        ),
                      ],
                    ),
                    SizedBox(height: 4),
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.gaugeHigh, size: 12, color: Colors.grey[600]),
                        SizedBox(width: 6),
                        Text('Độ tươi: ${item.freshnessPercent}%',
                            style: TextStyle(fontSize: 13, color: Colors.grey[800])),
                      ],
                    ),
                  ],
                ),
                trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => DetectionHistoryDetailScreen(detectionHistoryId: item.detectionHistoryId),
                    ),
                  );
                },
              ),
            );
          },
        );
      },
    );
  }
}
