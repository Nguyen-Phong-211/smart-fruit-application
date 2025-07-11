import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smartfruit/model/UserModel.dart';
import 'package:smartfruit/scan_fruit.dart';
import 'package:smartfruit/utils/shared_prefs_helper.dart';
import 'detection_history.dart';
import 'package:smartfruit/model/FruitModel.dart';
import 'package:smartfruit/model/BlogModel.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:smartfruit/blog_detail.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'support.dart';
import 'package:smartfruit/model/HomeModel.dart';
import 'user.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;

  late Future<List<FruitModel>> _fruits;
  late Future<List<BlogModel>> _blogs;

  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    _fruits = _apiService.getFruits();
    _blogs = _apiService.getBlogs();
  }

  final List<Widget> _screens = [
    HomePage(),
    // Center(child: Text('Quét', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp))),
    // Center(child: Text('Lịch sử', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp))),
    // Center(child: Text('Hỗ trợ', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp))),
    // Center(child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 10.sp))),
    ScanFruitScreen(),
    DetectionHistoryScreen(),
    SupportScreen(),
    ProfilePage()
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
        automaticallyImplyLeading: false,
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
              MaterialPageRoute(builder: (context) => DetectionHistoryScreen(initialIndex: 2)),
            );
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
          } else if (index == 4){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ProfilePage()),
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

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          FutureBuilder<UpdateProfileUserModel?>(
            future: SharedPrefsHelper.getUserProfile(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasData && snapshot.data != null) {
                return Text(
                  'Chào mừng, ${snapshot.data!.fullname}!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                );
              } else {
                return Text(
                  'Chào mừng đến với Smart Fruit!',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.green[800],
                  ),
                );
              }
            },
          ),

          SizedBox(height: 10.h),

          FutureBuilder<Map<String, int>>(
            future: ApiService().getDailyFruitStats(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Lỗi: ${snapshot.error}');
              } else {
                final data = snapshot.data!;
                final fresh = data['fresh'];
                final spoiled = data['spoiled'];

                return Column(
                  children: [
                    Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.r),
                      ),
                      color: Colors.green[100],
                      child: ListTile(
                        leading: Icon(Icons.info_outline, color: Colors.green[800]),
                        title: Text(
                          'Thông tin hôm nay',
                          style: TextStyle(fontSize: 14.sp),
                        ),
                        subtitle: Text(
                          'Bạn đã quét ${fresh} trái cây tươi hôm nay.',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.r)),
                      color: Colors.red[50],
                      child: ListTile(
                        leading: Icon(Icons.warning_amber_rounded, color: Colors.red),
                        title: Text('Cảnh báo', style: TextStyle(fontSize: 14.sp),),
                        subtitle: Text(
                          '${spoiled} trái cây bạn đã quét có dấu hiệu hỏng.',
                          style: TextStyle(fontSize: 12.sp),
                        ),
                        // trailing: Icon(Icons.arrow_forward_ios, size: 16.sp),
                      ),
                    ),
                  ],
                );
              }
            },
          ),

          SizedBox(height: 10.h),
          // Gợi ý trái cây
          Text(
            'Nhận diện các loại trái cây',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green[800],),
          ),
          SizedBox(height: 10.h),

          // Danh sách trái cây (ListView horizontal)
          Container(
            height: 150.h, // Giảm chiều cao của Container nếu cần
            child: FutureBuilder<List<FruitModel>>(
              future: ApiService().getFruits(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Lỗi khi tải trái cây'));
                } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                  return Center(child: Text('Không có trái cây để hiển thị'));
                } else {
                  final fruits = snapshot.data!;
                  return ListView(
                    scrollDirection: Axis.horizontal,
                    children: fruits.map((fruit) {
                      return suggestionCard(fruit.fruitName, fruit.fruitImageUrl);
                    }).toList(),
                  );
                }
              },
            ),
          ),

          SizedBox(height: 10.h),

          Text(
            'Bài viết về trái cây hôm nay',
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green[800],),
          ),

          SizedBox(height: 10.h),

        Container(
          height: 240.h,
          child: FutureBuilder<List<BlogModel>>(
            future: ApiService().getBlogs(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Lỗi khi tải bài viết'));
                // return Center(child: Text('Lỗi: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('Không có bài viết để hiển thị'));
              } else {
                final blogs = snapshot.data!;
                return ListView(
                  scrollDirection: Axis.horizontal,
                  children: blogs.map((blog) {
                    return articleCard(
                      blog.blogId,
                      blog.blogTitle,
                      blog.blogCreate,
                      blog.blogImage,
                      [
                        FontAwesomeIcons.blog,
                      ], context
                    );
                  }).toList(),
                );
              }
            },
          ),
        ),

        SizedBox(height: 15.0.h),

          Card(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            color: Colors.green[50],
            child: ListTile(
              leading: Icon(FontAwesomeIcons.temperatureLow, color: Colors.green[800], size: 14.sp),
              title: Text('Chẩn đoán độ tươi', style: TextStyle(fontSize: 14.sp)),
              subtitle: Text('Trái cây hôm nay đạt 85% độ tươi', style: TextStyle(fontSize: 12.sp)),
              trailing: Icon(Icons.check_circle, color: Colors.green, size: 14.sp,),
            ),
          ),

          SizedBox(height: 10.h),

          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Mẹo chọn trái cây tươi', style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green[800])),
              SizedBox(height: 10),
              ...[
                'Kiểm tra màu sắc vỏ ngoài',
                'Tránh chọn trái có đốm nâu lớn',
                'Mùi thơm nhẹ thường là trái chín tự nhiên',
              ].map((tip) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.orangeAccent, size: 18.sp),
                    SizedBox(width: 6.w),
                    Expanded(child: Text(tip)),
                  ],
                ),
              )),
            ],
          ),
        ],
      ),
    );
  }

  Widget suggestionCard(String title, String imageUrl) {
    return Container(
      width: 150.w,
      margin: EdgeInsets.only(right: 16.w),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.r),
        ),
        elevation: 6,
        shadowColor: Colors.black.withOpacity(0.2),
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hình ảnh
            ClipRRect(
              borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
              child: Container(
                height: 100.h,
                color: Colors.green[50],
                child: Center(
                  child: Image.network(
                    imageUrl,
                    height: 50.h,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(10),
              child: Text(
                title,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.green[800],
                  fontSize: 12.sp,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget articleCard(int blogId, String blogTitle, DateTime blogCreate, String blogImage, List<IconData> suggestionIcons, BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute(
            builder: (context) => BlogDetailScreen(blogId: blogId),
          ),
        );
      },
      child: Container(
        width: 180.w,
        height: 150.h,
        margin: EdgeInsets.only(right: 16.w),
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.r),
          ),
          elevation: 6,
          shadowColor: Colors.black.withOpacity(0.2),
          color: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hình nhỏ lại, không bóp méo
              ClipRRect(
                borderRadius: BorderRadius.vertical(top: Radius.circular(20.r)),
                child: Container(
                  height: 100.h,
                  width: double.infinity,
                  color: Colors.green[50],
                  child: Center(
                    child: Image.network(
                      blogImage,
                      height: 50.h,
                      fit: BoxFit.contain,
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      blogTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14.sp,
                        color: Colors.green[800],
                      ),
                    ),
                    SizedBox(height: 10.h),

                    // Hàng icon gợi ý trái cây
                    Row(
                      children: suggestionIcons.map((iconData) {
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: FaIcon(
                            iconData,
                            size: 14.sp,
                            color: Colors.orange[700],
                          ),
                        );
                      }).toList(),
                    ),

                    SizedBox(height: 10.h),

                    // Xem chi tiết
                    Row(
                      children: [
                        FaIcon(FontAwesomeIcons.calendarDay, size: 14, color: Colors.green[700]),
                        SizedBox(width: 10.h),
                        Expanded(
                          child: Text(
                            DateFormat('dd/MM/yyyy').format(blogCreate),
                            style: TextStyle(fontSize: 10.sp, color: Colors.grey[600]),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        SizedBox(width: 3.h),
                        Flexible(
                          child: Text(
                            'Xem chi tiết',
                            style: TextStyle(
                              fontSize: 12.sp,
                              color: Colors.green[700],
                              fontWeight: FontWeight.w500,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
