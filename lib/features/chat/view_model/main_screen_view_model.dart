import 'package:flutter/material.dart';

class MainScreenViewModel extends ChangeNotifier {
  bool _isOpened = false;

  bool get isOpened => _isOpened;

  set setIsOpened(bool value) {
    _isOpened = value;
    notifyListeners();
  }
}
