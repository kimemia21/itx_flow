import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/AdvancedSearch.dart';
import 'package:itx/Contracts/CreateContract/CreateContract.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/Contracts/AnimatedButton.dart';
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

  late Future<List<ContractsModel>> contracts;
  List<ContractsModel> currentContracts = [];
  int currentIndex = 0;
  Timer? _timer;
  int _secondsRemaining = 120; // 2 minutes
  bool isLoading = false;
  @override
  void initState() {
    super.initState();

    fetchContracts();

    if (widget.isSpot) {
      _startTimer();
    } else {
      print(
          "-------------------------------is not spot---------------------------------");
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
          _secondsRemaining = 120;
          _updateCurrentContracts();
        }
      });
    });
  }

  void _updateCurrentContracts() {
    contracts.then((allContracts) {
      if (allContracts.isEmpty) {
        return; // If no contracts, do nothing
      }

      setState(() {
        currentIndex = (currentIndex + 2) % allContracts.length;

        currentContracts = allContracts.sublist(
          currentIndex,
          min(currentIndex + 2, allContracts.length),
        );

        if (currentContracts.length < 2) {
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
    final progress = 1 - (_secondsRemaining / 120);

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
              color: seconds < 30 ? Colors.red.shade300 : Colors.green.shade600,
            ),
          ),
          SizedBox(height: 8),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 40,
                width: 80,
                child: LinearProgressIndicator(
                  value: progress,
                  // strokeWidth: 8,
                  backgroundColor:
                      seconds < 30 ? Colors.white : Colors.green.shade200,
                  valueColor: AlwaysStoppedAnimation<Color>(seconds < 30
                      ? Colors.red.shade300
                      : Colors.green.shade600),
                ),
              ),
              Text(
                '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContractsTable() {
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

        return Container(
          width: MediaQuery.of(context).size.width * 1,
          height: MediaQuery.of(context).size.height * 1,
          child: RefreshIndicator(
            onRefresh: fetchContracts,
            child: DataTable2(
              columnSpacing: 10,
              horizontalMargin: 10,
              minWidth: 600,
              columns: [
                DataColumn2(
                    fixedWidth: 55, label: Text('Company'), size: ColumnSize.S),
                DataColumn2(
                    fixedWidth: 50, label: Text('Grade'), size: ColumnSize.S),
                DataColumn2(
                    fixedWidth: 40, label: Text('Type'), size: ColumnSize.S),
                DataColumn2(
                    fixedWidth: 75,
                    label: Text('Del. Date'),
                    size: ColumnSize.S),
                DataColumn2(
                    fixedWidth: 65, label: Text('Price'), size: ColumnSize.S),
                DataColumn2(
                    fixedWidth: 40, label: Text('Action'), size: ColumnSize.S),
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
                              screen: Specificorder(contract: contract));
                        },
                        child: Text(getFirstName(contract.contract_user!)))),
                    DataCell(Text(contract.grade_name ?? "N/A")),
                    DataCell(Text(getContractTypeAbbr(contract.contractType))),
                    DataCell(Text(delivery)),
                    DataCell(Text("\$${contract.price.toStringAsFixed(2)}")),
                    DataCell(LikeButton(
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
          ? ITXAppBar(
              title: widget.isWareHouse
                  ? "WareHouse Orders"
                  : widget.filtered
                      ? "Watchlist"
                      : widget.contractName,
            )
          : null,
      body: context.watch<appBloc>().isLoading
          ? LoadingAnimationWidget.staggeredDotsWave(
              color: Colors.green, size: 20)
          : Container(
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Visibility(
                      visible: widget.showAppbarAndSearch,
                      child: _buildSearchBar(context),
                    ),
                    SizedBox(height: 20),
                    Visibility(
                        visible: widget.isSpot, child: _buildDecoratedTimer()),
                    Flexible(child: _buildContractsTable()),
                  ],
                ),
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
