import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/Serializers/CompanySerializer.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:provider/provider.dart';


class CommodityService {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  static Future<List<CommodityModel>> fetchCommodities(
      BuildContext context, String keyword) async {
    try {
      final Uri uri = Uri.parse("$mainUri/commodities");
      // print("token ${Provider.of<appBloc>(context, listen: false).token}");
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

  static Future<List<ContractsModel>> getContracts(
      BuildContext context, filter) async {
    final Uri uri = Uri.parse("$mainUri/contracts/list?${filter}");
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

  static Future PostContracts(BuildContext context) async {
    final Uri uri = Uri.parse("$mainUri/user/interests");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };
    final Map<String, String> body = {
      "commodities": Provider.of<appBloc>(context, listen: false)
          .userCommoditiesIds
          .join(","),
    };

    final http.Response response =
        await http.post(uri, headers: headers, body: body);

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['rsp'] == true) {
        Navigator.push(context,
            MaterialPageRoute(builder: (context) => GlobalsHomePage()));
      } else {
        throw Exception('Failed to submit  Docs: ${responseData['msg']}');
      }
    } else {
      throw Exception('Failed to fetch commodities');
    }
  }

  static Future getCompany(
      {required BuildContext context, required String id}) async {
    try {
      print("get user company");
      final Uri uri = Uri.parse("$mainUri/user/company/$id");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };
      final http.Response response = await http.get(uri, headers: headers);

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body["rsp"]) {
          List<dynamic> data = body["data"];
          print("this is  ${data[0]}");
          CompanyModel companyModel = CompanyModel.fromJson(data[0]);

          // List<CompanyModel> company =
          //     data.map((company) => CompanyModel.fromJson(company)).toList();

          return companyModel;
        } else {
          print("error message from getcompany() ${body["message"]}");
        }
      } else {
        print("error message from getcompany() ${body["message"]}");
      }
    } catch (e) {
      print("catch error $e in getCompany ");
    }
  }

  static Future<List<UserOrders>> getOrders(
      {required BuildContext context}) async {
    try {
      final Uri uri = Uri.parse("$mainUri/user/orders");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };
      final http.Response response = await http.get(uri, headers: headers);

      final body = jsonDecode(response.body);
      if (response.statusCode == 200) {
        if (body["rsp"]) {
          List<dynamic> data = body["data"];
          print(data);
          final List<UserOrders> orders =
              data.map((order) => UserOrders.fromJson(order)).toList();
          return orders;
        } else {
          print("error message  ${body["message"]}");
          throw Exception("error message ${body["message"]}");
        }
      } else {
        print("error message ${body["message"]}");
        throw Exception("error message  ${body["message"]}");
      }
    } catch (e) {
      print("catch error $e");
      throw Exception("got this error $e");
    }
  }
}
