import 'package:flutter/material.dart';

class AppBarController extends ChangeNotifier {
  PreferredSizeWidget? _currentAppBar;

  PreferredSizeWidget? get currentAppBar => _currentAppBar;

  void setAppBar(PreferredSizeWidget appBar) {
    _currentAppBar = appBar;
    notifyListeners(); // Notify listeners to rebuild the AppBar
  }

  void resetToDefault() {
    _currentAppBar = null; // Fallback to default AppBar
    notifyListeners();
  }
}