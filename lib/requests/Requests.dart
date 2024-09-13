import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:provider/provider.dart';

class AuthRequest {
  // Base URL for the API
  static final main_url = "http://185.141.63.56:3067/api/v1/user";

  // Register request
  static Future<void> register({
    required BuildContext context,
    required String email,
    required String password,
    required String phoneNumber,
    required String user_type,
  }) async {
    // Retrieve the appBloc instance for managing the loading state
    final appBloc bloc = context.read<appBloc>();

    try {
      // Prepare the request body
      final Map<String, dynamic> body = {
        "email": email,
        "password": password,
        "phonenumber": phoneNumber,
        "user_type": "1",
      };
      // print(body);

      // Define the endpoint for registration
      final Uri url = Uri.parse("$main_url/register");

      // Start loading state
      bloc.changeIsLoading(true);

      // Send POST request to register the user
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status: ${response.statusCode}");

      // Handle success response (status code 200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);

        if (responseBody["rsp"] == true) {
          // Registration is successful, navigate to verification screen
          print("Success: ${responseBody["message"]}");
          bloc.changeIsLoading(false); // Stop loading after success

          Globals.switchScreens(
            context: context,
            screen: Verification(
              context: context,
              email: email,
              phoneNumber: phoneNumber,
            ),
          );
        } else {
          // Handle failure case (incorrect data, etc.)
          print("Request failed: ${responseBody["message"]}");
          Globals.warningsAlerts(
            title: "Registration Error",
            content: responseBody["message"],
            context: context,
          );
          bloc.changeIsLoading(false); // Stop loading after failure
        }
      } else {
        // Handle non-200 response status codes
        print("Error Response: ${response.body}");
        final body = jsonDecode(response.body) as Map;
        String message = "";

        // Custom message for "User already exists" case
        if (body["message"] == "User already exists") {
          message = "User with email $email already exists";
        } else {
          message = body["message"];
        }

        // Show warning alert with the error message
        Globals.warningsAlerts(
          title: "Registration Error",
          content: message,
          context: context,
        );
        bloc.changeIsLoading(false); // Stop loading after failure
      }
    } catch (e) {
      // Handle errors during the request
      print("Error during registration: $e");
      bloc.changeIsLoading(false); // Stop loading after failure
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
    final Uri url = Uri.parse("$main_url/otpc");

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
          Globals.switchScreens(context: context, screen: GlobalsHomePage());

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
      final Uri url = Uri.parse("$main_url/login");

      // Start loading state
      bloc.changeIsLoading(true);

      // Send POST request to login the user
      final http.Response response = await http.post(
        url,
        body: jsonEncode(body),
        headers: {'Content-Type': 'application/json'},
      );

      print("Response Status: ${response.statusCode}");

      // Handle success response (status code 200)
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        String token = responseBody["token"];
        String type = responseBody["user_type"];
        print(token);

        if (responseBody["rsp"] == true) {
          // Update state to indicate successful login
          bloc.changeIsLoading(false);
          bloc.changeToken(token);
          bloc.getUserType(type);
          Globals.switchScreens(context: context, screen: GlobalsHomePage());
          print("Success: ${responseBody["message"]}");
        } else {
          // Handle failure case (incorrect login details, etc.)
          print("Request failed: ${responseBody["message"]}");
        }
      } else {
        // Handle non-200 response status codes
        final Map<String, dynamic> responseBody = jsonDecode(response.body);
        print("Error Response: ${response.body}");
        // if (responseBody["message"] == "OTP not yet verifed") {
        //   Future.delayed(Duration(seconds: 2));
        //   Globals.switchScreens(
        //       context: context,
        //       screen: Verification(
        //           context: context, email: email, phoneNumber: phoneNumber));
        // }

        // Update state to indicate login failure
        bloc.changeIsLoading(false);
        Globals.warningsAlerts(
          title: "Login Error",
          content: responseBody["message"],
          context: context,
        );
      }
    } catch (e) {
      // Handle errors during login request
      print("Error during login: $e");

      // Update state to indicate login failure
      bloc.changeIsLoading(false);
    }
  }
}
