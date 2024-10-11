import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/AdvancedSearch.dart';
import 'package:itx/Contracts/CreateContract/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Contracts/AnimatedButton.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/web/CreateContract%20copy/WebCreateContract.dart';
import 'package:itx/web/contracts/SpecificOrder.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class WebContracts extends StatefulWidget {
  const WebContracts({
    super.key,
    required this.filtered,
    required this.showAppbarAndSearch,
    required this.isWareHouse,
    required this.isSpot,
    this.contractType,
  });

  final bool filtered;
  final bool showAppbarAndSearch;
  final bool isWareHouse;
  final bool isSpot;
  final int? contractType;

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
        context: context,
        isWatchList: widget.filtered,
        isWareHouse: widget.isWareHouse,
        contractTypeId: widget.contractType,
        isSpot: widget.isSpot,
      );
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

 Widget _buildSearchItem({required ContractsModel contract}) {
  return GestureDetector(
    onTap: () {
      PersistentNavBarNavigator.pushNewScreen(
        withNavBar: true, 
        context, 
        screen: WebSpecificOrder(contract: contract),
      );
    },
    child: Container(
      // Responsive height
      height: MediaQuery.of(context).size.height * 0.2, // 20% of the screen height
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
            width: 100,
            height: 100,
            margin: const EdgeInsets.all(2),
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadiusDirectional.circular(50),
            ),
            child: Center(
              child: Text(
                contract.grade_name??"Grade_name",
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
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
                        contract.contract_user??"contract user",
                        style: GoogleFonts.poppins(
                          fontWeight: FontWeight.w700,
                          fontSize: 18,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 8, vertical: 4),
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
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        contract.contract_packing ?? "Not set yet",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.grey.shade600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today,
                              size: 16, color: Colors.green.shade600),
                          const SizedBox(width: 4),
                          Text(
                            "Delivery: ${DateFormat('MMM d, y').format(contract.deliveryDate)}",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(width: 4),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Text(
                            contract.canBid == 1 ? "Started at" : "Price",
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Colors.grey.shade600,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            "\$${contract.price.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 16,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ],
                      ),
                      LikeButton(
                        contractId: contract.contractId,
                        likes: contract.liked,
                        onLikeChanged: (isLiked) async {
                          await AuthRequest.likeunlike(
                              context, isLiked ? 1 : 0, contract.contractId);
                          print(
                              'Contract ${contract.contractId} is ${isLiked ? 'liked' : 'unliked'}');
                        },
                      ),
                    ],
                  ),
                  Visibility(
                    visible: contract.canBid == 1,
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Highest Bid",
                          style: GoogleFonts.poppins(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        SizedBox(width: 4,),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 12, vertical: 6),
                          decoration: BoxDecoration(
                            color: Colors.green.shade50,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "\$${contract.price.toStringAsFixed(2)}",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.green.shade700,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
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
                PersistentNavBarNavigator.pushNewScreen(
                    withNavBar: true, context, screen: WebCreateContract());
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
                widget.isWareHouse
                    ? "WareHouse Orders"
                    : widget.filtered
                        ? "Watchlist"
                        : "Contracts",
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
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(maxWidth: 800),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Visibility(
                        visible: widget.showAppbarAndSearch,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 16),
                              hintText: "Search...",
                              prefixIcon: const Icon(Icons.search),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(25),
                                borderSide: BorderSide(
                                  color: Colors.grey.shade300,
                                  width: 1,
                                ),
                              ),
                            ),
                            onChanged: (value) {
                              fetchContracts();
                            },
                          ),
                        ),
                      ),
                      Expanded(
                        child: FutureBuilder<List<ContractsModel>>(
                          future: contracts,
                          builder: (context, snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.waiting) {
                              return Center(
                                  child: CircularProgressIndicator(
                                color: Colors.green.shade600,
                              ));
                            } else if (snapshot.hasError) {
                              return Center(
                                child: Text(
                                  "Error: ${snapshot.error}",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.red,
                                  ),
                                ),
                              );
                            } else if (snapshot.data == null ||
                                snapshot.data!.isEmpty) {
                              return Center(
                                child: Text(
                                  "No contracts found",
                                  style: GoogleFonts.poppins(
                                    fontSize: 16,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data!.length,
                                itemBuilder: (context, index) {
                                  return _buildSearchItem(
                                    contract: snapshot.data![index],
                                  );
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
          },
        ),
      ),
    );
  }
}
