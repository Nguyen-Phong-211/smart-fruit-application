# smartfruit

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.


# Smart Fruit Application (Mobile Version)

## Tổng quan

Đây là **ứng dụng mobile** cho dự án [@Nguyen-Phong-211/smart-fruit-website](https://github.com/Nguyen-Phong-211/smart-fruit-website). Ứng dụng được xây dựng bằng **Flutter** nhằm mang lại trải nghiệm tối ưu cho người dùng trên các thiết bị di động.

- **Repository chính của Website:** [smart-fruit-website](https://github.com/Nguyen-Phong-211/smart-fruit-website)
- **Repository ứng dụng mobile:** [smart-fruit-application](https://github.com/Nguyen-Phong-211/smart-fruit-application)

## Mô tả chức năng

Ứng dụng mobile này là một phần trong hệ sinh thái quản lý và nhận diện nông sản thông minh, được kết nối trực tiếp với hệ thống website. Các chức năng chính bao gồm:

- **Đăng nhập/Đăng ký:** Hỗ trợ xác thực người dùng với hệ thống backend dùng chung với website.
- **Quản lý tài khoản:** Cập nhật thông tin cá nhân, đổi mật khẩu, quản lý thông tin đăng nhập.
- **Quét trái cây bằng AI:** Sử dụng mô hình AI để nhận diện loại trái cây, đánh giá tình trạng tươi/hỏng, trả về phần trăm chất lượng.
- **Tích hợp Gemini 2.0:** Hỗ trợ người dùng giải đáp các thắc mắc liên quan đến trái cây thông qua nền tảng AI Gemini 2.0.
- **Xem bài viết:** Truy cập các bài viết, tin tức, kiến thức liên quan đến nông sản và trái cây thông minh.
- **Định vị GPS:** Tích hợp GPS để xác định vị trí người dùng, hỗ trợ các tính năng liên quan như tìm kiếm cửa hàng, địa điểm mua bán hoặc quản lý nguồn gốc sản phẩm.
- **Thông báo:** Nhận các thông báo mới nhất từ hệ thống (chương trình khuyến mãi, cập nhật sản phẩm, trạng thái tài khoản...).

> **Lưu ý:** Ứng dụng **không tích hợp chức năng thanh toán**.

## Công nghệ sử dụng

- **Flutter:** Framework chính xây dựng ứng dụng mobile, hỗ trợ cả Android và iOS.
- **Dart:** Ngôn ngữ lập trình của Flutter.
- **API Backend:** Kết nối tới server backend dùng chung với hệ thống website để đồng bộ dữ liệu người dùng, bài viết,...
- **AI Model:** Mô hình AI nhận diện loại trái cây và đánh giá chất lượng.
- **Gemini 2.0:** Nền tảng AI hỗ trợ hỏi đáp thông tin trái cây.
- **Các thư viện phụ trợ:** Provider, Dio, Firebase (tuỳ theo từng module),...

## Cấu trúc thư mục

```
smartfruit/
├── lib/               # Thư mục mã nguồn chính của ứng dụng Flutter
├── assets/            # Hình ảnh, tài nguyên tĩnh
├── android/           # Cấu hình cho nền tảng Android
├── ios/               # Cấu hình cho nền tảng iOS
├── pubspec.yaml       # Khai báo dependencies và tài nguyên
└── README.md          # Tài liệu mô tả dự án
```

## Cách cài đặt và chạy ứng dụng

> **Yêu cầu:** Đã cài đặt Flutter SDK, Android Studio hoặc Xcode.

1. **Clone repository:**
   ```bash
   git clone https://github.com/Nguyen-Phong-211/smart-fruit-application.git
   ```
2. **Cài đặt dependencies:**
   ```bash
   flutter pub get
   ```
3. **Chạy ứng dụng:**
   - Trên thiết bị Android/iOS hoặc giả lập:
     ```bash
     flutter run
     ```

## Đóng góp & phát triển

- Mọi đóng góp về tính năng, sửa lỗi hoặc ý tưởng mới đều được hoan nghênh.
- Vui lòng tạo [issue](https://github.com/Nguyen-Phong-211/smart-fruit-application/issues) hoặc [pull request](https://github.com/Nguyen-Phong-211/smart-fruit-application/pulls) để thảo luận thêm.

## License

Dự án tuân theo giấy phép mở (MIT License), tham khảo chi tiết trong file `LICENSE`.

---

**Ứng dụng mobile Smart Fruit là giải pháp giúp người dùng và nhà nông nhận diện, quản lý nông sản thông minh, thuận tiện và an toàn.**