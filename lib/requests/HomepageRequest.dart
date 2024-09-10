import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CommodityService {
  static Future<List<CommodityModel>> fetchCommodities(
      BuildContext context, String keyword) async {
    final Uri uri = Uri.parse(
        "http://185.141.63.56:3067/api/v1/commodities?filter=commodityosearch&user=$keyword");
    print(Provider.of<appBloc>(context, listen: false).token);
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };

    final response = await http.get(uri, headers: headers);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['rsp'] == true) {
        List<dynamic> commoditiesJson = responseData['data'];
        print(commoditiesJson);
        List<CommodityModel> commodities = commoditiesJson
            .map((commodity) => CommodityModel.fromJson(commodity))
            .toList();

        return commodities;
      } else {
        throw Exception('Failed to fetch commodities: ${responseData['msg']}');
      }
    } else {
      throw Exception('Failed to fetch commodities');
    }
  }
}
