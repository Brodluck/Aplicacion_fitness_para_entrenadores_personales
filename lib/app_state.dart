import 'package:flutter/material.dart';

class AppState extends ChangeNotifier {
  int _selectedIndex = 0;
  final int numberOfTabs;

  AppState({required this.numberOfTabs});

  int get selectedIndex => _selectedIndex;

  void setIndex(int index) {
    if (index < 0 || index >= numberOfTabs) {
      return;
    }
    _selectedIndex = index;
    notifyListeners();
  }
}