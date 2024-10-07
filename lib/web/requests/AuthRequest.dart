import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/HomePageWeb.dart';
import 'package:itx/web/authentication/OtpVerification.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:itx/web/uplaodDocs.dart/GlobalExchange.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class WebAuthrequest {
  // Base URL for the API
  static const main_url = "http://185.141.63.56:3067/api/v1";
// grace  // "http://192.168.100.56:3000/api/v1"
  // "http://192.168.100.8:3000/api/v1"
  // "http://185.141.63.56:3067/api/v1";

  // Register request
  static Future<void> register({
    required BuildContext context,
    required Map<String, dynamic> body,
    required bool isOnOtp,
  }) async {
    final Webbloc bloc = Provider.of<Webbloc>(context, listen: false);
    print(body);
    print(body.runtimeType);
    print(jsonEncode(body).runtimeType);
    print(jsonEncode(body));

    try {
      final Uri url = Uri.parse("$main_url/user/register");

      // Start the loading state
      bloc.changeIsLoading(true);

      // Define headers for the request
      var headers = {
        'Content-Type': 'application/json',
      };

      // Create the request body
      final Map<String, dynamic> requestBody = {
        "api": 2,
        "email": body["email"],
        "phonenumber":
            body["phonenumber"], // Ensure field matches backend requirements
        "user_type": body["user_type"],
        "password": body["password"],
      };

      // Send the request using http.Request to manage streaming
      var request = http.Request('POST', url);
      request.body = jsonEncode(requestBody);
      request.headers.addAll(headers);

      // Handle the streamed response
      http.StreamedResponse streamedResponse = await request.send();

      // Await full response after stream
      final http.Response response =
          await http.Response.fromStream(streamedResponse);

      print("Response Status: ${response.statusCode}");

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["rsp"] == true) {
          // Successful response handling
          bloc.getUserType(body["user_type"]);
          print("userType ----- ${bloc.user_type}");

          bloc.changeIsLoading(false);

          if (isOnOtp) {
            CherryToast.success(
              title: Text("OTP resent successfully"),
            ).show(context);
          } else {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => WebOtpVerification(
                  isRegistered: false,
                  phoneNumber: body["phonenumber"],
                ),
              ),
            );
          }
        } else {
          // Handle the failure response from backend
          print("Request failed: ${responseBody["message"]}");
          bloc.changeIsLoading(false);
          _showErrorDialog(
            context,
            "${isOnOtp ? "RESEND OTP ERROR" : "Registration"} Error",
            responseBody["message"],
          );
        }
      } else {
        // Handle non-200 response codes
        print("Error Response: ${response.body}");
        final Map<String, dynamic> _body = jsonDecode(response.body);
        String message = _body["message"] == "User already exists"
            ? "User with email ${body["email"]} already exists"
            : _body["message"];
        bloc.changeIsLoading(false);
        _showErrorDialog(context, "Registration Error", message);
      }
    } catch (e) {
      // Catch and handle exceptions
      print("Error during registration: $e");
      bloc.changeIsLoading(false);
      _showErrorDialog(
        context,
        "Registration Error",
        "An unexpected error occurred. Please try again. $e",
      );
    } finally {
      // End loading state
      bloc.changeIsLoading(false);
    }
  }

  static void _showErrorDialog(
      BuildContext context, String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth:
                      400, // Set a max width for the dialog (adjust as needed)
                ),
                child: AlertDialog(
                  backgroundColor: Colors.white, // Set background color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15), // Rounded corners
                  ),
                  title: Text(
                    title,
                    style: const TextStyle(
                      color: Colors.red, // Title color
                      fontSize: 20, // Title size
                      fontWeight: FontWeight.bold, // Bold title
                    ),
                  ),
                  content: Text(
                    message,
                    style: const TextStyle(
                      color: Colors.black54, // Message text color
                      fontSize: 16, // Message font size
                    ),
                  ),
                  actions: <Widget>[
                    Center(
                      child: TextButton(
                        style: TextButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 10),
                          backgroundColor:
                              Colors.redAccent, // Button background
                          shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.circular(10), // Button shape
                          ),
                        ),
                        child: const Text(
                          'OK',
                          style: TextStyle(
                            color: Colors.white, // Button text color
                            fontSize: 16, // Button text size
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  static Future<List<Map<String, dynamic>>> fetchCommodities(
      BuildContext context) async {
    try {
      final Uri uri = Uri.parse("$main_url/commodities");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<Webbloc>(context, listen: false).token,
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

  static Future<void> login({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    final Webbloc bloc = context.read<Webbloc>();
    try {
      // Prepare the request body for login
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
      };

      //     final Map<String, dynamic> boddy = {
      //   "api":2,
      //   "email": "bobbymbogo711@gmail.com",
      //   "password": "1234567",
      //   "phonenumber": "0769922984",
      //   "user_type": 3.toString(),
      // };

      // Define the login endpoint
      final Uri url = Uri.parse("$main_url/user/login");

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
          Map<String, int> userTypeMap = {
            "individual": 3,
            "producer": 4,
            "trader": 5
          };
          int type = userTypeMap[responseBody["user_type"]] ?? 6;
          int id = responseBody["user_id"];
          int isAuthorized = responseBody["authorized"];
          print(
              "user type id  ----$type----------------------------------------------");
          print("isAuthorized status --------------------$isAuthorized");

          // Update the bloc with new state
          bloc.changeIsLoading(false);
          bloc.changeToken(token);
          bloc.getUserType(type);

          bloc.changeUser(email);
          bloc.changeCurrentUserID(id: id);
          bloc.changeIsAuthorized(isAuthorized);

          // Switch screens upon successful login

          Globals.switchScreens(
              context: context,
              screen: WebOtpVerification(
                isRegistered: true,
              )

              // Verification(
              //   context: context,
              //   email: email,
              //   phoneNumber: null,
              //   isRegistered: true,
              // )
              );

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

  static Future<void> WebResendOtp({
    required BuildContext context,
  }) async {
    final Webbloc bloc = context.read<Webbloc>();
    final Uri url = Uri.parse("$main_url/user/otp");
    final String token = Provider.of<Webbloc>(context, listen: false).token;

    final Map<String, dynamic> body =
        Provider.of<Webbloc>(context, listen: false).userDetails;
    print(body);

    try {
      // Start loading state
      bloc.changeIsLoading(true);

      // Send get  request for OTP verification
      final http.Response response = await http.get(
        url,
        headers: {"x-auth-token": token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("${response.body} success");
        final Map responseBody = jsonDecode(response.body);

        if (responseBody["rsp"]) {
          Globals().successAlerts(
              title: "Verification",
              content: "Code is being Sent",
              context: context);

          final String token = responseBody["token"];
          context.read<Webbloc>().changeToken(token);

          // Delay navigation for a few seconds for better UX
          Future.delayed(Duration(seconds: 3));
          // Globals.switchScreens(context: context, screen: GlobalsHomePage());

          bloc.changeIsLoading(false); // Stop loading after success
        } else {
          // Show an authentication error if OTP fails
          Globals.warningsAlerts(
            title: "Otp Error",
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

  static Future<void> WebOtp({
    required BuildContext context,
    required String email,
    required String otp,
    required bool isRegistered,
  }) async {
    final Webbloc bloc = context.read<Webbloc>();

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
          context.read<Webbloc>().changeToken(token);

          // Delay navigation for a few seconds for better UX
          Future.delayed(Duration(seconds: 3));

          if (bloc.user_type == 6) {
            Globals.switchScreens(
                context: context,
                screen: isRegistered
                    ? HomePageWeb(title: "Home")
                    : TradeAuthorizationStatusScreen());
          } else {
            Globals.switchScreens(
                context: context,
                screen: isRegistered
                    ? HomePageWeb(title: "Home")
                    : TradeAuthorizationStatusScreen());
          }
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
}
