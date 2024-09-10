import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/global/CommodityItem.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomepageMain extends StatefulWidget {
  @override
  _HomepageMainState createState() => _HomepageMainState();
}

class _HomepageMainState extends State<HomepageMain> {
  String _searchQuery = "";
  String _selectedFilter = "All";
  List<String> _filterOptions = ["All"]; // Add your actual filter options

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Commodities',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 24,
          ),
        ),
        backgroundColor: Colors.green.shade800,
        elevation: 0,
        // shape: RoundedRectangleBorder(
        //   borderRadius: BorderRadius.vertical(
        //     bottom: Radius.circular(20),
        //   ),
        // ),
      ),
      body: Column(
        children: [
          _buildSearchAndFilterBar(),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green.shade50, Colors.white],
                ),
              ),
              child: FutureBuilder<List<CommodityModel>>(
                future: CommodityService.fetchCommodities(context, _searchQuery),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Center(child: CircularProgressIndicator(color: Colors.green.shade800));
                  } else if (snapshot.hasError) {
                    return Center(
                      child: Text(
                        'Error: ${snapshot.error}',
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          color: Colors.red.shade600,
                        ),
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Center(
                      child: Text(
                        'No commodities available',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: Colors.red.shade600,
                        ),
                      ),
                    );
                  } else {
                    List<CommodityModel> filteredCommodities = _filterCommodities(snapshot.data!);
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: filteredCommodities.length,
                      itemBuilder: (context, index) {
                        final commodity = filteredCommodities[index];
                        return _buildCommodityCard(commodity);
                      },
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilterBar() {
    return Container(
      color: Colors.green.shade800,
      padding: EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Column(
        children: [
          TextField(
            style: TextStyle(color: Colors.white),
            decoration: InputDecoration(
              hintText: "Search commodities...",
              hintStyle: TextStyle(color: Colors.white70),
              prefixIcon: Icon(Icons.search, color: Colors.white70),
              filled: true,
              fillColor: Colors.green.shade700,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(30),
                borderSide: BorderSide.none,
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          SizedBox(height: 10),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12),
            decoration: BoxDecoration(
              color: Colors.green.shade700,
              borderRadius: BorderRadius.circular(30),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedFilter,
                icon: Icon(Icons.arrow_drop_down, color: Colors.white),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.white),
                dropdownColor: Colors.green.shade700,
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedFilter = newValue!;
                  });
                },
                items: _filterOptions.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommodityCard(CommodityModel commodity) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      margin: EdgeInsets.only(bottom: 16),
      child: GestureDetector(
        onTap: () {
          PersistentNavBarNavigator.pushNewScreen(
            context,
            screen: CommodityDetailScreen(commodity: commodity),
            withNavBar: true,
          );
        },
        child: ExpansionTile(
          leading: Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Hero(
              tag: 'commodity_image_${commodity.id}',
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: commodity.imageUrl.isNotEmpty
                    ? Image.network(
                        commodity.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            Icon(Icons.image_not_supported, size: 40, color: Colors.grey),
                      )
                    : Icon(Icons.inventory, size: 40, color: Colors.green.shade800),
              ),
            ),
          ),
          title: Text(
            commodity.name,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 18,
              color: Colors.green.shade800,
            ),
          ),
          subtitle: Text(
            commodity.packagingName,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w400,
              color: Colors.grey.shade700,
            ),
          ),
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildInfoSection('Description:', commodity.description),
                  SizedBox(height: 12),
                  _buildInfoSection('Type:', commodity.typeName ?? 'N/A'),
                  SizedBox(height: 12),
                  _buildInfoSection('Company:', commodity.companyName),
                  Text(
                    commodity.companyAddress,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
                  ),
                  Text(
                    commodity.companyContacts,
                    style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey.shade700),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w600,
            fontSize: 16,
            color: Colors.green.shade800,
          ),
        ),
        SizedBox(height: 4),
        Text(
          content,
          style: GoogleFonts.poppins(fontSize: 14),
        ),
      ],
    );
  }

  List<CommodityModel> _filterCommodities(List<CommodityModel> commodities) {
    if (_selectedFilter == "All") {
      return commodities;
    }
    return commodities.where((commodity) => commodity.typeName == _selectedFilter).toList();
  }
}