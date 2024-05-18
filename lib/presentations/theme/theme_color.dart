import 'package:flutter/material.dart';

class AppColors {
  static BoxShadow boxShadow = BoxShadow(
    color: AppColors.grey1.withOpacity(0.2),
    offset: const Offset(0, 2),
    blurRadius: 2,
  );

  static const Color primary = Color(0xFF1332B5);
  static const Color text = black;

  static const Color icon = Color(0xFF98A3B3);

  static const Color white = Colors.white;

  static const Color title = Color(0xFF222222);

  static const Color yellow = Color(0xFFF2e912);
  static const Color purple = Color(0xffa133ed);

  //green
  static const Color green = Color(0xff00BB86);
  static const Color green2 = Color(0xff1b5d1f);

  //green
  static Color green50 = Colors.green.shade50;
  static const Color red50 = Color(0xffFFEBEE);

  //orange
  static Color orange50 = Colors.orange.shade50;

  //red
  static const Color red = Color(0xffFF3B31);

  static const Color danger = Color(0xffFD5F62);

  static Color transparent = Colors.transparent;

  static const Color backgroundItem = Color(0xffFFF5E5);

  static Color grey50 = Colors.grey[50]!;
  static Color grey100 = Colors.grey[100]!;
  static Color grey200 = Colors.grey[200]!;
  static Color grey300 = Colors.grey[300]!;
  static Color grey400 = Colors.grey[400]!;
  static Color grey500 = Colors.grey[500]!;
  static Color grey600 = Colors.grey[600]!;

  //black
  static const Color black = Colors.black;
  static const Color black45 = Colors.black45;
  static Color black54 = Colors.black54;
  static Color stroke = const Color(0xffDDDDDB);
  static Color greyBackground = const Color(0xfff8f8f8);
  static Color greyBorder = const Color(0xff808080);

  //grey
  static const Color grey0 = Color(0xffB0B0B0);
  static const Color grey0_5 = Color(0xffa1a1a1);
  static const Color grey1 = Color(0xff929292);
  static const Color grey1_5 = Color(0xff848484);
  static const Color grey2 = Color(0xff757575);
  static const Color grey3 = Color(0xff575757);
  static const Color grey4 = Color(0xff3a3a3a);
  static const Color grey5 = Color(0xff1c1c1c);
  static const Color grey6 = Color(0xff161616);
  static const Color grey7 = Color(0xff111111);
  static const Color grey8 = Color(0xff0b0b0b);
  static const Color grey8_5 = Color(0xff080808);
  static const Color grey9 = Color(0xff060606);
  static const Color grey9_5 = Color(0xff030303);
  static const Color grey10 = Color(0xff000000);

  //blue
  static const Color blue = Colors.blue;
  static Color blue50 = Colors.blue.shade50;
  static Color blue100 = Colors.blue.shade100;

  static Color blue200 = Colors.blue.shade200;
  static Color blue300 = Colors.blue.shade300;
  static Color blue400 = Colors.blue.shade400;
  static Color blue500 = Colors.blue.shade500;
  static Color blue600 = Colors.blue.shade600;
  static Color blue700 = Colors.blue.shade700;
  static Color blue800 = Colors.blue.shade800;
  static Color blue900 = Colors.blue.shade900;
  static const Color blue10 = Color(0xff000000);

  //neutral
  static const Color neutral300 = Color(0xffc0c0cf);
}
