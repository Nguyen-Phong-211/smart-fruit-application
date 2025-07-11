import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:smartfruit/detection_history.dart';
import 'package:smartfruit/scan_fruit.dart';
import 'home.dart';

class SupportScreen extends StatefulWidget {
  final int initialIndex;
  SupportScreen({this.initialIndex = 3});

  @override
  _SupportScreenState createState() => _SupportScreenState();
}

class _SupportScreenState extends State<SupportScreen> with TickerProviderStateMixin {
  int _selectedIndex = 3;

  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  Future<void> sendMessage(String message) async {
    setState(() {
      _loading = true;
      _messages.add({'role': 'user', 'content': message});
    });

    final apiService = ApiService();
    final answer = await apiService.getAnswer(message);

    setState(() {
      _messages.add({'role': 'bot', 'content': answer});
      _loading = false;
    });
  }

  final List<Widget> _screens = [
    HomePage(),
    // Center(child: Text('Quét', style: TextStyle(fontWeight: FontWeight.bold))),
    ScanFruitScreen(),
    DetectionHistoryPage(),
    _buildChatPage(),
    Center(child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold))),
  ];

  final List<String> _titles = [
    'Trang chủ',
    'Quét',
    'Lịch sử',
    'Chat cùng Gemini',
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

  static Widget _buildChatPage() {
    return _ChatPage();
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
        transitionBuilder: (child, animation, secondaryAnimation) => SharedAxisTransition(
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
          } else if (index == 3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => SupportScreen()),
            );
          } else if (index == 1){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ScanFruitScreen()),
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

// Tách thành widget riêng cho phần chat
class _ChatPage extends StatefulWidget {
  @override
  __ChatPageState createState() => __ChatPageState();
}

class __ChatPageState extends State<_ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _loading = false;

  Future<void> sendMessage(String message) async {
    setState(() {
      _loading = true;
      _messages.add({'role': 'user', 'content': message});
    });

    final apiService = ApiService();
    final answer = await apiService.getAnswer(message);

    setState(() {
      _messages.add({'role': 'bot', 'content': answer});
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            padding: EdgeInsets.all(12),
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              final msg = _messages[index];
              return ListTile(
                title: Align(
                  alignment:
                  msg['role'] == 'user' ? Alignment.centerRight : Alignment.centerLeft,
                  child: Container(
                    padding: EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: msg['role'] == 'user' ? Colors.green : Colors.green[50],
                      borderRadius: BorderRadius.circular(8.r),
                    ),
                    child: Text(
                      msg['content'] ?? '',
                      style: TextStyle(
                        color: msg['role'] == 'user' ? Colors.white : Colors.black87,
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
        if (_loading) LinearProgressIndicator(),
        Padding(
          padding: EdgeInsets.all(8),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(hintText: 'Nhập câu hỏi...'),
                ),
              ),
              IconButton(
                icon: FaIcon(FontAwesomeIcons.paperPlane, color: Colors.green[700]),
                onPressed: () {
                  if (_controller.text.trim().isNotEmpty) {
                    sendMessage(_controller.text.trim());
                    _controller.clear();
                  }
                },
              )
            ],
          ),
        )
      ],
    );
  }
}
