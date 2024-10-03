import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';
import 'package:itx/Serializers/CommCert.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';


class Regulators extends StatelessWidget {
  final List<CommoditiesCert>? commCerts; // List of CommoditiesCert objects

  Regulators({Key? key, this.commCerts}) : super(key: key);

  void navigateToCertificateForm(BuildContext context, CommoditiesCert certificate) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CertificateFormScreen(certificate: certificate),
      ),
    );
  }

    Widget _buildNoCommoditiesMessage(context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "Please Select Commodities to be able to upload certs",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Globals.switchScreens(context: context, screen: Commodities(isWareHouse: false,));
            },
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              backgroundColor: Colors.green.shade800,
            ),
            child: const Text(
              "Select Commodities",
              style: TextStyle(
                fontSize: 16,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        centerTitle: true,
        title: Text('Regulators', style: GoogleFonts.poppins(color: Colors.white)),
      ),
      body:commCerts!=null?
      
       ListView.builder(
        itemCount: commCerts!.length,
        itemBuilder: (context, index) {
          CommoditiesCert cert = commCerts![index];
          return ListTile(
            title: Text(cert.certificateName ?? 'Unnamed Certificate'),
            subtitle: Text(cert.authorityName ?? 'Unknown Authority'),
            onTap: () => navigateToCertificateForm(context, cert),
          );
        },
      ):_buildNoCommoditiesMessage(context)
      ,
    );
  }
}

class CertificateFormScreen extends StatelessWidget {
  final CommoditiesCert certificate;

  CertificateFormScreen({required this.certificate});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text(certificate.certificateName ?? 'Certificate Details'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Authority: ${certificate.authorityName ?? 'Unknown'}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                  // Implement file upload logic
                },
                child: Text('Upload ${certificate.certificateName ?? 'Certificate'}'),
              ),
              if (certificate.proofOfPaymentRequired == 1) ...[
                SizedBox(height: 8),
                ElevatedButton(
                  onPressed: () {
                    // Implement proof of payment upload logic
                  },
                  child: Text(
                    'Upload Proof of Payment' +
                    (certificate.certificateFee != null
                        ? ' (Fee: ${certificate.certificateFee})'
                        : '')
                  ),
                ),
              ],
              SizedBox(height: 16),
              TextFormField(
                decoration: InputDecoration(
                  labelText: 'Expiry Date',
                  suffixIcon: Icon(Icons.calendar_today),
                ),
                onTap: () {
                  // Implement date picker logic
                },
              ),
              if (certificate.certificateTtl != null) ...[
                SizedBox(height: 16),
                Text('Time to Live: ${certificate.certificateTtl} ${certificate.certificateTtlUnits ?? ''}'),
              ],
            ],
          ),
        ),
      ),
    );
  }
}