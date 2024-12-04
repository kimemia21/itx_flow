import 'dart:convert';

import 'package:flutter/material.dart';
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

CntSwap cntSwap = CntSwap(
  agreementDate: DateTime.now().toString(),
  partyAName: "John Doe",
  partyAAddress: "123 Party A Street, Cityville, Country",
  partyAContactPerson: "Jane Smith",
  partyAEmail: "johndoe@example.com",
  partyAPhone: "+123456789",
  partyBName: "Alice Brown",
  partyBAddress: "456 Party B Lane, Townsville, Country",
  partyBContactPerson: "Bob White",
  partyBEmail: "alicebrown@example.com",
  partyBPhone: "+987654321",
);

final Map<String, String> swapIds = {};
final Map<String, String> futuredIds = {};
final Map<String, String> forwardsIds = {};
final Map<String, String> optionsIds = {};


var grace_ip = "http://185.141.63.56:3067/api/v1/chats/unread";
var grace_html = "http://185.141.63.56:3067/api/v1/contracts/type/4/template";

Map<String, dynamic> stringToMap(String eventString) {
  try {
    return jsonDecode(eventString) as Map<String, dynamic>;
  } catch (e) {
    print('Error decoding JSON: $e');
    return {};
  }
}

Widget loading = LoadingAnimationWidget.staggeredDotsWave(
  color: Colors.white,
  size: 20,
);
