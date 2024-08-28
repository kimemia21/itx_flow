import 'package:flutter/material.dart';

class DocumentsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          // Left sidebar
          Container(
            width: 200,
            color: Colors.grey[100],
            child: ListView(
              children: [
                ListTile(
                  leading: Icon(Icons.dashboard),
                  title: Text('Dashboard'),
                ),
                ListTile(
                  leading: Icon(Icons.swap_horiz),
                  title: Text('Trade'),
                ),
                ListTile(
                  leading: Icon(Icons.account_balance_wallet),
                  title: Text('Funding'),
                ),
                ListTile(
                  leading: Icon(Icons.description),
                  title: Text('Documents', style: TextStyle(fontWeight: FontWeight.bold)),
                ),
                ListTile(
                  leading: Icon(Icons.person),
                  title: Text('Profile'),
                ),
              ],
            ),
          ),
          // Main content
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Documents', style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(height: 24),
                  Text('Identity Verification', style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(height: 16),
                  _buildDocumentTile('Government ID', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Proof of Address', 'Expired', 'Expires 02-28-2023'),
                  _buildDocumentTile('Selfie', 'Approved', 'Expires 02-28-2024'),
                  SizedBox(height: 24),
                  Text('Business Verification', style: Theme.of(context).textTheme.displayLarge),
                  SizedBox(height: 16),
                  _buildDocumentTile('Organization Document', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Ownership Structure', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Operating Agreement', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Good Standing Certificate', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Tax ID Verification', 'Approved', 'Expires 12-31-2023'),
                  _buildDocumentTile('Authorized Signers', 'Approved', 'Expires 12-31-2023'),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDocumentTile(String title, String status, String expiryDate) {
    return ListTile(
      leading: Icon(Icons.description, color: Colors.blue),
      title: Text(title),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(status, style: TextStyle(color: status == 'Approved' ? Colors.green : Colors.red)),
          Text(expiryDate, style: TextStyle(color: Colors.grey)),
        ],
      ),
      trailing: Icon(Icons.chevron_right),
    );
  }
}