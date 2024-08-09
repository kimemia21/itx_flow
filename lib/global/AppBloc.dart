import 'package:flutter/material.dart';

class appBloc extends ChangeNotifier {
  int _currentIndex = 1;

  get currentIndex => _currentIndex;

  void changeCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }
}
