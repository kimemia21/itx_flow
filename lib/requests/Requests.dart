import 'dart:convert';
import 'package:cherry_toast/cherry_toast.dart';
import 'package:cherry_toast/resources/arrays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Serializers/CommoditesCerts.dart';
import 'package:itx/Serializers/UserTypes.dart';
import 'package:itx/uploadCerts/Regulator.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class AuthRequest {
  // Base URL for the API
  static const main_url = "http://185.141.63.56:3067/api/v1";
// grace  // "http://192.168.100.56:3000/api/v1"
  // "http://192.168.100.8:3000/api/v1"
  // "http://185.141.63.56:3067/api/v1";

  // Register request
  static Future<void> register(
      {required BuildContext context,
      required Map<String, dynamic> body,
      required bool isOnOtp}) async {
    final appBloc bloc = Provider.of<appBloc>(context, listen: false);
    print(body);

    try {
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
          isOnOtp ? null : bloc.getUserType(body["user_type"]);
          bloc.changeIsLoading(false);
          isOnOtp
              ? CherryToast.success(
                  title: Text("Opt resent Succesfully"),
                ).show(context)
              : Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Verification(
                      isRegistered: false,
                      context: context,
                      email: body["email"],
                      phoneNumber: body["phonenumber"],
                    ),
                  ),
                );
        } else {
          print("Request failed: ${responseBody["message"]}");
          bloc.changeIsLoading(false);
          _showErrorDialog(
              context,
              " ${isOnOtp ? "RESEND OTP ERROR" : "Registration"} Error",
              responseBody["message"]);
        }
      } else {
        bloc.changeIsLoading(false);
        print("Error Response: ${response.body}");
        final _body = jsonDecode(response.body) as Map;
        String message = _body["message"] == "User already exists"
            ? "User with email ${body["email"]}  already exists"
            : _body["message"];
        _showErrorDialog(context, "Registration Error", message);
      }
    } catch (e) {
      print("Error during registration: $e");
      _showErrorDialog(context, "Registration Error",
          "An unexpected error occurred. Please try again $e.");
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
    required List<int> commodities,
  }) async {
    final appBloc bloc = context.read<appBloc>();

    bloc.changeIsLoading(true);
    // Start loading state at the beginning

    try {
      int user_type = Provider.of<appBloc>(context, listen: false).user_type;
      print("user_type --------------------------$user_type");
      // Prepare the request body
      final Map<String, dynamic> body = {
        "commodities": commodities.join(","),
        "user_type_id": user_type
      };

      bloc.changeUserCommoditesIds(commodities);

      final Uri url = Uri.parse("$main_url/commodities/certs");
      print(Provider.of<appBloc>(context, listen: false).token);
      // Send POST request to the API

      // editted token for testing
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
          print("Success: ${responseBody["data"]}");
          final List<dynamic> body = responseBody["data"];

//           final List<CommCert> mapper =
//               body.map((element) => CommCert.fromJson(element)).toList();
// // getting the commodity response and saving it to state when this enpoint is called

//           bloc.changeCommCert(mapper);

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

        _handleError(context, "Commodites of interest", errorMessage);
      }
    } catch (e) {
      // Handle exceptions during the request or response parsing
      print("Error during commodites of interest : $e");
      _handleError(context, "Commodites  Error", "$e");
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

  static Future createOrder(BuildContext context, bid, int id) async {
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
      CherryToast.success(
        title: Text("Oder Confirmed"),
        description: Text(
          'You should pay within 10 days to receive an invoice via email.',
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
        animationType: AnimationType.fromRight,
        animationDuration: Duration(milliseconds: 1000),
        autoDismiss: true,
      ).show(context);
      Navigator.of(context).pop();
      PersistentNavBarNavigator.pushNewScreen(
          withNavBar: true, context, screen: UserOrdersScreen());

      // if (responseBody.toString().contains("true")) {
      //   // Show an authentication error if OTP fails
      //   Globals.warningsAlerts(
      //     title: "Highest Bidder",
      //     content: responseBody["msg"],
      //     context: context,
      //   );
      // } else {
      //   // Show an authentication error if OTP fails
      //   Globals.warningsAlerts(
      //     title: "bidding  Error",
      //     content: responseBody["rsp"],
      //     context: context,
      //   );
      // }
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

  static Future<List<UserTypeModel>> getUserType(BuildContext context) async {
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
  static Future<void> ResendOtp({
    required BuildContext context,
  }) async {
    final appBloc bloc = context.read<appBloc>();
    final Uri url = Uri.parse("$main_url/user/otp");
    final String token = Provider.of<appBloc>(context, listen: false).token;
    final Map<String, dynamic> body =
        Provider.of<appBloc>(context, listen: false).userDetails;
    print(body);

    try {
      // Start loading state
      bloc.changeIsLoading(true);

      // Send POST request for OTP verification
      final http.Response response = await http.get(
        url,

        // body: jsonEncode(body),
        headers: {"x-auth-token": token, 'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        print("${response.body} success");
        final Map responseBody = jsonDecode(response.body);

        if (responseBody["rsp"]) {
          Globals().successAlerts(
              title: "Verification OTP", content: "", context: context);

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

  static Future<void> otp({
    required BuildContext context,
    required String email,
    required String otp,
    required bool isRegistered,
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
          Globals.switchScreens(
              context: context,
              screen: isRegistered ? GlobalsHomePage() : Commodities());

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
              screen: Verification(
                context: context,
                email: email,
                phoneNumber: null,
                isRegistered: true,
              ));

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




  static Future<GoogleSignInAccount?> signInWithGoogle() async {
    final GoogleSignIn googleSignIn = GoogleSignIn();
    try {
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      return googleUser;
    } catch (error) {
      print("Error during Google Sign In: $error");
      return null;
    }
  }

  static Future<void> registerWithGoogle({
    required BuildContext context,
  }) async {
    final appBloc bloc = Provider.of<appBloc>(context, listen: false);

    try {
      bloc.changeIsLoading(true);

      // Initialize GoogleSignIn
      final GoogleSignIn googleSignIn = GoogleSignIn();

      print("Attempting Google Sign-In");

      try {
        final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

        if (googleUser == null) {
          print("Google Sign-In returned null user");
          throw Exception('Google Sign-In failed: No user data received');
        }

        print("Google Sign-In successful. User: ${googleUser.email}");

        // Get auth details from request
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        // Create credential
        final OAuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        // Sign in to Firebase with credential
        final UserCredential userCredential =
            await FirebaseAuth.instance.signInWithCredential(credential);
        final User? user = userCredential.user;

        if (user == null) {
          throw Exception('Firebase Sign-In failed: No user data received');
        }

        // Prepare the request body for registration
        final Map<String, dynamic> body = {
          "email": user.email,
          "name": user.displayName,
          "auth_provider": "google",
          "google_id": user.uid,
          "user_type": 1,
          "phone": user.phoneNumber ??
              "0769922984", // Use Firebase phone if available, else default
        };

        final Uri url = Uri.parse("$main_url/user/register");

        print("Sending registration request to: $url");
        final http.Response response = await http.post(
          url,
          body: jsonEncode(body),
          headers: {'Content-Type': 'application/json'},
        );

        print("Response Status: ${response.statusCode}");
        print("Response Body: ${response.body}");

        if (response.statusCode == 200) {
          final Map<String, dynamic> responseBody = jsonDecode(response.body);

          if (responseBody["rsp"] == true) {
            print("Registration successful: ${responseBody["message"]}");
            bloc.getUserType(responseBody["user_type"]);
            bloc.changeIsLoading(false);
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Verification(
                  isRegistered: false,
                  context: context,
                  email: user.email!,
                  phoneNumber: user.phoneNumber,
                ),
              ),
            );
          } else {
            print("Registration failed: ${responseBody["message"]}");
            _showErrorDialog(
                context, "Registration Error", responseBody["message"]);
          }
        } else {
          print("Non-200 response: ${response.statusCode}");
          final Map<String, dynamic> responseBody = jsonDecode(response.body);
          String message = responseBody["message"] ?? "An error occurred";
          _showErrorDialog(context, "Registration Error", message);
        }
      } on FirebaseAuthException catch (e) {
        print("FirebaseAuthException: ${e.code} - ${e.message}");
        _showErrorDialog(context, "Authentication Error",
            "An error occurred during Google Sign-In: ${e.message}");
      } on PlatformException catch (e) {
        print("PlatformException: ${e.code} - ${e.message}");
        _showErrorDialog(context, "Platform Error",
            "An error occurred with the platform: ${e.message}");
      }
    } catch (e) {
      print("Unexpected error during registration: $e");
      _showErrorDialog(context, "Registration Error",
          "An unexpected error occurred during registration. Please try again later.");
    } finally {
      bloc.changeIsLoading(false);
    }
  }
}
