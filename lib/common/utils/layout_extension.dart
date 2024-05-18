import 'dart:ui' as ui;

import 'package:flutter/material.dart';

mixin LayoutExtension {
  // Get size safe area for screen
  EdgeInsets get sizeSafeArea => MediaQueryData.fromWindow(ui.window).padding;
  static EdgeInsets get staticSizeSafeArea =>
      MediaQueryData.fromWindow(ui.window).padding;

  // Check device has notch or not
  bool get hasNotch => sizeSafeArea.bottom > 0;
  static bool get staticHasNotch => staticSizeSafeArea.bottom > 0;

  // Get size height screen
  double get screenHeight => MediaQueryData.fromWindow(ui.window).size.height;
  static double get staticScreenHeight =>
      MediaQueryData.fromWindow(ui.window).size.height;

  // Get size width screen
  double get screenWidth => MediaQueryData.fromWindow(ui.window).size.width;
  static double get staticScreenWidth =>
      MediaQueryData.fromWindow(ui.window).size.width;
}
