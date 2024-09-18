import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class CommodityRequest {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // Fetch only the 'id' and 'name' fields from the commodities
  static Future<List<Map<String, dynamic>>> fetchCommodities(BuildContext context) async {
    try {
      final Uri uri = Uri.parse("$mainUri/commodities");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> commoditiesJson = responseData['data'];

          // Return only a list of maps with id and name
          List<Map<String, dynamic>> commodities = commoditiesJson
              .map((commodity) => {
                    "id": commodity["id"],
                    "name": commodity["name"],
                  })
              .toList();

          return commodities;
        } else {
          throw Exception('Failed to fetch commodities: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch commodities');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching commodities: $e');
    }
  }
}