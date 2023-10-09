
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum StatusColor {
  active,
  initiated,
  authorized,
  returned,
}

extension StatusColorExtension on StatusColor {
  Color get stepperColor =>
      this == StatusColor.returned ? Colors.red : Colors.green;

  Color get stepperLineColor => this == StatusColor.returned ? Colors.red : Colors.grey;

  Object get icon =>
      this == StatusColor.returned
          ? SvgPicture.asset(
        'assets/images/cross_icon.svg',
        width: 30,
        height: 30,
      )
          : Icons.check;
}
