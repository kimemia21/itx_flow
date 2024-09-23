import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import '../Serializers/CommodityModel.dart';

class CommodityDetailScreen extends StatelessWidget {
  final Commodity  commodity;

  const CommodityDetailScreen({Key? key, required this.commodity})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: CustomScrollView(
        slivers: [
          _buildSliverAppBar(context),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTitle(),
                SizedBox(height: 20),
                _buildInfoCard('Description', commodity.description),
                _buildInfoCard('Packaging', commodity.packagingName),
                _buildInfoCard('Type', commodity.typeName ?? 'N/A'),
                _buildCompanySection(),
                SizedBox(height: 20),
                _buildTradingActions(context),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(BuildContext context) {
    return SliverAppBar(
      expandedHeight: 250.0,
      floating: false,
      pinned: true,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Commodity Details',
          style: GoogleFonts.roboto(
            fontWeight: FontWeight.bold,
            color: Colors.white,
            shadows: [Shadow(color: Colors.black45, blurRadius: 2)],
          ),
        ),
        background: _buildHeroImage(),
      ),
      leading: IconButton(
        icon: Icon(Icons.arrow_back_ios, color: Colors.white),
        onPressed: () => Navigator.of(context).pop(),
      ),
      actions: [
        IconButton(
          icon: Icon(Icons.bookmark_border, color: Colors.white),
          onPressed: () {
            // TODO: Implement bookmark functionality
          },
        ),
      ],
    );
  }

  Widget _buildHeroImage() {
    return Hero(
      tag: 'commodity_image_${commodity.id}',
      child: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: commodity.imageUrl.isNotEmpty
                ? NetworkImage(commodity.imageUrl)
                : AssetImage('assets/placeholder_image.jpg') as ImageProvider,
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3),
              BlendMode.darken,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            offset: Offset(0, 2),
            blurRadius: 6.0,
          ),
        ],
      ),
      child: Text(
        commodity.name,
        style: GoogleFonts.roboto(
          fontSize: 28,
          fontWeight: FontWeight.bold,
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String content) {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: GoogleFonts.roboto(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 8),
            Text(
              content,
              style: GoogleFonts.roboto(
                fontSize: 16,
                color: Colors.black87,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanySection() {
    return Card(
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Company Information',
              style: GoogleFonts.roboto(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Colors.blue[800],
              ),
            ),
            SizedBox(height: 12),
            _buildCompanyInfo(Icons.business, commodity.companyName),
            _buildCompanyInfo(Icons.location_on, commodity.companyAddress),
            _buildCompanyInfo(Icons.phone, commodity.companyContacts),
          ],
        ),
      ),
    );
  }

  Widget _buildCompanyInfo(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.blue[600], size: 22),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: GoogleFonts.roboto(color: Colors.black87, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTradingActions(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: ElevatedButton(
        onPressed: () {
          double price = 100 + Random().nextInt(900).toDouble();

          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: Specificorder(
              item: commodity.name,
              companyId: commodity.userCompanyId.toString(),
              price: price,
              quantity: 10.toString(),
            ),
          );
        },
        child: Text(
          'Buy Now',
          style: GoogleFonts.roboto(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.green,
          padding: EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          elevation: 5,
        ),
      ),
    );
  }
}
