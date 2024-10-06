import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Serializers/ComTrades.dart';
import 'package:itx/Serializers/CommParams.dart';
import 'package:itx/Serializers/CommoditesCerts.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/Serializers/CompanySerializer.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Serializers/OrderModel.dart';
import 'package:itx/Serializers/PriceHistory.dart';
import 'package:itx/Serializers/WareHouseUsers.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class CommodityService {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // "http://192.168.100.8:3000/api/v1";
  // "http://185.141.63.56:3067/api/v1";

  static Future<List<Commodity>> fetchCommodities(
      BuildContext context, bool filter,
      [text]) async {
    try {
      final Uri uri = filter
          ? Uri.parse("$mainUri/commodities?filter=$text")
          : Uri.parse("$mainUri/commodities");

      Uri.parse("$mainUri/commodities");
      // print("token ${Provider.of<appBloc>(context, listen: false).token}");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
        // "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiYXBpIjoiQVBQIiwiaWF0IjoxNzI3MjUxMjAyLCJleHAiOjE3MjcyNjkyMDJ9.knE5b5EPyY_dwVbo9CgmkOIz_TwROiLnpR86E_rzTfs",
        // Provider.of<appBloc>(context, listen: false).token,
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
          print(responseData['msg']);
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
      {required BuildContext context, required bool isWatchList}) async {
    print(isWatchList);

    final Uri uri = isWatchList
        ? Uri.parse("$mainUri/contracts/list?this_user_liked=1")
        : Uri.parse("$mainUri/contracts/list?");
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
          CherryToast.success(
            title: Text(responseData['msg']),
          );

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
    print(
        "------------------------------------------${Provider.of<appBloc>(context, listen: false).user_id}----------------------------------");
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

  static Future CreateContract(BuildContext context, body) async {
    final Uri uri = Uri.parse("$mainUri/contracts/create");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };
    final appBloc bloc = context.read<appBloc>();
    try {
      bloc.changeIsLoading(true);
      final http.Response response =
          await http.post(uri, headers: headers, body: jsonEncode(body));

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          bloc.changeIsLoading(false);

          PersistentNavBarNavigator.pushNewScreen(
              withNavBar: false, context, screen: GlobalsHomePage());
          CherryToast.success(
            title: Text("sucess"),
          ).show(context);
        } else {
          bloc.changeIsLoading(false);
          throw Exception('Failed to create contract: ${responseData['msg']}');
        }
      } else {
        bloc.changeIsLoading(false);
        throw Exception('Failed to create contract');
      }
    } catch (e) {
      bloc.changeIsLoading(false);
      print("error creating contract $e");
    }
  }

  static Future<void> UpdateBid(
      BuildContext context, double price, int id) async {
    final Uri uri = Uri.parse("$mainUri/contracts/bids/$id");
    final Map<String, String> headers = {
      "Content-Type": "application/json", // Set Content-Type to JSON
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };

    final appBloc bloc = context.read<appBloc>();
    try {
      bloc.changeIsLoading(true);

      // Encode the body as JSON
      final Map<String, dynamic> body = {
        "bid_price": price,
      };

      final http.Response response = await http.patch(
        uri,
        headers: headers,
        body: jsonEncode(body), // Encode the body to JSON
      );

      if (response.statusCode == 200) {
        print("Patched successfully");
        bloc.changeIsLoading(false);
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bid updated successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.green,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                top: 50, left: 20, right: 20), // Positioned at the top
            duration: Duration(seconds: 3), // Duration of the snackbar
          ),
        );
      } else {
        print("Failed to patch");
        print(response.body);
        bloc.changeIsLoading(false);
      }
    } catch (e) {
      print("Error: $e");
      bloc.changeIsLoading(false);
    }
  }

  static Future<void> DeleteBid(BuildContext context, int id) async {
    final Uri uri = Uri.parse("$mainUri/contracts/bids/$id");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };

    final appBloc bloc = context.read<appBloc>();
    try {
      bloc.changeIsLoading(true);

      final http.Response response = await http.delete(
        uri,
        headers: headers,
      );

      if (response.statusCode == 200) {
        print("Deleted successfully");

        bloc.changeIsLoading(false);
        Navigator.pop(context);

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Bid deleted successfully!',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            margin: EdgeInsets.only(
                top: 50, left: 20, right: 20), // Positioned at the top
            duration: Duration(seconds: 3), // Duration of the snackbar
          ),
        );
      } else {
        print("Failed to delete");
        print(response.body);
        bloc.changeIsLoading(false);
      }
    } catch (e) {
      print("Error: $e");
      bloc.changeIsLoading(false);
    }
  }

  static Future<List<WarehouseNames>> getWareHouse(
      {required BuildContext context}) async {
    try {
      final Uri uri = Uri.parse("$mainUri/user/all?type=6");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final http.Response response = await http.get(uri, headers: headers);
      final body = jsonDecode(response.body);

      if (response.statusCode == 200 && body["rsp"]) {
        List<dynamic> data = body["data"];
        return data.map((json) => WarehouseNames.fromJson(json)).toList();
      } else {
        throw Exception("Failed to load warehouse data");
      }
    } catch (e) {
      print("Error fetching warehouse: $e");
      return [];
    }
  }
}
