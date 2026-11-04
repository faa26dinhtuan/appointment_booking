# Báo cáo thực tập Flutter và Firebase

**Đề tài** — Appointment Booking  
**Thời gian thực hiện** — 1 tuần  
**Mã nguồn** — [GitHub · nhánh sub_branch](https://github.com/faa26dinhtuan/appointment_booking/tree/sub_branch)

## 1. Mục tiêu dự án

Xây dựng ứng dụng đặt và quản lý lịch hẹn cá nhân bằng Flutter, với giao diện theo phong cách iOS. Người dùng có thể quản lý lịch của mình, tìm theo tiêu đề và xem lịch theo ngày. Điện thoại Android và Chrome web là hai môi trường dùng để kiểm thử trong quá trình phát triển.

## 2. Kiến thức Firebase

- **Firebase** là nền tảng của Google cung cấp dịch vụ xác thực, cơ sở dữ liệu, lưu tệp, thông báo và triển khai web. Dự án dùng Firebase Authentication và Cloud Firestore. [Tổng quan Firebase](https://firebase.google.com/docs)
- **Firebase Authentication** xác thực tài khoản bằng email và mật khẩu. Mỗi tài khoản có UID riêng. Ứng dụng lắng nghe trạng thái xác thực để mở màn hình phù hợp khi đăng nhập, đăng xuất hoặc mở lại app. Firebase cũng gửi email đặt lại mật khẩu. [Firebase Authentication cho Flutter](https://firebase.google.com/docs/auth/flutter/password-auth)
- **Cloud Firestore** tổ chức dữ liệu NoSQL thành collection và document. SDK Flutter có thể truy vấn dữ liệu và lắng nghe thay đổi theo thời gian thực. App lưu lịch tại `users/{uid}/appointments/{appointmentId}` và sắp xếp theo thời điểm hẹn. [Hướng dẫn Firestore](https://firebase.google.com/docs/firestore/quickstart)
- **Realtime Database** lưu dữ liệu theo cây JSON và đồng bộ khi các nút thay đổi. Cả hai cơ sở dữ liệu hỗ trợ cập nhật theo thời gian thực. Firestore phù hợp với bài này vì mỗi lịch là một document độc lập và danh sách có thể truy vấn theo thời gian. [So sánh hai cơ sở dữ liệu](https://firebase.google.com/docs/firestore/rtdb-vs-firestore)
- **Kết nối Flutter** gồm tạo Firebase Project, chạy `flutterfire configure` để đăng ký app và sinh `lib/firebase_options.dart`, rồi gọi `Firebase.initializeApp` khi mở ứng dụng. Email/Password được bật trong Authentication. Quy tắc Firestore được publish từ nội dung `firestore.rules`. [Thiết lập Firebase cho Flutter](https://firebase.google.com/docs/flutter/setup)

## 3. Triển khai ứng dụng

- **Tài khoản** — đăng ký, đăng nhập, đăng xuất, duy trì phiên và khôi phục mật khẩu qua email.
- **Lịch hẹn** — tạo, xem chi tiết, sửa và xóa có xác nhận. Mỗi lịch có tiêu đề, nội dung, ngày giờ, địa điểm và trạng thái. Danh sách tự cập nhật khi Firestore thay đổi.
- **Tìm và lọc** — tìm theo tiêu đề, lọc theo trạng thái Sắp diễn ra, Đã hoàn thành hoặc Đã hủy. Tab Lịch hiển thị lịch và tổng số lịch của ngày đã chọn.
- **Kiểm tra đầu vào** — yêu cầu tiêu đề và ngày giờ, dùng bộ chọn ngày giờ dạng bánh xe, chặn tạo lịch trong quá khứ và cảnh báo lịch cùng giờ đến phút. Người dùng có thể đổi giờ hoặc xác nhận vẫn lưu.
- **Phân quyền và mất mạng** — Firestore Rules đối chiếu UID xác thực với UID trên đường dẫn để bảo vệ dữ liệu từng tài khoản. App báo khi danh sách lấy từ bộ nhớ đệm hoặc đang chờ dữ liệu từ máy chủ. [Dữ liệu ngoại tuyến trong Firestore](https://firebase.google.com/docs/firestore/manage-data/enable-offline)
- **Cấu trúc mã nguồn** — các màn hình chia theo `features/auth` và `features/appointments`. Repository thực hiện thao tác Firebase, Riverpod cung cấp trạng thái cho giao diện. Theme và chuỗi tiếng Việt nằm trong `core/theme` và `l10n`.

## 4. Khó khăn và cách giải quyết

1. **CLI chỉ hiện Firebase Project cũ.** Project cho bài tập chưa được tạo. Sau khi tạo project mới, dùng đúng Project ID khi chạy FlutterFire để đăng ký ứng dụng.
2. **Firestore từ chối lưu lịch.** Database ban đầu chạy Production mode và bộ Rules của ứng dụng chưa được publish. Sau khi publish Rules kiểm tra UID, ứng dụng đã tạo được lịch.
3. **Lịch cũ thiếu trường trạng thái.** Khi đọc dữ liệu, app mặc định lịch chưa có trạng thái là Sắp diễn ra. Lịch mới lưu trạng thái ngay từ lúc tạo.
4. **Danh sách rỗng khi chưa tải được dữ liệu.** App đọc thông tin nguồn của bản cập nhật Firestore để phân biệt dữ liệu bộ nhớ đệm với danh sách đã được máy chủ xác nhận.

## 5. Ảnh minh họa và kiểm thử trước khi nộp

- [ ] Thêm ảnh Đăng nhập, Đăng ký và Quên mật khẩu.
- [ ] Thêm ảnh danh sách, bộ lọc, tab Lịch theo ngày và màn Chi tiết.
- [ ] Thêm ảnh form thêm/sửa, hộp thoại trùng giờ và xác nhận xóa.
- [ ] Ghi kết quả thực tế theo nền tảng Android hoặc Chrome. Kiểm tra lại với hai tài khoản để xác nhận lịch được tách riêng, thử cảnh báo trùng giờ và ngắt/kết nối lại mạng.
- [ ] Xác nhận link mã nguồn mở được bằng tài khoản của người chấm.
