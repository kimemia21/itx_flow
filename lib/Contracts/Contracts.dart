import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Commodities.dart/AdvancedSearch.dart';
import 'package:itx/Contracts/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/AnimatedButton.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/globals.dart';
import 'package:http/http.dart' as http;
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Contracts extends StatefulWidget {
  const Contracts({super.key});

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
  int _currentIndex = 0;
  late PageController _pageController;
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  List<ContractsModel> _filterContracts(
      List<ContractsModel> contracts, String query) {
    if (query.isEmpty) {
      return contracts;
    } else {
      return contracts.where((contract) {
        final productName = contract.name.toLowerCase();
        final quality = contract.qualityGradeId.toString().toLowerCase();
        return productName.contains(query) || quality.contains(query);
      }).toList();
    }
  }

  Widget _buildSearchItem({
    required int contractId,
    required String contractType,
    required String title,
    required String product,
    required int qualityGradeId,
    required DateTime deliveryDate,
    required double price,
    required String description,
    required String iconName,
    required String imageUrl,
   }) {
    Map<int, dynamic> data = {
      contractId: {
        "contractId": contractId as int,
        "contractType": contractType as String,
        "title": contractType as String,
        "product": product as String,
        "qualityGradeId": qualityGradeId as int,
        "deliveryDate": deliveryDate as DateTime,
        "price": price as double,
        "description": description as String,
        "iconName": iconName as String,
        "imageUrl": imageUrl as String,
      }
    };

    print("THIS IS THE ID ${data[contractId]["contractId"]}");
    print(contractId);

    return Container(
      height: 120,
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 120,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
              image: DecorationImage(
                image: NetworkImage(imageUrl),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.green.shade800,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        decoration: BoxDecoration(
                          color: Colors.blue.shade50,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          contractType,
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.blue.shade700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Text(
                    description,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: Colors.grey.shade600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.grade, size: 16, color: Colors.amber),
                          SizedBox(width: 4),
                          Text(
                            "Grade: $qualityGradeId",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.green.shade600),
                          SizedBox(width: 4),
                          Text(
                            "Delivery: ${DateFormat('MMM d, y').format(deliveryDate)}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Contract #$contractId",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: Colors.green.shade50,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "\$${price.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                                color: Colors.green.shade700,
                              ),
                            ),
                          ),
                          SizedBox(width: 8),
                          LikeButton(
                            contractId: contractId,
                            data: data,
                            // initialIsLiked: false,
                            onLikeChanged: (isLiked) {
                              // Handle like state change
                              print(
                                  'Contract $contractId is ${isLiked ? 'liked' : 'unliked'}');
                            },
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
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
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          PersistentNavBarNavigator.pushNewScreen(
            withNavBar: true,
            context,
              screen: CreateContract());
          // Globals.switchScreens(context: context, screen: CreateContract());
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: Duration(seconds: 1),
              content: Text('Creating new contract...'),
              backgroundColor: Colors.green.shade600,
            ),
          );
        },
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        // leading: IconButton(
        //   onPressed: () =>
        //       Globals.switchScreens(context: context, screen: Authorization()),
        //   icon: const Icon(Icons.arrow_back, color: Colors.white),
        // ),
        title: Text(
          "Contracts",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.green.shade600,
        elevation: 0,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.green.shade50, Colors.white],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              _buildSearchBar(context),
              Expanded(
                child: FutureBuilder<List<ContractsModel>>(
                  future: CommodityService.getContracts(context),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                          child: CircularProgressIndicator(
                              color: Colors.green.shade600));
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(
                          'Error: ${snapshot.error}',
                          style: GoogleFonts.poppins(color: Colors.red),
                        ),
                      );
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Center(
                        child: Text(
                          'No contracts available',
                          style:
                              GoogleFonts.poppins(color: Colors.grey.shade600),
                        ),
                      );
                    } else {
                      final filteredContracts =
                          _filterContracts(snapshot.data!, _searchQuery);
                      return ListView.builder(
                        itemCount: filteredContracts.length,
                        itemBuilder: (context, index) {
                          final contract = filteredContracts[index];

                          return GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                  withNavBar: true,
                                  context,
                                  screen: Specificorder(
                                    companyId:
                                        contract.userCompanyId.toString(),
                                    item: contract.name,
                                    price: contract.price,
                                    quantity:
                                        contract.qualityGradeId.toString(),
                                  ),
                                );
                              },
                              child: _buildSearchItem(
                                  contractId: contract.contractId,
                                  contractType: contract.contractType,
                                  title: contract.name,
                                  product: contract.name,
                                  qualityGradeId: contract.qualityGradeId,
                                  deliveryDate: contract.deliveryDate,
                                  price: contract.price,
                                  description: contract.description,
                                  iconName: contract.iconName,
                                  imageUrl: contract.imageUrl));
                        },
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      margin: EdgeInsets.only(bottom: screenWidth * 0.04),
      padding: EdgeInsets.symmetric(
        vertical: screenWidth * 0.02,
        horizontal: screenWidth * 0.04,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            flex: 7,
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search Contract',
                hintStyle: GoogleFonts.poppins(
                  fontSize: screenWidth * 0.04,
                  color: Colors.grey.shade400,
                ),
                prefixIcon: Icon(Icons.search, color: Colors.green.shade600),
              ),
            ),
          ),
          SizedBox(width: screenWidth * 0.03),
          Expanded(
            flex: 3,
            child: ElevatedButton(
              onPressed: () {
                showModalBottomSheet(
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.transparent,
                  builder: (context) => SingleChildScrollView(
                    child: Container(
                      padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      child: AdvancedSearchModal(
                        onSearch: (searchParams) {
                          // Implement the advanced search logic here
                          print('Advanced search params: $searchParams');
                          // You might want to update the state or call a method to filter the contracts based on these params
                        },
                      ),
                    ),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green.shade600,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                padding: EdgeInsets.symmetric(
                  vertical: screenWidth * 0.03,
                ),
              ),
              child: Text(
                "Advanced",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: screenWidth * 0.035,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
