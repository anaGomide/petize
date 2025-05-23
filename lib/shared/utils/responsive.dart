import 'package:flutter/material.dart';

class Responsive {
  static bool isMobile(BuildContext context) => MediaQuery.of(context).size.width < 800;

  static bool isTablet(BuildContext context) => MediaQuery.of(context).size.width < 1300 && MediaQuery.of(context).size.width >= 800;

  static bool isDesktop(BuildContext context) => MediaQuery.of(context).size.width >= 1300;
}
