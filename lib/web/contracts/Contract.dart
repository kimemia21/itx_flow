import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/AdvancedSearch.dart';
import 'package:itx/Contracts/AnimatedButton.dart';
import 'package:itx/Contracts/CreateContract/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';

class WebContracts extends StatefulWidget {
  const WebContracts({
    Key? key,
    required this.filtered,
    required this.showAppbarAndSearch,
    required this.isWareHouse,
  }) : super(key: key);

  final bool filtered;
  final bool showAppbarAndSearch;
  final bool isWareHouse;

  @override
  State<WebContracts> createState() => _WebContractsState();
}

class _WebContractsState extends State<WebContracts> {
  final TextEditingController _searchController = TextEditingController();
  late Future<List<ContractsModel>> contracts;

  @override
  void initState() {
    super.initState();
    fetchContracts();
  }

  Future<void> fetchContracts() async {
    setState(() {
      contracts = CommodityService.getContracts(
        
        isSpot: false,
        context: context,
        isWatchList: widget.filtered,
        isWareHouse: widget.isWareHouse,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Widget _buildSearchItem({required ContractsModel contract}) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        return GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Specificorder(contract: contract),
              ),
            );
          },
          child: Container(
            height: isSmallScreen ? 180 : 120,
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
            child: isSmallScreen
                ? Column(
                    children: [
                      _buildContractImage(contract),
                      Expanded(child: _buildContractDetails(contract)),
                    ],
                  )
                : Row(
                    children: [
                      _buildContractImage(contract),
                      Expanded(child: _buildContractDetails(contract)),
                    ],
                  ),
          ),
        );
      },
    );
  }

  Widget _buildContractImage(ContractsModel contract) {
    return Container(
      width: 120,
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        image: DecorationImage(
          image: NetworkImage(contract.imageUrl),
          fit: BoxFit.cover,
        ),
      ),
    );
  }

  Widget _buildContractDetails(ContractsModel contract) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  contract.name,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    color: Colors.green.shade800,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  contract.contractType,
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
            contract.description,
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
                    "Grade: ${contract.qualityGradeId}",
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Icon(Icons.calendar_today, size: 16, color: Colors.green.shade600),
                  SizedBox(width: 4),
                  Text(
                    "Delivery: ${DateFormat('MMM d, y').format(contract.deliveryDate)}",
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
                "Contract #${contract.contractId}",
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "\$${contract.price.toStringAsFixed(2)}",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                  SizedBox(width: 8),
                  LikeButton(
                    contractId: contract.contractId,
                    likes: contract.liked,
                    onLikeChanged: (isLiked) async {
                      await AuthRequest.likeunlike(context, isLiked ? 1 : 0, contract.contractId);
                      print('Contract ${contract.contractId} is ${isLiked ? 'liked' : 'unliked'}');
                    },
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: widget.filtered
          ? null
          : FloatingActionButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CreateContract()),
                );
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
      appBar: widget.showAppbarAndSearch
          ? AppBar(
              centerTitle: true,
              automaticallyImplyLeading: true,
              title: Text(
                widget.isWareHouse ? "WareHouse Orders" : widget.filtered ? "Watchlist" : "Contracts",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 20,
                ),
              ),
              backgroundColor: Colors.green.shade600,
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              flexibleSpace: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.green.shade500, Colors.green.shade700],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
            )
          : null,
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
              if (widget.showAppbarAndSearch) _buildSearchBar(context),
              SizedBox(height: 20),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: fetchContracts,
                  child: FutureBuilder<List<ContractsModel>>(
                    future: contracts,
                    builder: (context, snapshot) {
                      String name = widget.isWareHouse ? "WareHouse Orders" : widget.filtered ? "Watchlist" : "Contracts";
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Globals.buildErrorState(function: fetchContracts, items: name);
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Globals.buildNoDataState(function: fetchContracts, item: name);
                      }

                      List<ContractsModel> filteredContracts = snapshot.data!;

                      return ListView.builder(
                        itemCount: filteredContracts.length,
                        itemBuilder: (context, index) {
                          ContractsModel contract = filteredContracts[index];
                          return _buildSearchItem(contract: contract);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isSmallScreen = constraints.maxWidth < 600;
        return Container(
          margin: EdgeInsets.only(bottom: 16),
          padding: EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 16,
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
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Contract',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: 16,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(Icons.search, color: Colors.green.shade600),
                ),
              ),
              SizedBox(height: 8),
              ElevatedButton(
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text('Advanced Search'),
                      content: AdvancedSearchModal(
                        onSearch: (searchParams) async {
                          // Implement advanced search logic here
                          print('Advanced search params: $searchParams');
                        },
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
                    vertical: 12,
                    horizontal: isSmallScreen ? 16 : 24,
                  ),
                ),
                child: Text(
                  "Advanced Search",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}