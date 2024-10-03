import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:itx/Serializers/CommoditesCerts.dart';
import 'package:itx/fromWakulima/widgets/contant.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:http/io_client.dart';

import 'package:flutter/foundation.dart';

class Webbloc extends ChangeNotifier {
  int _currentIndex = 1;
  bool _navIsVisible = true;
  bool _isLoading = false;
  String _token = "";
  int _user_type = 0;
  Map<int, dynamic> _watchList = {};
  String _userEmail = "";
  List _userCommoditesCerts = [];
  List<int> _userCommoditesIds = [];
  Map<String, dynamic> userDetails = {};
  List<CommCert> commcert = [];
  String isAuthorized = "";

  int get currentIndex => _currentIndex;
  bool get navIsVisible => _navIsVisible;
  bool get isLoading => _isLoading;
  int get user_type => _user_type;
  Map<int, dynamic> get watchList => _watchList;
  String get token => _token;
  String get userEmail => _userEmail;
  List get UserCommoditesCerts => _userCommoditesCerts;
  Map<String, dynamic> get _userDetails => userDetails;

  List<String> _userCommodities = [];
  List<String> get userCommodities => _userCommodities;

  List<int> get userCommoditiesIds => _userCommoditesIds;
  int _user_id = 0;
  int get user_id => _user_id;

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

  void getUserType(int type) {
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

  void changeUserCommoditesCert(List certs) {
    _userCommoditesCerts = certs;
    notifyListeners();
  }

  void changeUserCommoditesIds(List<int> ids) {
    _userCommoditesIds = ids;
    notifyListeners();
  }

  void changeCurrentUserID({required int id}) {
    _user_id = id;

    notifyListeners();
  }

  void changeUserDetails(Map<String, dynamic> details) {
    userDetails = details;
    notifyListeners();
  }

  void changeCommCert(List<CommCert> commCert) {
    commcert.clear();
    commcert = commCert;
    notifyListeners();
  }

  void changeIsAuthorized(int status) {
    isAuthorized = status == 0 ? "no" : "yes";
    notifyListeners();
  }
}
