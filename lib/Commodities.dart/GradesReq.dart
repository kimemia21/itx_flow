import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class GradeRequest {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // Fetch only the 'id' and 'name' fields from the Grade
  static Future<List<Map<String, dynamic>>> fetchGrade(
      BuildContext context) async {
    try {
      // final commId = Provider.of<appBloc>(context, listen: false).commId;


      final Uri uri = Uri.parse("$mainUri/commodities/grades/1");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> GradeTypeJson = responseData['data'];

          // Return only a list of maps with id and name
          List<Map<String, dynamic>> GradeType = GradeTypeJson.map((grade) => {
                "id": grade["id"],
                "grade_name": grade["grade_name"],
              }).toList();

          return GradeType;
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
