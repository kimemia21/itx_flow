import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class model {
  final int commodityId;
  final String commodityName;

  model({
    required this.commodityId,
    required this.commodityName,
  });
  factory model.fromJson(Map<String, dynamic> json) {
    return model(
      commodityId: json['commodity_id'],
      commodityName: json['commodity_name'],
    );
  }
}

class CommodityRequest {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // Fetch only the 'id' and 'name' fields from the commodities
  static Future<List<model>> fetchCommodities(BuildContext context) async {
    try {
      final Uri uri = Uri.parse("$mainUri/user/interests");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> commoditiesJson = responseData['data'];
          final List<model> mapper =
              commoditiesJson.map((json) => model.fromJson(json)).toList();
          return mapper;
        } else {
          throw Exception(
              'Failed to fetch commodities: ${responseData['msg']}');
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
