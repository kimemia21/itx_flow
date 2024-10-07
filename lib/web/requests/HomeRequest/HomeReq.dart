import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/Serializers/Commodity_types.dart';
import 'package:itx/Serializers/ContractType.dart';
import 'package:itx/authentication/Verification.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/HomePageWeb.dart';
import 'package:itx/web/authentication/OtpVerification.dart';
import 'package:itx/web/state/Webbloc.dart';
import 'package:itx/web/uplaodDocs.dart/GlobalExchange.dart';
import 'package:mockito/mockito.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class HomepageRequest {
  static const main_url = "http://185.141.63.56:3067/api/v1";

  static Future<List<ContractType>> GetContracts({
    required BuildContext context,
  }) async {
    final Webbloc bloc = context.read<Webbloc>();
    final Uri url = Uri.parse("$main_url/contracts/types");
    final String token = Provider.of<Webbloc>(context, listen: false).token;

    try {
    
      bloc.changeIsLoading(true);

      final http.Response response = await http.get(
        url,
        headers: {"x-auth-token": "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6MSwiaWF0IjoxNzI4Mjk2MDA2LCJleHAiOjE3MjgzMTQwMDZ9.ByCIW7IOoMVoLWYjiI0bVI7P4rTn6hhpx0sIdF68JbA", 
        'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        bloc.changeIsLoading(false);
        print("${response.body} success");
        final Map responseBody = jsonDecode(response.body);
        final List body = responseBody["data"];

        List<ContractType> mapper =
            body.map((json) => ContractType.fromJson(json)).toList();
        return mapper;
      } else {
        bloc.changeIsLoading(false);
        print("error in  GetContracts function ${response.body}");
        return [];
      }
    } catch (e) {
      bloc.changeIsLoading(false);
      // Handle errors during OTP request

      print("error in  GetContracts function $e");
      throw Exception("error in  GetContracts function $e");
    } finally {
      // Stop loading state
      bloc.changeIsLoading(false);
    }
  }
}
