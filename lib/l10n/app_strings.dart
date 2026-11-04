import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

abstract final class AppStrings {
  static const locale = Locale('vi');
  static const appName = 'Lịch hẹn';
  static const calendar = 'Lịch';
  static const emptyTitle = 'Chưa có lịch hẹn';
  static const emptyDescription = 'Thêm lịch hẹn để bắt đầu sắp xếp thời gian.';
  static const emptyDay = 'Không có lịch hẹn trong ngày này.';
  static const chooseDate = 'Chọn ngày';
  static const chooseTime = 'Chọn giờ';
  static const addAppointment = 'Thêm lịch hẹn';
  static const title = 'Tiêu đề';
  static const notes = 'Nội dung';
  static const location = 'Địa điểm';
  static const date = 'Ngày';
  static const time = 'Giờ';
  static const formPreview =
      'Bạn có thể nhập thông tin và chọn ngày giờ ở bản này.';

  static const login = 'Đăng nhập';
  static const loginSubtitle = 'Quản lý lịch hẹn của bạn ở một nơi.';
  static const email = 'Email';
  static const password = 'Mật khẩu';
  static const emailRequired = 'Nhập địa chỉ email.';
  static const emailInvalid = 'Địa chỉ email chưa đúng định dạng.';
  static const passwordRequired = 'Nhập mật khẩu.';
  static const showPassword = 'Hiện mật khẩu';
  static const hidePassword = 'Ẩn mật khẩu';
  static const register = 'Đăng ký';
  static const forgotPassword = 'Quên mật khẩu?';
  static const preview = 'Xem trước giao diện lịch hẹn';
  static const authPreview = 'Tính năng tài khoản sẽ có khi kết nối Firebase.';
  static const done = 'Xong';
  static const cancel = 'Hủy';

  static const createAccount = 'Tạo tài khoản';
  static const registerSubtitle = 'Dùng email để lưu lịch hẹn của bạn.';
  static const confirmPassword = 'Xác nhận mật khẩu';
  static const confirmPasswordRequired = 'Nhập lại mật khẩu.';
  static const passwordMismatch = 'Hai mật khẩu chưa khớp.';
  static const passwordTooShort = 'Mật khẩu cần ít nhất 6 ký tự.';

  static String formatDate(DateTime date) =>
      DateFormat.yMMMMd('vi').format(date);
}
