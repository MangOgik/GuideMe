import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

const secondaryColor = Color(0xFF5593f8);
const primaryColor = Color(0xFF48c9e2);

class Palette {
  static const Color iconColor = Color(0xFFB6C7D1);
  static const Color activeColor = Color(0xFF09126C);
  static const Color textColor1 = Color(0XFFA7BCC7);
  static const Color textColor2 = Color(0XFF9BB3C0);
  static const Color facebookColor = Color(0xFF3B5999);
  static const Color googleColor = Color(0xFFDE4B39);
  static const Color backgroundColor = Color(0xFFECF3F9);
}

final formatter = NumberFormat.currency(locale: 'zh_CN', symbol: '¥'); //China
final DateFormat formatDate = DateFormat('yyyy-MM-dd H:mm');
final DateFormat formatDate2 = DateFormat('EEE, dd MMM yyyy HH:mm:ss \'GMT\'');
final DateFormat dateFormatter = DateFormat('EEEE, MMMM d, y');
final DateFormat dateFormatter2 = DateFormat('MMM d, y');
final DateFormat dateFormatterHome = DateFormat('EEEE, MMMM d, y');
