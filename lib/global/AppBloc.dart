import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:flutter/foundation.dart';

class appBloc extends ChangeNotifier {
  int _currentIndex = 1;
  bool _navIsVisible = true;
  bool _isLoading = false;
  String _token = "";
  String _user_type = "";
  Map<int, dynamic> _watchList = {};
  String _userEmail = "";
  

  int get currentIndex => _currentIndex;
  bool get navIsVisible => _navIsVisible;
  bool get isLoading => _isLoading;
  String get user_type => _user_type;
  Map<int, dynamic> get watchList => _watchList;
  String get token => _token;
  String get userEmail => _userEmail;


  List<String> _userCommodities = [];
  List<String> get userCommodities => _userCommodities;

  void changeCurrentIndex({required int index}) {
    _currentIndex = index;
    notifyListeners();
  }

  void changeNavVisibility({required bool visible}) {
    _navIsVisible = visible;
    notifyListeners();
  }

  void changeCommodites(List<String> items) {
    _userCommodities = items;
    notifyListeners();
  }

  void getUserType(String type) {
    _user_type = type;
    notifyListeners();
  }

  void changeIsLoading(bool status) {
    _isLoading = status;
    print(_isLoading);
    notifyListeners();
  }

  void changeToken(String token) {
    _token = token;
    notifyListeners();
  }

  void changeWatchList(Map<int, dynamic> newWatchList) {
    _watchList = newWatchList;
    notifyListeners();
  }

  void addToWatchList(int contractId, dynamic data) {
    _watchList[contractId] = data;
    notifyListeners();
  }

  void removeFromWatchList(int contractId) {
    _watchList.remove(contractId);
    notifyListeners();
  }

  bool isInWatchList(int contractId) {
    return _watchList.containsKey(contractId);
  }
  void changeUser(String email) {
    _userEmail = email;
    notifyListeners();
  } 
}

class CurrentUserProvider extends ChangeNotifier {
  String currentUser = "${FirebaseAuth.instance.currentUser?.email}";
  bool _isLoading = false;
  bool _internetConnected = false;
  int _cartNumber = 0;
  String _role = "";

  List _list = all;

  bool get isLoading => _isLoading;
  bool get internetConnected => _internetConnected;
  List get list => _list;
  int get cartNumber => _cartNumber;
  String get role => _role;

  int _newMessages = 0;

  int get newMessages => _newMessages;

  CurrentUserProvider();

  void changeCurrentUser({required String newUser}) {
    currentUser = newUser;
    print(currentUser);
    notifyListeners();
  }

  void changeCartCount() {
    print("$_cartNumber before");
    _cartNumber += 1;
    print("$_cartNumber after");

    notifyListeners();
  }

  void changeIsLoading() {
    _isLoading = !_isLoading;
    notifyListeners();
  }

  void changeInternetConnection(bool internet) {
    _internetConnected = internet;
    print(
        "Internet connection status changed to: $_internetConnected"); // Debug print
    notifyListeners();
  }

  void changeItems(List list) {
    _list = list;
    print("List changed to : $_list"); // Debug print
    notifyListeners();
  }

  Future changeRole({required BuildContext context}) async {
    String role = await Globals.userRole(context: context);
    _role = role;
    print("========$_role===============");
    notifyListeners();
  }
}

Future<bool> checkInternetConnection(BuildContext context) async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.none) {
    // No network connection
    return false;
  }

  final url = "https://www.google.com"; // Use a reliable URL

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Cache-Control': 'no-cache',
        'Pragma': 'no-cache',
        'Expires': '0',
      },
    );
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    // Network request failed, likely due to no internet
    return false;
  }
}
