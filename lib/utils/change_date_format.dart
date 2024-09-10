import 'package:intl/intl.dart';

// Change the data format to 'yyyy-MM-dd HH:mm'
String changeDateFormat(String dateTime) {
  DateTime pickedUpDate = DateTime.parse(dateTime);
  String formattedDate = DateFormat('yyyy-MM-dd HH:mm').format(pickedUpDate);

  return formattedDate;
}
