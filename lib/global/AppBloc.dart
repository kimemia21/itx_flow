import 'package:flutter/material.dart';

class appBloc extends ChangeNotifier {
  int _currentIndex = 1;
  bool _navIsVisible = true;

  get currentIndex => _currentIndex;
  get navIsVisible => _navIsVisible;

  void changeCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeNavVisibility({required bool visible}) {
    _navIsVisible = visible;
    notifyListeners();
  }
}
