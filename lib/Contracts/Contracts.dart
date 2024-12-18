import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/Contracts/AdvancedSearch.dart';
import 'package:itx/Contracts/CreateContract/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Contracts/AnimatedButton.dart';
import 'package:itx/chatbox/ChatBox.dart';
import 'package:itx/global/appbar.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/global/globals.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

import 'package:data_table_2/data_table_2.dart';

import 'package:timeago/timeago.dart' as timeago;

class Contracts extends StatefulWidget {
  const Contracts({
    super.key,
    required this.filtered,
    required this.showAppbarAndSearch,
    required this.isWareHouse,
    required this.isSpot,
    required this.contractName,
    this.contractType,
  });
  final bool filtered;
  final bool showAppbarAndSearch;
  final bool isWareHouse;
  final bool isSpot;
  final int? contractType;
  final String contractName;

  @override
  State<Contracts> createState() => _ContractsState();
}

class _ContractsState extends State<Contracts> {
  final TextEditingController _searchController = TextEditingController();

  Future<List<ContractsModel>>? contracts; // Changed to nullable Future
  List<ContractsModel> currentContracts = [];
  int currentIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 6; // 2 minutes
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    fetchContracts();

    if (widget.isSpot) {
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
        contracts = Future.value(fetchedContracts);

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

    contracts?.then((allContracts) {
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

  Widget _buildContractsTable() {
    if (contracts == null) {
      return LoadingAnimationWidget.staggeredDotsWave(
          color: Colors.white, size: 30);
    }
    return RefreshIndicator(
        // Wrap the entire FutureBuilder
        onRefresh: fetchContracts,
        child: FutureBuilder<List<ContractsModel>>(
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

              return SingleChildScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                child: Container(
                  width: MediaQuery.of(context).size.width * 1,
                  height: MediaQuery.of(context).size.height * 1,
                  child: DataTable2(
                    columnSpacing: 10,
                    horizontalMargin: 10,
                    minWidth: 600,
                    columns: [
                      DataColumn2(
                          fixedWidth: 55,
                          label: Text('Company'),
                          size:
                              widget.isWareHouse ? ColumnSize.L : ColumnSize.S),
                      DataColumn2(
                          fixedWidth: 50,
                          label: Text('Grade'),
                          size: ColumnSize.S),
                      DataColumn2(
                          fixedWidth: 40,
                          label: Text('Type'),
                          size: ColumnSize.S),
                      DataColumn2(
                          fixedWidth: 75,
                          label: Text('Del. Date'),
                          size: ColumnSize.S),
                      DataColumn2(
                          fixedWidth: 65,
                          label: Text('Price'),
                          size: ColumnSize.S),
                      // Only show Action and Message columns if not warehouse
                      if (!widget.isWareHouse) ...[
                        DataColumn2(
                            fixedWidth: 40,
                            label: Text("Action"),
                            size: ColumnSize.S),
                        DataColumn2(
                            fixedWidth: 40,
                            label: Text('Message'),
                            size: ColumnSize.S),
                      ],
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

                      final delivery =
                          _formatDeliveryDate(contract.deliveryDate);

                      return DataRow(
                        cells: [
                          DataCell(GestureDetector(
                              onTap: () {
                                PersistentNavBarNavigator.pushNewScreen(
                                    withNavBar: true,
                                    context,
                                    screen: Specificorder(
                                      contract: contract,
                                      isWarehouse: widget.isWareHouse,
                                    )).then((_) {
                                  setState(() {});
                                });
                              },
                              child:
                                  Text(getFirstName(contract.contract_user!)))),
                          DataCell(Text(contract.grade_name ?? "N/A")),
                          DataCell(
                              Text(getContractTypeAbbr(contract.contractType))),
                          DataCell(Text(delivery)),
                          DataCell(
                              Text("\$${contract.price.toStringAsFixed(2)}")),
                          // Only show Action and Message cells if not warehouse
                          if (!widget.isWareHouse) ...[
                            DataCell(LikeButton(
                              contractId: contract.contractId,
                              isWarehouse: widget.isWareHouse,
                              likes: contract.liked,
                              onLikeChanged: (isLiked) async {
                                await AuthRequest.likeunlike(
                                  context,
                                  isLiked ? 1 : 0,
                                  contract.contractId,
                                );
                              },
                            )),
                            DataCell(IconButton(
                                onPressed: () {
                                  final userId = Provider.of<appBloc>(context,
                                          listen: false)
                                      .user_id;
                                  final modelUserId = contract.user_id;

                                  print("$userId, and $modelUserId");

                                  if (userId == modelUserId) {
                                    showDialog(
                                      context: context,
                                      builder: (context) {
                                        return AlertDialog(
                                          content: Container(
                                            width: 200,
                                            height: 200,
                                            color: Colors.white,
                                            child: Globals.MeState(),
                                          ),
                                        );
                                      },
                                    );
                                  } else {
                                    PersistentNavBarNavigator.pushNewScreen(
                                        withNavBar: true,
                                        context,
                                        screen: ChatScreen(model: contract));
                                  }
                                },
                                icon: Icon(
                                  Icons.message,
                                  color: Colors.grey,
                                ))),
                          ],
                        ],
                      );
                    }).toList(),
                  ),
                ),
              );
            }));
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
      floatingActionButton: widget.filtered || widget.isWareHouse
          ? null
          : FloatingActionButton.extended(
              onPressed: () {
                PersistentNavBarNavigator.pushNewScreen(
                    withNavBar: true, context, screen: CreateContract());
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    behavior: SnackBarBehavior.floating,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    duration: Duration(seconds: 1),
                    content: Row(
                      children: [
                        Icon(Icons.add_circle_outline, color: Colors.white),
                        SizedBox(width: 8),
                        Text('Creating new contract...'),
                      ],
                    ),
                    backgroundColor: Colors.green.shade600,
                  ),
                );
              },
              backgroundColor: Colors.green.shade600,
              icon: const Icon(Icons.add, color: Colors.white),
              label: Text('New Contract',
                  style: GoogleFonts.poppins(color: Colors.white)),
              elevation: 4,
            ),
      appBar: widget.showAppbarAndSearch
          ? ITXAppBar(
              title: widget.isWareHouse
                  ? "WareHouse "
                  : widget.filtered
                      ? "Watchlist"
                      : widget.contractName,
            )
          : null,
      body: context.watch<appBloc>().isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  LoadingAnimationWidget.staggeredDotsWave(
                      color: Colors.green, size: 40),
                  SizedBox(height: 16),
                  Text(
                    'Loading Contracts...',
                    style: GoogleFonts.poppins(
                      color: Colors.green.shade600,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            )
          : Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [Colors.green.shade50, Colors.white],
                  stops: [0.0, 0.6],
                ),
              ),
              child: CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (widget.showAppbarAndSearch) ...[
                            _buildSearchBar(context),
                            SizedBox(height: 20),
                          ],
                          if (widget.isSpot) ...[
                            Container(
                              width: double.infinity,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Live Market Updates',
                                    style: GoogleFonts.poppins(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.green.shade800,
                                    ),
                                  ),
                                  _buildDecoratedTimer(),
                                ],
                              ),
                            ),
                            SizedBox(height: 16),
                            Divider(color: Colors.green.shade100, thickness: 1),
                            SizedBox(height: 16),
                          ],
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.green.shade100.withOpacity(0.5),
                            spreadRadius: 1,
                            blurRadius: 10,
                            offset: Offset(0, -5),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                        child: _buildContractsTable(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildTableHeader(String text) {
    return TableCell(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Text(
          text,
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            fontSize: 16,
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
          Visibility(
            visible: context.watch<appBloc>().user_id == 6,
            child: Expanded(
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
                            final commodityId =
                                searchParams["commodityId"] ?? "";
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
          ),
        ],
      ),
    );
  }
}
