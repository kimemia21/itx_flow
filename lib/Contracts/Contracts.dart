import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/AdvancedSearch.dart';
import 'package:itx/Contracts/Create.dart';
import 'package:itx/Contracts/MyContracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Contracts/SpotItem.dart';
import 'package:itx/authentication/Authorization.dart';
import 'package:itx/global/GlobalsHomepage.dart';
import 'package:itx/global/SidePage.dart';
import 'package:itx/global/globals.dart';

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

  final List<Map<String, dynamic>> contracts = [
    {
      "contract_name": {
        "product_name": "Copper",
        "quality": "High grade",
        "price": 2300.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Gold",
        "quality": "24 Karat",
        "price": 59000.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Silver",
        "quality": "99.9% Pure",
        "price": 2500.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Aluminum",
        "quality": "Refined",
        "price": 1800.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Iron",
        "quality": "Cast",
        "price": 600.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Platinum",
        "quality": "Jewelry grade",
        "price": 68000.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Nickel",
        "quality": "Industrial",
        "price": 1600.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Zinc",
        "quality": "Pure",
        "price": 2100.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Lead",
        "quality": "Industrial",
        "price": 1000.00,
      }
    },
    {
      "contract_name": {
        "product_name": "Tin",
        "quality": "Refined",
        "price": 3500.00,
      }
    },
  ];

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

  List<Map<String, dynamic>> get _filteredContracts {
    if (_searchQuery.isEmpty) {
      return contracts;
    } else {
      return contracts.where((contract) {
        final productName = contract["contract_name"]["product_name"].toString().toLowerCase();
        final quality = contract["contract_name"]["quality"].toString().toLowerCase();
        return productName.contains(_searchQuery) || quality.contains(_searchQuery);
      }).toList();
    }
  }

  Widget _buildSearchItem({
    required String title,
    required String product,
    required String quality,
    required String price,
  }) {
    double width = Globals.AppWidth(context: context, width: 1);
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(horizontal: 10),
      margin: const EdgeInsets.only(top: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.3),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: width / 2,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  "$product, $quality",
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
          Text(
            price,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 16,
              color: Colors.teal,
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
          Globals.switchScreens(context: context, screen: CreateContract());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Floating Action Button Pressed!')),
          );
        },
        backgroundColor: Colors.green.shade600,
        child: const Icon(Icons.add, color: Colors.white),
      ),
      appBar: AppBar(
        leading: IconButton(
          onPressed: () => Globals.switchScreens(context: context, screen: const Authorization()),
          icon: const Icon(Icons.arrow_back),
        ),
        title: Text(
          "Contracts",
          style: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildSearchBar(context),
              _buildContractsList(),
            ],
          ),
        ),
      ),
    );
  }

Widget _buildSearchBar(BuildContext context) {
  final double screenWidth = MediaQuery.of(context).size.width;
  
  return Container(
    margin: EdgeInsets.symmetric(
      vertical: screenWidth * 0.02, // Responsive vertical margin
      horizontal: screenWidth * 0.04, // Responsive horizontal margin
    ),
    padding: EdgeInsets.symmetric(
      vertical: screenWidth * 0.02, // Responsive padding
    ),
    child: Row(
      children: [
        Expanded(
          flex: 7, // 70% of available space
          child: TextField(
            controller: _searchController,
            decoration: InputDecoration(
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              labelText: 'Search commodities',
              labelStyle: GoogleFonts.poppins(fontSize: screenWidth * 0.04), // Responsive font size
              prefixIcon: const Icon(Icons.search),
              fillColor: Colors.grey[200],
              filled: true,
              contentPadding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // Responsive padding
                vertical: screenWidth * 0.03,
              ),
            ),
          ),
        ),
        SizedBox(width: screenWidth * 0.03), // Responsive spacing between widgets
        Expanded(
          flex: 3, // 30% of available space
          child: TextButton(
            onPressed: () => Navigator.of(context).push(
              SlideFromSidePageRoute(widget: AdvancedSearchPage()),
            ),
            style: TextButton.styleFrom(
              backgroundColor: Colors.blue[50],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.02, // Responsive padding
                vertical: screenWidth * 0.03,
              ),
            ),
            child: Text(
              "Advanced",
              style: GoogleFonts.poppins(
                color: Colors.blue, 
                fontWeight: FontWeight.w600,
                fontSize: screenWidth * 0.04, // Responsive font size
              ),
            ),
          ),
        ),
      ],
    ),
  );
}


  Widget _buildContractsList() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.7,
      child: ListView.builder(
        itemCount: _filteredContracts.length,
        itemBuilder: (context, index) {
          final contract = _filteredContracts[index]["contract_name"];
          return GestureDetector(
            onTap: () => Globals.switchScreens(context: context, screen: Specificorder(item: contract["product_name"],price: contract["price"],quantity:contract["quality"])),
            child: _buildSearchItem(
              title: contract["product_name"],
              product: contract["product_name"],
              quality: contract["quality"],
              price: contract["price"].toString(),
            ),
          );
        },
      ),
    );
  }
}
