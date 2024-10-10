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
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Contracts extends StatefulWidget {
  const Contracts(
   
    {
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
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
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
          
          isSpot: widget.isSpot);
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
            screen: Specificorder(contract: contract));
      },
      child: Container(
        height: 140,
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
              margin: EdgeInsets.all(2),
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadiusDirectional.circular(50)),
              child: Center(
                  child: Text(
                "Grade name",
                style: GoogleFonts.poppins(color: Colors.grey.shade600),
              )),
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
                          "Compay name",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 18,
                            color: Colors.grey.shade600,
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
                          contract.contract_packing??"not set yet",
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
                            SizedBox(
                              width: 4,
                            ),
                            Text(
                                "Delivery: ${DateFormat('MMM d, y').format(contract.deliveryDate)}",
                                style: GoogleFonts.poppins(
                                  fontSize: 12,
                                  color: Colors.grey.shade700,
                                )),
                            SizedBox(width: 4),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
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
                            SizedBox(
                              width: 4,
                            ),
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
                        Row(
                          children: [
                            // Container(
                            //   padding: EdgeInsets.symmetric(
                            //       horizontal: 12, vertical: 6),
                            //   decoration: BoxDecoration(
                            //     color: Colors.green.shade50,
                            //     borderRadius: BorderRadius.circular(20),
                            //   ),
                            //   child: Text(
                            //     "\$${contract.price.toStringAsFixed(2)}",
                            //     style: GoogleFonts.poppins(
                            //       fontWeight: FontWeight.w600,
                            //       fontSize: 16,
                            //       color: Colors.green.shade700,
                            //     ),
                            //   ),
                            // ),
                            // SizedBox(width: 8),
                            LikeButton(
                              contractId: contract.contractId,
                              likes: contract.liked,
                              // data: data,
                              onLikeChanged: (isLiked) async {
                                await AuthRequest.likeunlike(context,
                                    isLiked ? 1 : 0, contract.contractId);

                                print(
                                    'Contract ${contract.contractId} is ${isLiked ? 'liked' : 'unliked'}');
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                    Visibility(
                      visible: contract.canBid == 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("Highest Bid",
                              style: GoogleFonts.poppins(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: Colors.grey.shade600,
                              )),
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 12, vertical: 6),
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
    print("${Provider.of<appBloc>(context, listen: false).token} token");

    return Scaffold(
      floatingActionButton: widget.filtered
          ? null
          : FloatingActionButton(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                    withNavBar: true, context, screen: CreateContract());
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
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Visibility(
                visible: widget.showAppbarAndSearch,
                child: _buildSearchBar(context),
              ),
              SizedBox(
                height: 20,
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    await fetchContracts(); // Fetch contracts when pulling down
                  },
                  child: FutureBuilder<List<ContractsModel>>(
                    future: contracts,
                    builder: (context, snapshot) {
                      String name = widget.isWareHouse
                          ? "WareHouse Orders"
                          : widget.filtered
                              ? "Watchlist"
                              : "Contracts";
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return Center(child: CircularProgressIndicator());
                      } else if (snapshot.hasError) {
                        return Globals.buildErrorState(
                            function: fetchContracts, items: name);
                      } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return Globals.buildNoDataState(
                            function: fetchContracts, item: name);
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
              onChanged: (text) {
                setState(() {
                  contracts = CommodityService.getContracts(
                      isSpot: widget.isSpot,
                      context: context,
                      isWatchList: widget.filtered,
                      isWareHouse: widget.isWareHouse,
                      name: text);
                });
              },
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
                        onSearch: (searchParams) async {
                          final contractId = searchParams["contractId"] ?? "";
                          final commodityId = searchParams["commodityId"] ?? "";
                          final String price_from =
                              searchParams["price_from"] ?? "";
                          final String price_to =
                              searchParams["price_to"] ?? "";
                          final String date_from =
                              searchParams["deliveryDateStart"] ?? "";
                          final String date_to =
                              searchParams["deliveryDateEnd"] ?? "";

                          setState(() {
                            contracts = CommodityService.getAdvancedContracts(
                                context,
                                contractId,
                                commodityId,
                                date_from,
                                date_to,
                                price_from,
                                price_to);
                          });

                          print('Advanced search params: $searchParams');
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
