import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:smartfruit/model/DetectionHistoryModel.dart';
import 'package:smartfruit/api/api_service.dart';

class DetectionHistoryDetailScreen extends StatelessWidget {
  final int detectionHistoryId;

  const DetectionHistoryDetailScreen({Key? key, required this.detectionHistoryId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết nhận diện', style: TextStyle(color: Colors.white, fontSize: 18.sp, fontWeight: FontWeight.bold)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<DetectionHistoryDetailModel>(
        future: ApiService().getDetectionHistoryDetail(detectionHistoryId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            final detail = snapshot.data!;
            return DetectionHistoryDetailPage(detail: detail);
          }
        },
      ),
    );
  }
}

class DetectionHistoryDetailPage extends StatelessWidget {
  final DetectionHistoryDetailModel detail;

  DetectionHistoryDetailPage({required this.detail});

  @override
  Widget build(BuildContext context) {
    String formatDate(DateTime date) {
      return DateFormat('H:m:s dd/MM/yyyy').format(date);
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tên trái cây: '+detail.fruitName,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              Icon(Icons.store, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Text(detail.supermarketName, style: TextStyle(color: Colors.grey[700], fontSize: 12.sp)),

              SizedBox(width: 16.w),
              Icon(Icons.date_range, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.w),
              Text(formatDate(detail.createdAt), style: TextStyle(color: Colors.grey[700], fontSize: 12.sp)),
            ],
          ),
          SizedBox(height: 10.h),

          Image.network(
            detail.imagePath,
            width: double.infinity,
            height: 200.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 16.h),

          Text(
            'Độ tươi: ${detail.freshnessPercent.toStringAsFixed(1)}%',
            style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w500),
          ),
          SizedBox(height: 4.h),

          Text(
            'Trạng thái: ${detail.freshnessStatus}',
            style: TextStyle(
              fontSize: 14.sp,
              color: detail.freshnessStatus == "Fresh"
                  ? Colors.green
                  : detail.freshnessStatus == "Spoiled"
                  ? Colors.red
                  : Colors.orange,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
