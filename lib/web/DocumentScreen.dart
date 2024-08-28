import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class DocumentsScreen extends StatefulWidget {
  @override
  _DocumentsScreenState createState() => _DocumentsScreenState();
}

class _DocumentsScreenState extends State<DocumentsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Documents',
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 24),
              Text(
                'Identity Verification',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              _buildDocumentTile(
                  'Government ID', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Proof of Address', 'Approved', 'Expires 02-28-2023'),
              _buildDocumentTile(
                  'Selfie', 'Approved', 'Expires 02-28-2024'),
              SizedBox(height: 24),
              Text(
                'Business Verification',
                style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
              ),
              SizedBox(height: 16),
              _buildDocumentTile(
                  'Organization Documents', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Ownership Structure', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Operating Agreement', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Good Standing Certificate', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Tax ID Verification', 'Approved', 'Expires 12-31-2023'),
              _buildDocumentTile(
                  'Authorized Signers', 'Approved', 'Expires 12-31-2023'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDocumentTile(String title, String status, String expiryDate) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        leading: Icon(Icons.description, color: Colors.blue),
        title: Text(
          title,
          style: GoogleFonts.poppins(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              status,
              style: TextStyle(
                color: status == 'Approved' ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
            Text(
              expiryDate,
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.chevron_right),
          onPressed: () {
            // Handle button press
          },
        ),
        onTap: () {
          // Handle list tile tap
        },
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DocumentsScreen(),
  ));
}
