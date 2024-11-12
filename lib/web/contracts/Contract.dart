import 'dart:async';
import 'dart:math';

import 'package:data_table_2/data_table_2.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/AdvancedSearch.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Contracts/AnimatedButton.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/web/CreateContract%20copy/WebCreateContract.dart';
import 'package:itx/web/contracts/SpecificOrder.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

import 'package:timeago/timeago.dart' as timeago;

class WebContracts extends StatefulWidget {
  const WebContracts(
      {super.key,
      required this.filtered,
      required this.showAppbarAndSearch,
      required this.isWareHouse,
      required this.isSpot,
      this.contractType,
      required this.contractName});

  final bool filtered;
  final bool showAppbarAndSearch;
  final bool isWareHouse;
  final bool isSpot;
  final int? contractType;
  final String contractName;

  @override
  State<WebContracts> createState() => _WebContractsState();
}

class _WebContractsState extends State<WebContracts> {
  final TextEditingController _searchController = TextEditingController();

  late Future<List<ContractsModel>> contracts;

  List<ContractsModel> currentContracts = [];
  int currentIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 6; // 2 minutes
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    fetchContracts();

    if (!widget.isSpot) {
      _startTimer();
    } else {
      //  _startTimer();
    }
  }

  @override
  void dispose() {
    _searchController.dispose();
    _timer?.cancel();
    super.dispose();
  }

  Future<void> fetchContracts() async {
    try {
      final fetchedContracts = await CommodityService.getContracts(
        context: context,
        isWatchList: widget.filtered,
        isWareHouse: widget.isWareHouse,
        contractTypeId: widget.contractType,
        isSpot: widget.isSpot,
      );

      setState(() {
        isLoading = false;
        contracts =
            Future.value(fetchedContracts); // Set the fetched data here.

        if (widget.isSpot) {
          _updateCurrentContracts();
        } else {
          currentContracts = fetchedContracts;
        }
      });
    } catch (error) {
      setState(() {
        contracts = Future.error(error);
      });
    }
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
          print("Seconds Remaining: $_secondsRemaining");
        } else {
          _secondsRemaining = 6;
          _updateCurrentContracts();
        }
      });
    });
  }

  void _updateCurrentContracts() {
    print("called");

    contracts.then((allContracts) {
      if (allContracts.isEmpty) {
        print("empty");
        return;
      }
      print("contracts length is ${allContracts.length}");
      setState(() {
        currentIndex = (currentIndex + 2) % allContracts.length;

        currentContracts = allContracts.sublist(
          currentIndex,
          min(currentIndex + 2, allContracts.length),
        );

        if (currentContracts.length < 2) {
          print("length is less than 2");
          currentContracts +=
              allContracts.sublist(0, 2 - currentContracts.length);
        }
      });
    }).catchError((onError) {
      print("--------------$onError-------------------");
    });
  }

  Widget _buildDecoratedTimer() {
    final minutes = _secondsRemaining ~/ 60;
    final seconds = _secondsRemaining % 60;
    final progress = 1 - (_secondsRemaining / 6);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green.shade50,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.green.withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 5,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Next Update In',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: seconds < 3 ? Colors.red.shade300 : Colors.green.shade600,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 70,
                width: 70,
                child: CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 8,
                  backgroundColor:
                      seconds < 3 ? Colors.white : Colors.green.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(seconds < 3
                      ? Colors.red.shade300
                      : Colors.green.shade600),
                ),
              ),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;
    final bool isDesktop = screenWidth > 1024;

    return Center(
      child: Container(
        width: isDesktop ? 800 : screenWidth * 0.9,
        margin:
            EdgeInsets.symmetric(vertical: isDesktop ? 16 : screenWidth * 0.02),
        padding: EdgeInsets.symmetric(
          vertical: isDesktop ? 8 : screenWidth * 0.015,
          horizontal: isDesktop ? 16 : screenWidth * 0.03,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: const Offset(0, 2),
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
                      name: text,
                    );
                  });
                },
                controller: _searchController,
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Search Contract',
                  hintStyle: GoogleFonts.poppins(
                    fontSize: isDesktop ? 14 : screenWidth * 0.035,
                    color: Colors.grey.shade400,
                  ),
                  prefixIcon: Icon(Icons.search,
                      color: Colors.green.shade600,
                      size: isDesktop ? 20 : screenWidth * 0.045),
                  contentPadding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 8 : screenWidth * 0.01),
                ),
              ),
            ),
            SizedBox(width: isDesktop ? 12 : screenWidth * 0.02),
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
                            // ... (keep the existing onSearch logic)
                          },
                        ),
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green.shade600,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  padding: EdgeInsets.symmetric(
                      vertical: isDesktop ? 12 : screenWidth * 0.02),
                ),
                child: Text(
                  "Advanced",
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: isDesktop ? 14 : screenWidth * 0.03,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
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
        height: MediaQuery.of(context).size.height *
            0.25, // 20% of the screen height
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
                  contract.grade_name ?? "Grade_name",
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
                          contract.contract_user ?? "contract user",
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
                          isWarehouse: widget.isWareHouse,
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
                          SizedBox(
                            width: 4,
                          ),
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

  Widget _buildContractsTable() {
      if (contracts == null) {
      return LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white, size: 30);
    }
    return FutureBuilder<List<ContractsModel>>(
      future: contracts,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Globals.buildErrorState(
              function: fetchContracts, items: widget.contractName);
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(
              child: Globals.buildNoDataState(
                  function: fetchContracts, item: widget.contractName));
        }

        List<ContractsModel> contractsList =
            widget.isSpot ? currentContracts : snapshot.data!;

        return RefreshIndicator(
          onRefresh: fetchContracts,
          child: DataTable2(
            columnSpacing: 20,
            horizontalMargin: 20,
            minWidth: 600,
            columns: [
              DataColumn2(
                label: Text(
                  'Company',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(
                  'Grade',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(
                  'Type',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(
                  'Del. Date',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.L,
              ),
              DataColumn2(
                label: Text(
                  'Price',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.S,
              ),
              DataColumn2(
                label: Text(
                  'Action',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                ),
                size: ColumnSize.S,
              ),
            ],
            rows: contractsList.map((contract) {
              String _formatDeliveryDate(DateTime deliveryDate) {
                final now = DateTime.now();
                final difference = deliveryDate.difference(now);

                if (difference.isNegative) {
                  return 'Delivered ${timeago.format(deliveryDate)} ago';
                } else {
                  return '${timeago.format(deliveryDate, allowFromNow: true)}';
                }
              }

              final delivery = _formatDeliveryDate(contract.deliveryDate);

              return DataRow(
                cells: [
                  DataCell(GestureDetector(
                      onTap: () {
                        PersistentNavBarNavigator.pushNewScreen(
                            withNavBar: true,
                            context,
                            screen: WebSpecificOrder(contract: contract));
                      },
                      child: Text(getFirstName(contract.contract_user!)))),
                  DataCell(Text(contract.grade_name ?? "N/A")),
                  DataCell(Text(getContractTypeAbbr(contract.contractType))),
                  DataCell(Text(delivery
                      // timeago.format(contract.deliveryDate)

                      // DateFormat('MMM d, y').format(contract.deliveryDate)

                      )),
                  DataCell(Text("\$${contract.price.toStringAsFixed(2)}")),
                  DataCell(LikeButton(
                    isWarehouse: widget.isWareHouse,
                    contractId: contract.contractId,
                    likes: contract.liked,
                    onLikeChanged: (isLiked) async {
                      await AuthRequest.likeunlike(
                        context,
                        isLiked ? 1 : 0,
                        contract.contractId,
                      );
                    },
                  )),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  String getFirstName(String fullName) {
    List<String> nameParts = fullName.split(" ");
    return nameParts[0];
  }

  String getContractTypeAbbr(String? contractType) {
    switch (contractType) {
      case "Futures":
        return "FT";
      case "Forwards":
        return "FW";
      case "Swaps":
        return "SW";
      default:
        return "SP";
    }
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
                        : widget.contractName,
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
                            child: _buildSearchBar(context)),
                      ),
                      Visibility(
                          visible: widget.isSpot,
                          child: _buildDecoratedTimer()),
                      Flexible(child: _buildContractsTable()),
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
