import 'dart:convert';

import 'package:itx/Serializers/User.dart';

UserModel currentUser = UserModel(
    user_id: 0,
    user_email: "",
    user_type: 0,
    authorized: 0,
    token: "",
    user_type_name: "");

var grace_ip = "http://192.168.100.56:3001/api/v1/chats/unread";

  Map<String, dynamic> stringToMap(String eventString) {
  try {
    return jsonDecode(eventString) as Map<String, dynamic>;
  } catch (e) {
    print('Error decoding JSON: $e');
    return {};
  }
}