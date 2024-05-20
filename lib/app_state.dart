import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (index < 0 || index >= 4) { // 4 is the number of tabs in the app
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }
}
