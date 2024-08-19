import 'package:flutter/material.dart';

class appBloc extends ChangeNotifier {
  int _currentIndex = 1;
  bool _navIsVisible = true;

  get currentIndex => _currentIndex;
  get navIsVisible => _navIsVisible;
  List _userCommodities=[];
  List get userCommodities => _userCommodities;

  void changeCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeNavVisibility({required bool visible}) {
    _navIsVisible = visible;
    notifyListeners();
  }

  void changeCommodites(items) {
    _userCommodities = items;

    notifyListeners();
  }
}
