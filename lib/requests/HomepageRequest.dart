import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:provider/provider.dart';

import 'dart:convert';
import 'package:http/http.dart' as http;

class CommodityService {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  static Future<List<CommodityModel>> fetchCommodities(
      BuildContext context, String keyword) async {
    try {
      final Uri uri = Uri.parse("$mainUri/commodities");
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
          throw Exception(
              'Failed to fetch commodities: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch commodities');
      }
    } catch (e) {
      // Handle any errors that might have occurred
      print('Error: $e');
      throw Exception('An error occurred while fetching commodities: $e');
    }
  }

  static Future<List<ContractsModel>> getContracts(BuildContext context) async {
    final Uri uri = Uri.parse("$mainUri/contracts/list");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };
    final http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['rsp'] == true) {
        List<dynamic> contractsJson = responseData['data'];
        print(contractsJson);
        List<ContractsModel> contracts = contractsJson
            .map((contracts) => ContractsModel.fromJson(contracts))
            .toList();

        return contracts;
      } else {
        throw Exception('Failed to fetch contracts: ${responseData['msg']}');
      }
    } else {
      throw Exception('Failed to fetch commodities');
    }
  }

  static Future getCompany({required String id}) async {
    final Uri uri = Uri.parse("$mainUri/companies");
  }
}
