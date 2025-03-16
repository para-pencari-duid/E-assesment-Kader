import 'package:flutter/material.dart';

enum AppColors {
  green400("Green-400", Color(0xff50C878)),
  green500("Green-500", Color(0xff36B15F)),
  green700("Green-700", Color(0xff22733D)),
  grey300("Grey-300", Color(0xffB2BEC7)),
  blue300("Blue-300", Color(0xff83DFFF));

  const AppColors(this.name, this.color);

  final String name;
  final Color color;
}
