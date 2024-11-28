import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:itx/Serializers/Grade.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GradeRequest {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // Fetch only the 'id' and 'grade_name' fields from the Grade
  static Future<List<Grade>> fetchGrade(BuildContext context, int id) async {
    try {
      final Uri uri = Uri.parse("$mainUri/commodities/grades/$id");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": currentUser.token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> gradeJson = responseData['data'];

          // Parse the JSON data into a list of Grade objects
          List<Grade> gradeType = gradeJson.map((jsonItem) {
            return Grade.fromJson(jsonItem);
          }).toList();

          return gradeType;
        } else {
          throw Exception('Failed to fetch grade type: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch grade type');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching grade type: $e');
    }
  }
}
