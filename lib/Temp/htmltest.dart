import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:html/parser.dart' show parse;
import 'package:html/dom.dart' as dom;
import 'package:flutter_html/flutter_html.dart';
import 'package:itx/ContSerilizers/CntSwap.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/testlab/html%F0%9F%98%82.dart';

class ContractTemplete extends StatefulWidget {
  final int contractTypeId;

  const ContractTemplete({super.key, required this.contractTypeId});



  @override
  _ContractTempleteState createState() => _ContractTempleteState();
}

class _ContractTempleteState extends State<ContractTemplete> {
  String _htmlContent = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchAndProcessHTML();
  }

  Future<void> _fetchAndProcessHTML() async {
    try {
      // Fetch HTML from server
      print("endpoint $grace_html");
      final response = await http.get(Uri.parse('${grace_html}'));
      print(response.body);

      if (response.statusCode == 200) {
        print(response.body);
        // Parse the HTML
        dom.Document document = parse(response.body);

        // Manipulate the HTML (example modifications)
        _modifyHTML(document, cntSwap);
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

  void _modifyHTML(dom.Document document, CntSwap contract) {

    // List of ids corresponding to the SwapContract attributes
    final idsToAttributes = {
      "agreement_date": contract.agreementDate,
      "party_a_name": contract.partyAName,
      "party_a_address": contract.partyAAddress,
      "party_a_contact_person": contract.partyAContactPerson,
      "party_a_email": contract.partyAEmail,
      "party_a_phone": contract.partyAPhone,
      "party_b_name": contract.partyBName,
      "party_b_address": contract.partyBAddress,
      "party_b_contact_person": contract.partyBContactPerson,
      "party_b_email": contract.partyBEmail,
      "party_b_phone": contract.partyBPhone,
    };

    // Loop through the map and modify elements in the document
    idsToAttributes.forEach((id, value) {
      var element = document.getElementById(id);
      if (element != null) {
        element.text = value; // Replace placeholder text with actual value
        element.attributes['style'] =
            'color: black; font-size: 14px;'; // Apply styling
      }
    });

    // // 3. Add new elements
    // var body = document.body;
    // if (body != null) {
    //   var newDiv = dom.Element.tag('div')
    //     ..attributes['class'] = 'custom-banner'
    //     ..text = 'Dynamically Added Content';
    //   body.insertBefore(newDiv, body.firstChild);
    // }

    // // 4. Modify links
    // var links = document.querySelectorAll('a');
    // for (var link in links) {
    //   link.attributes['target'] = '_blank'; // Open links in new tab
    // }
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
        title: Text('HTML Viewer'),
      ),
      body: _isLoading
          ? Center(child: loading)
          : Container(
            width: MediaQuery.of(context).size.width*0.8,
            child: SingleChildScrollView(
                child: Html(
                  data: _htmlContent,
                  style: {
                    // Custom styling for HTML rendering
                    'body': Style(
                      backgroundColor: Colors.white,
                      padding: HtmlPaddings.all(2),
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
