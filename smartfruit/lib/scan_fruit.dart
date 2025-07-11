import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:smartfruit/model/ScanFruitModel.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:animations/animations.dart';
import 'package:smartfruit/home.dart';
import 'package:smartfruit/detection_history.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/support.dart';
import 'utils/shared_prefs_helper.dart';
import 'package:geolocator/geolocator.dart';

class ScanFruitScreen extends StatefulWidget {
  final int initialIndex;
  ScanFruitScreen({this.initialIndex = 1});

  @override
  _ScanFruitScreenState createState() => _ScanFruitScreenState();
}

class _ScanFruitScreenState extends State<ScanFruitScreen> with TickerProviderStateMixin {
  int _selectedIndex = 1;
  CameraController? _cameraController;
  bool _isCameraInitialized = false;
  ScanFruitResult? _result;
  bool _isScanning = false;
  String? base64Image;

  final List<String> _titles = [
    'Trang chủ',
    'Quét trái cây',
    'Lịch sử',
    'Hỗ trợ',
    'Tài khoản',
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkCameraPermissionAndInit();
    });
  }

  Future<void> _checkCameraPermissionAndInit() async {
    var status = await Permission.camera.status;

    if (!status.isGranted) {
      status = await Permission.camera.request();
    }

    if (status.isGranted) {
      await _initializeCamera();
    } else {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Không có quyền truy cập camera.")),
        );
      }
      setState(() => _isCameraInitialized = false);
    }
  }

  Future<void> _initializeCamera() async {
    try {
      final cameras = await availableCameras();
      final backCamera = cameras.firstWhere(
            (camera) => camera.lensDirection == CameraLensDirection.back,
      );

      _cameraController = CameraController(
        backCamera,
        ResolutionPreset.medium,
        enableAudio: false,
      );

      await _cameraController!.initialize();
      setState(() => _isCameraInitialized = true);
    } catch (e) {
      print("Lỗi khởi tạo camera: $e");
    }
  }

  Future<Position?> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Vui lòng bật dịch vụ định vị GPS')),
        );
      }
      return null;
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Quyền định vị bị từ chối')),
          );
        }
        return null;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Quyền định vị bị từ chối vĩnh viễn')),
        );
      }
      return null;
    }

    return await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
  }

  Future<void> _captureAndScan() async {
    if (!_isCameraInitialized || _cameraController == null || !_cameraController!.value.isInitialized) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Camera chưa sẵn sàng.")),
      );
      return;
    }

    setState(() => _isScanning = true);

    try {
      final XFile file = await _cameraController!.takePicture();

      if (file.path.isEmpty) {
        throw Exception("Không thể chụp ảnh.");
      }

      final bytes = await File(file.path).readAsBytes();
      if (bytes.isEmpty) {
        throw Exception("Ảnh bị lỗi hoặc rỗng.");
      }

      final base64Image = base64Encode(bytes);
      this.base64Image = base64Image;

      final result = await ApiService().scanFruit(base64Image);

      setState(() => _result = result);

      // Đợi 3 giây rồi hiện modal
      Future.delayed(Duration(seconds: 2), () {
        if (mounted && _result != null) {
          showDialog(
            context: context,
            builder: (_) => AlertDialog(
              title: Text('Chi tiết kết quả'),
              content: Text('Tên trái cây: ${_result!.fruitName}\n'
                  'Độ tươi: ${_result!.freshnessPercent.toStringAsFixed(1)}%\n'
                  'Trạng thái: ${_result!.freshnessStatus}'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Đóng'),
                ),
                TextButton(
                  onPressed: () async {
                    Navigator.of(context).pop();

                    if (_result == null || base64Image == null || base64Image!.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không có dữ liệu để lưu')),
                      );
                      return;
                    }

                    // double latitude = 10.8237418;
                    // double longitude = 106.6816708;
                    final int? userId = await SharedPrefsHelper.getUserId();

                    if (userId == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Bạn chưa đăng nhập')),
                      );
                      return;
                    }

                    final Position? position = await _determinePosition();
                    print('Vị trí của bạn: ${position}');

                    if (position == null) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Không lấy được vị trí GPS')),
                      );
                      return;
                    }

                    final saveRequest = ScanSaveRequest(
                      image: 'data:image/jpeg;base64,${base64Image}',
                      fruit: _result!.fruitName,
                      freshnessPercent: _result!.freshnessPercent,
                      freshnessStatus: _result!.freshnessStatus,
                      latitude: position.latitude,
                      longitude: position.longitude,
                      userId: userId,
                    );

                    final isSaved = await ApiService().saveScanResult(saveRequest);

                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(isSaved
                              ? 'Lưu kết quả thành công'
                              : 'Lưu kết quả thất bại'),
                        ),
                      );
                    }
                  },
                  child: Text('Lưu'),
                ),
              ],

            ),
          );
        }
      });

    } catch (e) {
      print("Lỗi quét ảnh: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Lỗi khi quét: $e")),
      );
    } finally {
      setState(() => _isScanning = false);
    }
  }

  Widget _buildScanContent() {
    return SingleChildScrollView(
      child: Column(
        children: [
          if (_isCameraInitialized)
            SizedBox(
              height: 400.h,
              width: double.infinity.w,
              child: CameraPreview(_cameraController!),
            )
          else
            Padding(
              padding: EdgeInsets.symmetric(vertical: 60),
              child: CircularProgressIndicator(),
            ),

          SizedBox(height: 16.h),

          ElevatedButton.icon(
            onPressed: _isScanning ? null : _captureAndScan,
            icon: Icon(Icons.camera, color: Colors.white,),
            label: _isScanning
                ? Text("Đang quét...", style: TextStyle(color: Colors.white))
                : Text("Quét", style: TextStyle(color: Colors.white)),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: EdgeInsets.symmetric(horizontal: 24.h, vertical: 12.w),
            ),
          ),

          if (_result != null)
            Padding(
              padding: EdgeInsets.all(16.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          'Tên trái cây: ${_result!.fruitName}',
                          style: TextStyle(fontSize: 14.sp,),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Icon(
                        Icons.info,
                        color: _result!.freshnessStatus == "Fresh"
                            ? Colors.green
                            : _result!.freshnessStatus == "Spoiled"
                            ? Colors.red
                            : Colors.orange,
                        size: 20.sp,
                      ),
                      SizedBox(width: 8.w),
                      Text(
                        'Trạng thái: ${_result!.freshnessStatus}',
                        style: TextStyle(
                          color: _result!.freshnessStatus == "Fresh"
                              ? Colors.green
                              : _result!.freshnessStatus == "Spoiled"
                              ? Colors.red
                              : Colors.orange,
                          fontWeight: FontWeight.bold,
                          fontSize: 14.sp,
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8.h),
                  Row(
                    children: [
                      Text(
                        'Độ tươi: ${_result!.freshnessPercent.toStringAsFixed(1)}%',
                        style: TextStyle(fontSize: 14.sp),
                      ),
                    ],
                  ),
                  // SizedBox(height: 8.h),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget buildNavIcon(IconData icon, bool isSelected) {
    return AnimatedScale(
      scale: isSelected ? 1.3 : 1.0,
      duration: Duration(milliseconds: 300),
      curve: Curves.easeOutBack,
      child: FaIcon(icon, size: 14.sp),
    );
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> _screens = [
      HomePage(),
      _buildScanContent(),
      DetectionHistoryPage(),
      Center(child: Text('Hỗ trợ', style: TextStyle(fontWeight: FontWeight.bold))),
      Center(child: Text('Tài khoản', style: TextStyle(fontWeight: FontWeight.bold))),
    ];

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
          if (index == 1) {
            return;
          } else if (index == 0) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => HomeScreen(),
              ),
            );
          } else if (index == 2) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => DetectionHistoryScreen(initialIndex: 2),
              ),
            );
          } else if (index == 3) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (_) => SupportScreen(),
              ),
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
