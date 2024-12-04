import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:itx/ContSerilizers/CntForwards.dart';
import 'package:itx/ContSerilizers/CntFutures.dart';
import 'package:itx/ContSerilizers/CntOptions.dart';
import 'package:itx/ContSerilizers/CntSwap.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/testlab/html%F0%9F%98%82.dart';

class ContractTemplete extends StatefulWidget {
  final int contractTypeId;
  final Map<String,dynamic> filledData;

  const ContractTemplete(
      {super.key, required this.contractTypeId, required this.filledData});

  @override
  _ContractTempleteState createState() => _ContractTempleteState();
}

class _ContractTempleteState extends State<ContractTemplete> {
  String _htmlContent = '';
  bool _isLoading = true;
  String _contractName = "";

  @override
  void initState() {
    super.initState();
    contractName();
    _fetchAndProcessHTML();
  }

  void helperSetState(value) {
    setState(() {
      _contractName = value;
    });
  }

  void contractName() {
    final type = widget.contractTypeId;
    switch (type) {
      case 1:
        helperSetState("Futures Contract");
      case 2:
        helperSetState("Forward Contract");
      case 3:
        helperSetState("Options Contract");
      case 4:
        helperSetState("Swaps Contract");

        break;
      default:
    }
  }

  Future<void> _fetchAndProcessHTML() async {
    try {
      // Fetch HTML from server
      print("endpoint $grace_html");
      final response = await http.get(Uri.parse(
          '${grace_html}${widget.contractTypeId.toString()}/template'));
      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        // Parse the HTML
        dom.Document document = parse(response.body);

        // Manipulate the HTML (example modifications)
        _modifyHTML(document);
        print(document.outerHtml);

        // Convert back to string
        setState(() {
          _htmlContent = document.outerHtml;
          _isLoading = false;
        });
      } else {
        _handleError('Failed to load HTML');
      }
    } catch (e) {
      _handleError('Error fetching HTML: $e');
    }
  }

  void _modifyHTML(dom.Document document,) {
  
    widget.filledData.forEach((id, value) {
      if (value == null) {
        print("--------------$value is null");
      } else if (id == null) {
        print("--------------$id is null");
      }

      print("$id: $value");
    });

    // Loop through the map and modify elements in the document
    widget.filledData.forEach((id, value) {
      var element = document.getElementById(id);
      if (element != null) {
        element.text = value; // Replace placeholder text with actual value
        element.attributes['style'] =
            'color: black; font-size: 14px;'; // Apply styling
      }
    });
  }

  void _handleError(String message) {
    setState(() {
      _htmlContent = message;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_contractName ?? ""),
      ),
      body: _isLoading
          ? Center(child: loading)
          : Container(
              width: MediaQuery.of(context).size.width * 0.8,
              child: SingleChildScrollView(
                child: Html(
                  data: _htmlContent,
                  style: {
                    'body': Style(
                      backgroundColor: Colors.white,
                      padding: HtmlPaddings.all(4),
                    ),
                  },
                  // Optional: Handle link taps
                  onLinkTap: (url, context, attributes) {
                    // Implement link handling logic
                    print('Tapped on: $url');
                  },
                ),
              ),
            ),
    );
  }
}
