import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;

class ContractTypeRequest {
  static String mainUri = "http://185.141.63.56:3067/api/v1";

  // Fetch only the 'id' and 'name' fields from the Contract
  static Future<List<Map<String, dynamic>>> fetchContract(BuildContext context) async {
    try {
      final Uri uri = Uri.parse("$mainUri/contracts/types");
      final Map<String, String> headers = {
        "Content-Type": "application/json",
        "x-auth-token": Provider.of<appBloc>(context, listen: false).token,
      };

      final response = await http.get(uri, headers: headers);

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);

        if (responseData['rsp'] == true) {
          List<dynamic> contractTypeJson = responseData['data'];

          // Return only a list of maps with id and name
          List<Map<String, dynamic>> contractType = contractTypeJson
              .map((contract) => {
                    "id": contract["id"],
                    "contract_type": contract["contract_type"],
                  })
              .toList();

          return contractType;
        } else {
          throw Exception('Failed to fetch contract type: ${responseData['msg']}');
        }
      } else {
        throw Exception('Failed to fetch contract type');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('An error occurred while fetching contract type: $e');
    }
  }
}