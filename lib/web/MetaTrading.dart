import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class Metatrading extends StatefulWidget {
  @override
  _MetatradingState createState() => _MetatradingState();
}

class _MetatradingState extends State<Metatrading> {
  String? _selectedOption;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Icon(Icons.trending_up),
            SizedBox(width: 8),
            Text(
              'Futures',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Handle navigation to MetaTrader
            },
            child: Text(
              'Go to MetaTrader',
              style: GoogleFonts.roboto(color: Colors.black, fontSize: 16),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Trade futures on the platform you love',
              style: GoogleFonts.roboto(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 24),
            _buildRadioOption(
              title: 'MetaTrader 4 & 5',
              subtitle: 'The industry standard for professional traders',
              value: 'MetaTrader',
            ),
            SizedBox(height: 24),
            _buildRadioOption(
              title: 'ITX.io',
              subtitle: 'No need to leave the platform to trade',
              value: 'ITX.io',
            ),
            SizedBox(height: 40),
            Text(
              'How it works',
              style: GoogleFonts.roboto(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _buildHowItWorksCard(
                    icon: Icons.link,
                    title: '1. Connect your MetaTrader account',
                    description: 'Connect your account and start trading in minutes',
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: _buildHowItWorksCard(
                    icon: Icons.swap_horiz,
                    title: '2. Trade directly from the platform',
                    description: 'Place orders, manage positions, and view real-time data',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRadioOption({required String title, required String subtitle, required String value}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
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
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Radio<String>(
              value: value,
              groupValue: _selectedOption,
              onChanged: (String? newValue) {
                setState(() {
                  _selectedOption = newValue;
                });
              },
            ),
            SizedBox(width: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
                ),
                Text(
                  subtitle,
                  style: GoogleFonts.roboto(fontSize: 14),
                ),
              ],
            ),
            Spacer(),
            ElevatedButton(
              onPressed: () {
                // Handle Connect button action
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey[300],
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Connect',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHowItWorksCard({required IconData icon, required String title, required String description}) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, size: 24),
            SizedBox(height: 8),
            Text(
              title,
              style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w500),
            ),
            SizedBox(height: 4),
            Text(
              description,
              style: GoogleFonts.roboto(fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}
