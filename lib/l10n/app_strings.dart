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

  static String formatDate(DateTime date) =>
      DateFormat.yMMMMd('vi').format(date);
}
