import 'package:intl/intl.dart';

String changeDateFormat(String dateTime) {
  DateTime pickedUpDate = DateTime.parse(dateTime);
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(pickedUpDate);

  return formattedDate;
}
