import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Regulators extends StatefulWidget {
  const Regulators({super.key});

  @override
  State<Regulators> createState() => _RegulatorsState();
}

class _RegulatorsState extends State<Regulators> {
  final TextEditingController _documentController = TextEditingController();
  final TextEditingController _expiryDateController = TextEditingController();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        _expiryDateController.text = "${picked.toLocal()}".split(' ')[0];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Upload your documents'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Upload your documents',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text('Document', style: GoogleFonts.poppins(fontSize: 16)),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _documentController,
                    decoration: InputDecoration(
                      hintText: 'Document description',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 10),
                IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    // Add your action here for the camera button
                  },
                ),
              ],
            ),
            SizedBox(height: 20),
            Text('Expiry date', style: GoogleFonts.poppins(fontSize: 16)),
            TextField(
              controller: _expiryDateController,
              decoration: InputDecoration(
                hintText: 'Select date',
                border: OutlineInputBorder(),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 30),
            Text(
              'Documents uploaded',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView(
                children: [
                  _buildUploadedDocument('04/30/2023'),
                  _buildUploadedDocument('02/22/2022'),
                  _buildUploadedDocument('01/14/2024'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildUploadedDocument(String date) {
    return ListTile(
      title: Text('Expiry date: $date', style: GoogleFonts.poppins(fontSize: 16)),
      trailing: Icon(Icons.check_circle, color: Colors.green),
    );
  }
}

