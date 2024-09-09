import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

class Requests {
  static final main_url = "http://185.141.63.56:3067/api/v1/user";

  static Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String phoneNumber,
    required String user_type,
  }) async {
    final Map<String, dynamic> body = {
      "email": email,
      "password": password,
      "phonenumber": phoneNumber,
      "user_type": "1", 
    };
    print(body);

    final appBloc bloc = context.read<appBloc>();

    final Uri url = Uri.parse("$main_url/register");

    try {
      bloc.changeIsLoading();

      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["rsp"] == true) {
          print("Success: ${responseBody["message"]}");
        } else {
          print("Request failed: ${responseBody["message"]}");
        }
      } else {
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      print("Error during registration: $e");
    } finally {
      bloc.changeIsLoading(); // Stop loading state
    }
  }

  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final Map<String, dynamic> body = {"email": email, "password": password};
    print(body);

    final appBloc bloc = context.read<appBloc>();

    final Uri url = Uri.parse("$main_url/login");

    try {
      bloc.changeIsLoading();

      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["rsp"] == true) {
          print("Success: ${responseBody["message"]}");
        } else {
          print("Request failed: ${responseBody["message"]}");
        }
      } else {
        print("Error Response: ${response.body}");
      }
    } catch (e) {
      print("Error during registration: $e");
    } finally {
      bloc.changeIsLoading(); // Stop loading state
    }
  }
}
