import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/models/appointment.dart';

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
  static const done = 'Xong';
  static const cancel = 'Hủy';

  static const createAccount = 'Tạo tài khoản';
  static const registerSubtitle = 'Dùng email để lưu lịch hẹn của bạn.';
  static const confirmPassword = 'Xác nhận mật khẩu';
  static const confirmPasswordRequired = 'Nhập lại mật khẩu.';
  static const passwordMismatch = 'Hai mật khẩu chưa khớp.';
  static const passwordTooShort = 'Mật khẩu cần ít nhất 6 ký tự.';

  static const resetPassword = 'Đặt lại mật khẩu';
  static const resetPasswordSubtitle =
      'Nhập email bạn dùng để đăng ký tài khoản.';
  static const sendResetLink = 'Gửi liên kết đặt lại mật khẩu';

  static const signOut = 'Đăng xuất';
  static const resetSent =
      'Nếu email đã đăng ký, hãy kiểm tra hộp thư để đặt lại mật khẩu.';
  static const authError = 'Không thể thực hiện thao tác. Vui lòng thử lại.';
  static const firebaseStartupError =
      'Không thể khởi động Firebase. Hãy kiểm tra kết nối và mở lại ứng dụng.';
  static const authNetworkError =
      'Không có kết nối. Hãy kiểm tra mạng và thử lại.';
  static const authRateLimited =
      'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.';
  static const authInvalidCredentials = 'Email hoặc mật khẩu chưa đúng.';
  static const authEmailInUse = 'Email này đã được dùng để đăng ký.';
  static const authAccountDisabled = 'Tài khoản này đã bị vô hiệu hóa.';
  static const authWeakPassword = 'Mật khẩu chưa đáp ứng yêu cầu bảo mật.';

  static const saveAppointment = 'Lưu lịch hẹn';
  static const appointmentSaved = 'Đã lưu lịch hẹn.';
  static const appointmentSaveError =
      'Không thể lưu lịch hẹn. Vui lòng thử lại.';
  static const appointmentsLoadError = 'Không thể tải lịch hẹn.';
  static const retry = 'Thử lại';
  static const appointmentTitleRequired = 'Nhập tiêu đề lịch hẹn.';
  static const appointmentDateTimeRequired = 'Chọn ngày và giờ hẹn.';
  static const appointmentMustBeFuture = 'Chọn thời điểm trong tương lai.';
  static const appointmentPending = 'Đang chờ đồng bộ.';

  static const appointmentDetails = 'Chi tiết lịch hẹn';
  static const editAppointment = 'Sửa lịch hẹn';
  static const appointmentUpdated = 'Đã cập nhật lịch hẹn.';
  static const appointmentUnavailable = 'Lịch hẹn không còn khả dụng.';

  static const delete = 'Xóa';
  static const deleteAppointment = 'Xóa lịch hẹn';
  static const deleteAppointmentConfirmation =
      'Bạn có muốn xóa lịch hẹn này? Lịch đã xóa không thể khôi phục.';
  static const appointmentDeleted = 'Đã xóa lịch hẹn.';
  static const appointmentDeleteError =
      'Không thể xóa lịch hẹn. Vui lòng thử lại.';

  static const appointmentUpcoming = 'Sắp diễn ra';
  static const appointmentCompleted = 'Đã hoàn thành';
  static const appointmentCanceled = 'Đã hủy';
  static const completeAppointment = 'Đánh dấu hoàn thành';
  static const cancelAppointment = 'Hủy lịch hẹn';
  static const cancelAppointmentConfirmation =
      'Lịch hẹn sẽ được đánh dấu Đã hủy và vẫn xuất hiện trong danh sách.';
  static const keepAppointment = 'Giữ lịch hẹn';
  static const appointmentStatusError =
      'Không thể cập nhật trạng thái. Vui lòng thử lại.';

  static const searchAppointments = 'Tìm theo tiêu đề';
  static const filterStatus = 'Lọc theo trạng thái';
  static const allStatuses = 'Tất cả trạng thái';
  static const noAppointmentMatches = 'Không có lịch hẹn phù hợp.';

  static String statusLabel(AppointmentStatus? status) => switch (status) {
    AppointmentStatus.upcoming => appointmentUpcoming,
    AppointmentStatus.completed => appointmentCompleted,
    AppointmentStatus.canceled => appointmentCanceled,
    null => allStatuses,
  };

  static String statusFilterLabel(AppointmentStatus? status) =>
      '$filterStatus · ${statusLabel(status)}';

  static String appointmentsOnDay(int count) => '$count lịch hẹn trong ngày';

  static String formatDate(DateTime date) =>
      DateFormat.yMMMMd('vi').format(date);
}
