import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';

import '../data/models/appointment.dart';

class AppStrings {
  const AppStrings(this.locale);

  final Locale locale;
  static const vietnamese = Locale('vi');
  static const english = Locale('en');
  static const supportedLocales = [vietnamese, english];
  static const delegate = _AppStringsDelegate();

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings)!;

  bool get _isEnglish => locale.languageCode == 'en';

  static String languageName(Locale locale) =>
      locale.languageCode == 'en' ? 'English' : 'Tiếng Việt';

  String get appName => _isEnglish ? 'Appointments' : 'Lịch hẹn';
  String get calendar => _isEnglish ? 'Calendar' : 'Lịch';
  String get emptyTitle =>
      _isEnglish ? 'No appointments yet' : 'Chưa có lịch hẹn';
  String get emptyDescription => _isEnglish
      ? 'Add an appointment to organize your schedule.'
      : 'Thêm lịch hẹn để bắt đầu sắp xếp thời gian.';
  String get emptyDay => _isEnglish
      ? 'No appointments on this day.'
      : 'Không có lịch hẹn trong ngày này.';
  String get chooseDate => _isEnglish ? 'Choose date' : 'Chọn ngày';
  String get chooseTime => _isEnglish ? 'Choose time' : 'Chọn giờ';
  String get addAppointment => _isEnglish ? 'Add appointment' : 'Thêm lịch hẹn';
  String get title => _isEnglish ? 'Title' : 'Tiêu đề';
  String get notes => _isEnglish ? 'Notes' : 'Nội dung';
  String get location => _isEnglish ? 'Location' : 'Địa điểm';
  String get date => _isEnglish ? 'Date' : 'Ngày';
  String get time => _isEnglish ? 'Time' : 'Giờ';
  String get login => _isEnglish ? 'Sign in' : 'Đăng nhập';
  String get loginSubtitle => _isEnglish
      ? 'Manage your appointments in one place.'
      : 'Quản lý lịch hẹn của bạn ở một nơi.';
  String get email => _isEnglish ? 'Email' : 'Email';
  String get password => _isEnglish ? 'Password' : 'Mật khẩu';
  String get emailRequired =>
      _isEnglish ? 'Enter your email.' : 'Nhập địa chỉ email.';
  String get emailInvalid => _isEnglish
      ? 'Enter a valid email address.'
      : 'Địa chỉ email chưa đúng định dạng.';
  String get passwordRequired =>
      _isEnglish ? 'Enter your password.' : 'Nhập mật khẩu.';
  String get showPassword => _isEnglish ? 'Show password' : 'Hiện mật khẩu';
  String get hidePassword => _isEnglish ? 'Hide password' : 'Ẩn mật khẩu';
  String get register => _isEnglish ? 'Sign up' : 'Đăng ký';
  String get forgotPassword =>
      _isEnglish ? 'Forgot password?' : 'Quên mật khẩu?';
  String get done => _isEnglish ? 'Done' : 'Xong';
  String get cancel => _isEnglish ? 'Cancel' : 'Hủy';
  String get createAccount =>
      _isEnglish ? 'Create an account' : 'Tạo tài khoản';
  String get registerSubtitle => _isEnglish
      ? 'Use your email to save your appointments.'
      : 'Dùng email để lưu lịch hẹn của bạn.';
  String get confirmPassword =>
      _isEnglish ? 'Confirm password' : 'Xác nhận mật khẩu';
  String get confirmPasswordRequired =>
      _isEnglish ? 'Enter your password again.' : 'Nhập lại mật khẩu.';
  String get passwordMismatch =>
      _isEnglish ? 'The passwords do not match.' : 'Hai mật khẩu chưa khớp.';
  String get passwordTooShort => _isEnglish
      ? 'Use at least 6 characters.'
      : 'Mật khẩu cần ít nhất 6 ký tự.';
  String get resetPassword =>
      _isEnglish ? 'Reset password' : 'Đặt lại mật khẩu';
  String get resetPasswordSubtitle => _isEnglish
      ? 'Enter the email you used to sign up.'
      : 'Nhập email bạn dùng để đăng ký tài khoản.';
  String get sendResetLink =>
      _isEnglish ? 'Send reset link' : 'Gửi liên kết đặt lại mật khẩu';
  String get settings => _isEnglish ? 'Settings' : 'Cài đặt';
  String get settingsAccount => _isEnglish ? 'Account' : 'Tài khoản';
  String get signOut => _isEnglish ? 'Sign out' : 'Đăng xuất';
  String get signOutConfirmation => _isEnglish
      ? 'Do you want to sign out?'
      : 'Bạn có muốn đăng xuất khỏi ứng dụng?';
  String get resetSent => _isEnglish
      ? 'If this email is registered, check your inbox for a reset link.'
      : 'Nếu email đã đăng ký, hãy kiểm tra hộp thư để đặt lại mật khẩu.';
  String get authError => _isEnglish
      ? 'Something went wrong. Try again.'
      : 'Không thể thực hiện thao tác. Vui lòng thử lại.';
  String get firebaseStartupError => _isEnglish
      ? 'Could not start Firebase. Check your connection and reopen the app.'
      : 'Không thể khởi động Firebase. Hãy kiểm tra kết nối và mở lại ứng dụng.';
  String get authNetworkError => _isEnglish
      ? 'Check your internet connection and try again.'
      : 'Không có kết nối. Hãy kiểm tra mạng và thử lại.';
  String get authRateLimited => _isEnglish
      ? 'Too many attempts. Try again later.'
      : 'Bạn đã thử quá nhiều lần. Vui lòng thử lại sau.';
  String get authInvalidCredentials => _isEnglish
      ? 'The email or password is incorrect.'
      : 'Email hoặc mật khẩu chưa đúng.';
  String get authEmailInUse => _isEnglish
      ? 'This email is already registered.'
      : 'Email này đã được dùng để đăng ký.';
  String get authAccountDisabled => _isEnglish
      ? 'This account has been disabled.'
      : 'Tài khoản này đã bị vô hiệu hóa.';
  String get authWeakPassword => _isEnglish
      ? 'The password does not meet the security requirements.'
      : 'Mật khẩu chưa đáp ứng yêu cầu bảo mật.';
  String get saveAppointment =>
      _isEnglish ? 'Save appointment' : 'Lưu lịch hẹn';
  String get appointmentSaved =>
      _isEnglish ? 'Appointment saved.' : 'Đã lưu lịch hẹn.';
  String get appointmentSaveError => _isEnglish
      ? 'Could not save the appointment. Try again.'
      : 'Không thể lưu lịch hẹn. Vui lòng thử lại.';
  String get appointmentsLoadError =>
      _isEnglish ? 'Could not load appointments.' : 'Không thể tải lịch hẹn.';
  String get retry => _isEnglish ? 'Try again' : 'Thử lại';
  String get appointmentTitleRequired =>
      _isEnglish ? 'Enter an appointment title.' : 'Nhập tiêu đề lịch hẹn.';
  String get appointmentDateTimeRequired =>
      _isEnglish ? 'Choose a date and time.' : 'Chọn ngày và giờ hẹn.';
  String get appointmentMustBeFuture => _isEnglish
      ? 'Choose a time in the future.'
      : 'Chọn thời điểm trong tương lai.';
  String get appointmentPending =>
      _isEnglish ? 'Waiting to sync.' : 'Đang chờ đồng bộ.';
  String get appointmentDetails =>
      _isEnglish ? 'Appointment details' : 'Chi tiết lịch hẹn';
  String get editAppointment =>
      _isEnglish ? 'Edit appointment' : 'Sửa lịch hẹn';
  String get appointmentUpdated =>
      _isEnglish ? 'Appointment updated.' : 'Đã cập nhật lịch hẹn.';
  String get appointmentUnavailable => _isEnglish
      ? 'This appointment is no longer available.'
      : 'Lịch hẹn không còn khả dụng.';
  String get delete => _isEnglish ? 'Delete' : 'Xóa';
  String get deleteAppointment =>
      _isEnglish ? 'Delete appointment' : 'Xóa lịch hẹn';
  String get deleteAppointmentConfirmation => _isEnglish
      ? 'Delete this appointment? This action cannot be undone.'
      : 'Bạn có muốn xóa lịch hẹn này? Lịch đã xóa không thể khôi phục.';
  String get appointmentDeleted =>
      _isEnglish ? 'Appointment deleted.' : 'Đã xóa lịch hẹn.';
  String get appointmentDeleteError => _isEnglish
      ? 'Could not delete the appointment. Try again.'
      : 'Không thể xóa lịch hẹn. Vui lòng thử lại.';
  String get appointmentUpcoming => _isEnglish ? 'Upcoming' : 'Sắp diễn ra';
  String get appointmentCompleted => _isEnglish ? 'Completed' : 'Đã hoàn thành';
  String get appointmentCanceled => _isEnglish ? 'Canceled' : 'Đã hủy';
  String get completeAppointment =>
      _isEnglish ? 'Mark as complete' : 'Đánh dấu hoàn thành';
  String get cancelAppointment =>
      _isEnglish ? 'Cancel appointment' : 'Hủy lịch hẹn';
  String get cancelAppointmentConfirmation => _isEnglish
      ? 'This appointment will be marked canceled and remain in your list.'
      : 'Lịch hẹn sẽ được đánh dấu Đã hủy và vẫn xuất hiện trong danh sách.';
  String get keepAppointment =>
      _isEnglish ? 'Keep appointment' : 'Giữ lịch hẹn';
  String get appointmentStatusError => _isEnglish
      ? 'Could not update the status. Try again.'
      : 'Không thể cập nhật trạng thái. Vui lòng thử lại.';
  String get searchAppointments =>
      _isEnglish ? 'Search by title' : 'Tìm theo tiêu đề';
  String get filterStatus =>
      _isEnglish ? 'Filter by status' : 'Lọc theo trạng thái';
  String get allStatuses => _isEnglish ? 'All statuses' : 'Tất cả trạng thái';
  String get noAppointmentMatches =>
      _isEnglish ? 'No appointments match.' : 'Không có lịch hẹn phù hợp.';
  String get appointmentConflictTitle =>
      _isEnglish ? 'Scheduling conflict' : 'Trùng giờ hẹn';
  String get appointmentConflictMessage => _isEnglish
      ? 'You already have an appointment at this time. Save anyway?'
      : 'Bạn đã có một lịch hẹn vào thời điểm này. Bạn vẫn muốn lưu?';
  String get appointmentChooseAnotherTime =>
      _isEnglish ? 'Choose another time' : 'Chọn giờ khác';
  String get appointmentSaveAnyway => _isEnglish ? 'Save anyway' : 'Vẫn lưu';
  String get appointmentConflictNetworkError => _isEnglish
      ? 'Could not connect to Firestore. Check your connection and try again.'
      : 'Không thể kết nối Firestore. Kiểm tra mạng rồi thử lại.';
  String get appointmentsAwaitingServer => _isEnglish
      ? 'Waiting for Firestore to confirm the data. Reconnect if you are offline.'
      : 'Đang chờ Firestore xác nhận dữ liệu. Nếu mất mạng, hãy kết nối lại.';
  String get appointmentsCached => _isEnglish
      ? 'Showing saved data from this device. It may be out of date.'
      : 'Đang hiển thị dữ liệu đã lưu trên thiết bị. Danh sách có thể chưa cập nhật.';
  String get settingsLanguage => _isEnglish ? 'Language' : 'Ngôn ngữ';
  String get settingsGeneral => _isEnglish ? 'General' : 'Chung';
  String get languageSaveError => _isEnglish
      ? 'Could not save your language choice. Try again.'
      : 'Không thể lưu ngôn ngữ. Vui lòng thử lại.';

  String get settingsAppearance => _isEnglish ? 'Appearance' : 'Giao diện';
  String get themeSystem => _isEnglish ? 'System' : 'Theo hệ thống';
  String get themeLight => _isEnglish ? 'Light' : 'Sáng';
  String get themeDark => _isEnglish ? 'Dark' : 'Tối';
  String get themeSaveError => _isEnglish
      ? 'Could not save your appearance choice. Try again.'
      : 'Không thể lưu giao diện. Vui lòng thử lại.';

  String statusLabel(AppointmentStatus? status) => switch (status) {
    AppointmentStatus.upcoming => appointmentUpcoming,
    AppointmentStatus.completed => appointmentCompleted,
    AppointmentStatus.canceled => appointmentCanceled,
    null => allStatuses,
  };

  String statusFilterLabel(AppointmentStatus? status) =>
      '$filterStatus · ${statusLabel(status)}';

  String appointmentsOnDay(int count) {
    final total = NumberFormat.decimalPattern(locale.languageCode)
        .format(count);
    if (!_isEnglish) return '$total lịch hẹn trong ngày';
    return count == 1
        ? '1 appointment that day'
        : '$total appointments that day';
  }

  String formatDate(DateTime date) =>
      DateFormat.yMMMMd(locale.languageCode).format(date);
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) => AppStrings.supportedLocales.any(
    (supported) => supported.languageCode == locale.languageCode,
  );

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture(AppStrings(locale));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
