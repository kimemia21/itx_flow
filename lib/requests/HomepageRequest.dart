import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/ComTrades.dart';
import 'package:itx/Serializers/CommParams.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/Serializers/CompanySerializer.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:provider/provider.dart';

class CommodityService {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // "http://192.168.100.8:3000/api/v1";
  // "http://185.141.63.56:3067/api/v1";

  static Future<List<Commodity>> fetchCommodities(BuildContext context) async {
    print("init");
    try {
      final Uri uri = Uri.parse("$mainUri/commodities");
      // print("token ${Provider.of<appBloc>(context, listen: false).token}");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        print("success");
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> commoditiesJson = responseData['data'];
          print(commoditiesJson);
          List<Commodity> commodities = commoditiesJson
              .map((commodity) => Commodity.fromJson(commodity))
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

  static Future<List<ContractsModel>> getContracts(BuildContext context, filter,
      [int? id]) async {
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

  static Future<List<PricehistoryModel>> ContractsBids(
      {required BuildContext context, required int id}) async {
    try {
      final Uri uri = Uri.parse("$mainUri/contracts/$id/orders");

      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final http.Response response = await http.get(uri, headers: headers);
      print("sucess");
      if (response.statusCode == 200) {
        print("item bids");

        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          print(responseData["data"]);
          List<dynamic> priceJson = responseData['data'];
          print("---------------$priceJson-------------------");
          List<PricehistoryModel> price = priceJson
              .map((price) => PricehistoryModel.fromJson(price))
              .toList();

          return price;
        } else {
          throw Exception(
              'Failed to fetch pricehistory: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch pricehistory');
      }
    } catch (e) {
      print("got this error $e");
      throw Exception("price history error $e");
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
      print("start");
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

  static Future<bool> PostBid(BuildContext context, body, id) async {
    final Uri uri = Uri.parse("$mainUri/contracts/$id/order");

    try {
      final String token = Provider.of<appBloc>(context, listen: false).token;
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": token,
      };

      final http.Response response = await http.post(
        uri,
        headers: headers,
        body: json.encode(body), // Ensure the body is properly encoded
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          print("Bid placed successfully");
          return true;
        } else {
          throw Exception('Bid placement failed: ${responseData['msg']}');
        }
      } else {
        throw Exception(
            'HTTP error ${response.statusCode}: ${response.reasonPhrase}');
      }
    } catch (e) {
      print("Error in postBid function: $e");
      return false; // Return false instead of throwing an exception
    }
  }

  static Future<List<ContractsModel>> getAdvancedContracts(BuildContext context,
      String date_from, String date_to, String price_from, String price_to,
      [int? id]) async {
    print("------------------------------------------${Provider.of<appBloc>(context, listen: false).user_id}----------------------------------");
    String filter =
        "userid=${Provider.of<appBloc>(context, listen: false).user_id}&this_user_liked=-1&this_user_bought=-1&this_user_paid=-1&date_from=$date_from&date_to=$date_to&price_from=$price_from&price_to=$price_to";

    print("------$mainUri/contracts/list?$filter-----------");

    try {
      final Uri uri = Uri.parse("$mainUri/contracts/list?$filter");
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
          throw Exception(
              'Failed to fetch filter contracts: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch filter contracts');
      }
    } catch (e) {
      print(e);
      throw Exception("$e error in fetching contracts");
    }
  }

  static Future<CommodityResponse> fetchCommodityInfo(
      BuildContext context, int id) async {
    try {
      final Uri uri = Uri.parse("$mainUri/contracts/$id/trades");
      // print("token ${Provider.of<appBloc>(context, listen: false).token}");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          return CommodityResponse.fromJson(responseData);
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

  static Future<List<CommParams>> getPrams({
    required BuildContext context,
    required int id,
  }) async {
    final Uri uri = Uri.parse("$mainUri/commodities/$id/params");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };
    try {
      final http.Response response = await http.get(uri, headers: headers);
      if (response.statusCode == 200) {
        print("--------sucesss------");
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> paramsJson = responseData['data'];
          print(paramsJson);
          List<CommParams> params =
              paramsJson.map((params) => CommParams.fromJson(params)).toList();

          return params;
        } else {
          throw Exception('Failed to fetch params: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch params');
      }
    } catch (e) {
      throw Exception("---------Failed to fetch params $e---------");
    }
  }
}
