import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/ContSerilizers/CntForwards.dart';
import 'package:itx/ContSerilizers/CntFutures.dart';
import 'package:itx/ContSerilizers/CntOptions.dart';
import 'package:itx/ContSerilizers/CntSwap.dart';
import 'package:itx/Serializers/User.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

UserModel currentUser = UserModel(
    user_id: 0,
    user_email: "",
    user_type: 0,
    authorized: 0,
    token: "",
    user_type_name: "");













 Map<String, String> swapIds = {};
 Map<String, String> futureIds = {};
  Map<String, String> forwardsIds = {};
 Map<String, String> optionsIds = {};




var grace_ip = "http://185.141.63.56:3067/api/v1/chats/unread";
var grace_html = "http://185.141.63.56:3067/api/v1/contracts/type/";

Map<String, dynamic> stringToMap(String eventString) {
  try {
    return jsonDecode(eventString) as Map<String, dynamic>;
  } catch (e) {
    print('Error decoding JSON: $e');
    return {};
  }
}

Widget loading = LoadingAnimationWidget.staggeredDotsWave(
  color: Colors.green,
  size: 30,
);
