import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Serializers/CommParams.dart';
import 'package:itx/Serializers/UserTypes.dart';
import 'package:itx/authentication/Regulator.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

class AuthRequest {
  // Base URL for the API
  static const main_url = "http://185.141.63.56:3067/api/v1";

  // "http://192.168.100.8:3000/api/v1"
  // "http://185.141.63.56:3067/api/v1";

  // Register request
  static Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String phoneNumber,
    required String user_type,
  }) async {
    final appBloc bloc = Provider.of<appBloc>(context, listen: false);

    try {
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "phonenumber": phoneNumber,
        "user_type": int.parse(user_type),
      };

      final Uri url = Uri.parse("$main_url/user/register");

      bloc.changeIsLoading(true);

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
          bloc.getUserType(user_type);
          bloc.changeIsLoading(false);
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Verification(
                context: context,
                email: email,
                phoneNumber: phoneNumber,
              ),
            ),
          );
        } else {
          print("Request failed: ${responseBody["message"]}");
          bloc.changeIsLoading(false);
          _showErrorDialog(
              context, "Registration Error", responseBody["message"]);
        }
      } else {
        bloc.changeIsLoading(false);
        print("Error Response: ${response.body}");
        final body = jsonDecode(response.body) as Map;
        String message = body["message"] == "User already exists"
            ? "User with email $email already exists"
            : body["message"];
        _showErrorDialog(context, "Registration Error", message);
      }
    } catch (e) {
      print("Error during registration: $e");
      _showErrorDialog(context, "Registration Error",
          "An unexpected error occurred. Please try again.");
    } finally {
      bloc.changeIsLoading(false);
    }
  }

  static void _showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  static Future<void> UserCommodities({
    required BuildContext context,
    required String user_type,
    required List<int> commodities,
  }) async {
    final appBloc bloc = context.read<appBloc>();

    bloc.changeIsLoading(true);
    // Start loading state at the beginning

    try {
      // Prepare the request body
      final Map<String, dynamic> body = {
        "commodities": commodities.join(","),
        "user_type_id": int.parse(user_type)
      };
      bloc.changeUserCommoditesIds(commodities);

      final Uri url = Uri.parse("$main_url/commodities/certs");
      print(Provider.of<appBloc>(context, listen: false).token);
      // Send POST request to the API
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {
          "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["rsp"] == true) {
          // success case
          print("Success: ${responseBody["data"]}");
          bloc.getUserType(user_type);
          bloc.changeUserCommoditesCert(responseBody["data"]);
          print(" this is user bloc ${bloc.UserCommoditesCerts}");
          bloc.changeIsLoading(false);

          Globals.switchScreens(context: context, screen: Regulators());
        } else {
          // Handle specific failure
          _handleError(
              context, "commodities select Error", responseBody["message"]);
        }
      } else {
        // Handle other HTTP status codes
        bloc.changeIsLoading(false);
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String errorMessage =
            responseBody["message"] ?? "An unknown error occurred";
        _handleError(context, "Registration Error", errorMessage);
      }
    } catch (e) {
      // Handle exceptions during the request or response parsing
      print("Error during registration: $e");
      _handleError(context, "Registration Error",
          "Failed to process the request. Please try again.");
    } finally {
      // Ensure that loading is stopped regardless of success or failure
      bloc.changeIsLoading(false);
    }
  }

  static void _handleError(BuildContext context, String title, String content) {
    Globals.warningsAlerts(
      title: title,
      content: content,
      context: context,
    );
  }

  static Future createBid(BuildContext context, bid, int id) async {
    final Uri uri = Uri.parse("$main_url/contracts/$id/order");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };

    final request =
        await http.post(body: jsonEncode(bid), uri, headers: headers);

    print("request ${request.body}");

    if (request.statusCode == 200) {
      final responseBody = jsonDecode(request.body);
      print("responseBody ${responseBody}");

      if (responseBody.toString().contains("true")) {
        // Show an authentication error if OTP fails
        Globals.warningsAlerts(
          title: "Highest Bidder",
          content: responseBody["msg"],
          context: context,
        );
      } else {
        // Show an authentication error if OTP fails
        Globals.warningsAlerts(
          title: "bidding  Error",
          content: responseBody["rsp"],
          context: context,
        );
      }
    }
  }

  static Future likeunlike(BuildContext context, likeunl, int id) async {
    final Uri uri = Uri.parse("$main_url/contracts/$id/like");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };

    final request = await http.post(
        body: jsonEncode({"like": likeunl}), uri, headers: headers);

    print("request ${request.body}");

    if (request.statusCode == 200) {}
  }

  static Future<List<UserTypeModel>> getContracts(BuildContext context) async {
    final Uri uri = Uri.parse("$main_url/user/types");
    final Map<String, String> headers = {
      "Content-Type": "application/json",
      // "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
    };
    final http.Response response = await http.get(uri, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseData = json.decode(response.body);

      if (responseData['rsp'] == true) {
        List<dynamic> contractsJson = responseData['data'];
        print(contractsJson);
        List<UserTypeModel> contracts = contractsJson
            .map((contracts) => UserTypeModel.fromJson(contracts))
            .toList();

        return contracts;
      } else {
        throw Exception('Failed to fetch usertypes: ${responseData['msg']}');
      }
    } else {
      throw Exception('Failed to fetch commodities');
    }
  }

  // OTP verification request
  static Future<void> otp({
    required BuildContext context,
    required String email,
    required String otp,
  }) async {
    final appBloc bloc = context.read<appBloc>();

    // Define the OTP verification endpoint
    final Uri url = Uri.parse("$main_url/user/otpc");

    // Prepare the request body for OTP verification
    final Map<String, dynamic> body = {
      "email": email,
      "otp": otp,
    };

    try {
      // Start loading state
      bloc.changeIsLoading(true);

      // Send POST request for OTP verification
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("${response.body} success");
        final Map responseBody = jsonDecode(response.body);

        if (responseBody["rsp"]) {
          // On successful OTP verification, save the token and navigate to the home page
          final String token = responseBody["token"];
          context.read<appBloc>().changeToken(token);

          // Delay navigation for a few seconds for better UX
          Future.delayed(Duration(seconds: 3));
          Globals.switchScreens(context: context, screen: Commodities());

          bloc.changeIsLoading(false); // Stop loading after success
        } else {
          // Show an authentication error if OTP fails
          Globals.warningsAlerts(
            title: "Authentication Error",
            content: responseBody["rsp"],
            context: context,
          );
        }
      } else {
        // Show an authentication error for non-200 responses
        Globals.warningsAlerts(
          title: "Authentication Error",
          content: response.body,
          context: context,
        );
        print("${response.body} failed ");
      }
    } catch (e) {
      // Handle errors during OTP request
      print("Error during OTP verification: $e");
    } finally {
      // Stop loading state
      bloc.changeIsLoading(false);
    }
  }

  // Login request
  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final appBloc bloc = context.read<appBloc>();
    try {
      // Prepare the request body for login
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };
      // Define the login endpoint
      final Uri url = Uri.parse("http://185.141.63.56:3067/api/v1/user/login");

      // Start loading state
      bloc.changeIsLoading(true);

      // Send POST request to login the user
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'}, // Added headers
      );

      // Check for a successful response (status code 200)
      if (response.statusCode == 200) {
        print("Success");

        // Parse the response body
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        // Check for the rsp field in the response body
        if (responseBody["rsp"] == true) {
          String token = responseBody["token"];
          String type = responseBody["user_type"] ?? "seller";
          int id = responseBody["user_id"];

          // Update the bloc with new state
          bloc.changeIsLoading(false);
          bloc.changeToken(token);
          bloc.getUserType(type);
          bloc.changeUser(email);
          bloc.changeCurrentUserID(id: id);

          // Switch screens upon successful login
          Globals.switchScreens(context: context, screen: GlobalsHomePage());

          print("Login successful: ${responseBody["message"]}");
        } else {
          // Handle login failure
          bloc.changeIsLoading(false);
          print("Login failed: ${responseBody["message"]}");

          Globals.warningsAlerts(
            title: "Login Error",
            content: responseBody["message"],
            context: context,
          );
        }
      } else {
        // Handle non-200 response codes
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Error Response: ${response.statusCode} ${response.body}");

        bloc.changeIsLoading(false);

        Globals.warningsAlerts(
          title: "Login Error",
          content: responseBody["message"] ?? "An error occurred",
          context: context,
        );
      }
    } catch (e) {
      // Handle errors during the request (e.g. network issues)
      bloc.changeIsLoading(false);

      // Log the error for debugging purposes
      print("Error during login: $e");

      // Show an alert to the user about the error
      Globals.warningsAlerts(
        title: "Login Error",
        content: "Something went wrong. Please try again later.",
        context: context,
      );
    }
  }


}
