import 'package:flutter/material.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:smartfruit/model/BlogModel.dart';
import 'package:smartfruit/api/api_service.dart';
import 'package:intl/intl.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class BlogDetailScreen extends StatelessWidget {
  final int blogId;

  const BlogDetailScreen({Key? key, required this.blogId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Chi tiết bài viết', style: TextStyle(color: Colors.white, fontSize: 18.sp)),
        iconTheme: IconThemeData(color: Colors.white),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<BlogDetailModel>(
        future: ApiService().getBlogDetail(blogId),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Lỗi: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data == null) {
            return Center(child: Text('Không có dữ liệu'));
          } else {
            final blog = snapshot.data!;
            return BlogDetailPage(blog: blog);
          }
        },
      ),
    );
  }
}

class BlogDetailPage extends StatelessWidget {
  final BlogDetailModel blog;

  BlogDetailPage({required this.blog});

  @override
  Widget build(BuildContext context) {
    String formatDate(String rawDate) {
      try {
        final date = DateTime.parse(rawDate);
        return DateFormat('dd/MM/yyyy').format(date);
      } catch (_) {
        return rawDate;
      }
    }

    return SingleChildScrollView(
      padding: EdgeInsets.all(16.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            blog.title,
            style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold, color: Colors.green[800]),
          ),
          SizedBox(height: 10.h),

          Row(
            children: [
              Icon(Icons.remove_red_eye, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.h),
              Text('${blog.view ?? 0}', style: TextStyle(color: Colors.grey[700], fontSize: 12.sp)),

              SizedBox(width: 16),
              Icon(Icons.date_range, size: 14.sp, color: Colors.grey),
              SizedBox(width: 4.h),
              Text(DateFormat('dd/MM/yyyy').format(blog.createdAt), style: TextStyle(color: Colors.grey[700], fontSize: 12.sp,)),

              SizedBox(width: 10.h),
              Icon(
                Icons.circle,
                size: 12.sp,
                color: blog.status == 'published' ? Colors.green : Colors.orange,
              ),
              SizedBox(width: 4.h),
              blog.status == 'published'
                  ? Text('Đã xuất bản', style: TextStyle(color: Colors.grey[700], fontSize: 12.sp))
                  : SizedBox.shrink(),
            ],
          ),
          SizedBox(height: 10.h),

          Image.network(
            blog.imageUrl,
            width: double.infinity.w,
            height: 250.h,
            fit: BoxFit.contain,
          ),
          SizedBox(height: 10.h),

          Html(
            data: blog.content,
            style: {
              "body": Style(
                fontSize: FontSize(14.sp),
                color: Colors.black,
              ),
            },
          ),
        ],
      ),
    );
  }
}
