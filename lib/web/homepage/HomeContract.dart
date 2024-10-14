import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Serializers/ContractSummary.dart';
import 'package:itx/Commodities.dart/ComRequest.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/web/contracts/Contract.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class WebHomepageContracts extends StatefulWidget {
  final int displayCount;

  const WebHomepageContracts({
    Key? key,
    this.displayCount = 6,
  }) : super(key: key);

  @override
  _WebHomepageContractsState createState() => _WebHomepageContractsState();
}

class _WebHomepageContractsState extends State<WebHomepageContracts> {
  late Future<List<ContractSummary>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = fetchContracts();
  }

  Future<List<ContractSummary>> fetchContracts() async {
    return CommodityService.ContractsSummary(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<ContractSummary>>(
      future: _contractsFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No contracts available'));
        } else {
          return Container(
            margin: EdgeInsets.all(10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(),
                Text(
                  "Available Trades",
                  style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold, color: Colors.grey.shade600),
                ),
                _buildContractGrid(snapshot.data!),
              ],
            ),
          );
        }
      },
    );
  }

  Widget _buildContractGrid(List<ContractSummary> contracts) {
    return Container(
      width: MediaQuery.of(context).size.width * 5,
      height: MediaQuery.of(context).size.height * 1,
      margin: EdgeInsets.only(top: 5),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemCount: contracts.length > widget.displayCount
            ? widget.displayCount
            : contracts.length,
        itemBuilder: (context, index) {
          return _buildContractCard(contracts[index]);
        },
      ),
    );
  }

  Widget _buildContractCard(ContractSummary contract) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        elevation: 4, // Same elevation as Card
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white, // Replicate the Card's default color
      ),
      onPressed: () {
        PersistentNavBarNavigator.pushNewScreen(context,
            screen: WebContracts(
              filtered: false,
              showAppbarAndSearch: true,
              isWareHouse: false,
              isSpot: false,
              contractType: contract.id,
              contractName: contract.contractType,
            ));
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            contract.count.toString(),
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.green.shade700,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            contract.contractType,
            textAlign: TextAlign.center,
            style: GoogleFonts.poppins(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade900,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
