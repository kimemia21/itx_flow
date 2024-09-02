import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:file_picker/file_picker.dart';
import 'package:intl/intl.dart';

class TradingCertificate {
  final int userHasCommodityId;
  int? certAuthorityId;
  String? certificate;
  DateTime? certExpiryDate;
  String? proofOfPayment;
  bool isValid = true;

  TradingCertificate({required this.userHasCommodityId});
}

class Regulators extends StatefulWidget {
  final List<Map<String, dynamic>> userCommodities;

  const Regulators({Key? key, required this.userCommodities}) : super(key: key);

  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  late List<TradingCertificate> certificates;

  // Mock data for authorities (replace with actual data from your backend)
  final Map<int, String> _authorities = {
    1: 'Coffee Authority A',
    2: 'Coffee Authority B',
    3: 'Tea Authority A',
    4: 'Tea Authority B',
  };

  @override
  void initState() {
    super.initState();
    certificates = widget.userCommodities
        .map((commodity) => TradingCertificate(userHasCommodityId: commodity['id']))
        .toList();
  }

  Future<void> _selectDate(BuildContext context, int index) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: certificates[index].certExpiryDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != certificates[index].certExpiryDate) {
      setState(() {
        certificates[index].certExpiryDate = picked;
      });
    }
  }

  Future<void> _pickFile(int index, bool isCertificate) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(type: FileType.any);

    if (result != null && result.files.isNotEmpty) {
      setState(() {
        if (isCertificate) {
          certificates[index].certificate = result.files.first.name;
        } else {
          certificates[index].proofOfPayment = result.files.first.name;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add Trading Certificates', style: GoogleFonts.poppins(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [Colors.blue[50]!, Colors.blue[100]!],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ListView.builder(
                  itemCount: certificates.length,
                  itemBuilder: (context, index) {
                    final commodity = widget.userCommodities[index];
                    return Card(
                      elevation: 4,
                      margin: EdgeInsets.symmetric(vertical: 8),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '${commodity['name']}',
                              style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Authority',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            DropdownButtonFormField<int>(
                              value: certificates[index].certAuthorityId,
                              items: _authorities.entries
                                  .map<DropdownMenuItem<int>>(
                                    (entry) => DropdownMenuItem<int>(
                                      value: entry.key,
                                      child: Text(entry.value),
                                    ),
                                  )
                                  .toList(),
                              onChanged: (int? newValue) {
                                setState(() {
                                  certificates[index].certAuthorityId = newValue;
                                });
                              },
                              decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Certificate URL',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: TextEditingController(text: certificates[index].certificate),
                              onChanged: (value) => certificates[index].certificate = value,
                              decoration: InputDecoration(
                                hintText: 'Enter or upload certificate URL',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => _pickFile(index, true),
                              icon: Icon(Icons.upload_file),
                              label: Text('Upload Certificate'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Expiry Date',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: TextEditingController(
                                text: certificates[index].certExpiryDate != null
                                    ? DateFormat('yyyy-MM-dd').format(certificates[index].certExpiryDate!)
                                    : '',
                              ),
                              decoration: InputDecoration(
                                hintText: 'Select date',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                                suffixIcon: Icon(Icons.calendar_today),
                              ),
                              readOnly: true,
                              onTap: () => _selectDate(context, index),
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Proof of Payment URL',
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            TextField(
                              controller: TextEditingController(text: certificates[index].proofOfPayment),
                              onChanged: (value) => certificates[index].proofOfPayment = value,
                              decoration: InputDecoration(
                                hintText: 'Enter or upload proof of payment URL',
                                border: OutlineInputBorder(),
                                filled: true,
                                fillColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 10),
                            ElevatedButton.icon(
                              onPressed: () => _pickFile(index, false),
                              icon: Icon(Icons.upload_file),
                              label: Text('Upload Proof of Payment'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                foregroundColor: Colors.white,
                              ),
                            ),
                            SizedBox(height: 20),
                            Row(
                              children: [
                                Text(
                                  'Valid Certificate',
                                  style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.bold),
                                ),
                                Switch(
                                  value: certificates[index].isValid,
                                  onChanged: (bool value) {
                                    setState(() {
                                      certificates[index].isValid = value;
                                    });
                                  },
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: ElevatedButton(
                  onPressed: () {
                    // Handle form submission
                    // You can access the data for each certificate in the 'certificates' list
                    for (var cert in certificates) {
                      print('User Has Commodity ID: ${cert.userHasCommodityId}');
                      print('Authority ID: ${cert.certAuthorityId}');
                      print('Certificate: ${cert.certificate}');
                      print('Expiry Date: ${cert.certExpiryDate}');
                      print('Proof of Payment: ${cert.proofOfPayment}');
                      print('Is Valid: ${cert.isValid}');
                      print('---');
                    }
                    // Here you would typically send this data to your backend
                  },
                  child: Text('Submit'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                    textStyle: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}