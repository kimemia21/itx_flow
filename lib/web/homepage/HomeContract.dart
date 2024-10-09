import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class WebHomepageContracts extends StatefulWidget {
  final int displayCount;
  final bool filtered;

  const WebHomepageContracts({
    Key? key,
    this.displayCount = 6,
    this.filtered = false,
  }) : super(key: key);

  @override
  _WebHomepageContractsState createState() => _WebHomepageContractsState();
}

class _WebHomepageContractsState extends State<WebHomepageContracts> {
  late Future<List<ContractsModel>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = fetchContracts();
  }

  Future<List<ContractsModel>> fetchContracts() async {
    return CommodityService.getContracts(
      isSpot: false,
      context: context,
      isWatchList: false,
      isWareHouse: Provider.of<appBloc>(context, listen: false).user_type == 6
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      child: FutureBuilder<List<ContractsModel>>(
        future: _contractsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${snapshot.error}'),
                  const SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      setState(() {
                        _contractsFuture = fetchContracts();
                      });
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return _buildNoContractsView();
          } else {
            List<ContractsModel> contracts = snapshot.data!;
            return _buildContractsList(contracts);
          }
        },
      ),
    );
  }

  Widget _buildNoContractsView() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('No Trades available'),
        const SizedBox(height: 20),
        ElevatedButton(
          onPressed: () {
            PersistentNavBarNavigator.pushNewScreen(
              context,
              screen: Contracts(
                isSpot: false,
                filtered: false,
                showAppbarAndSearch: true,
                isWareHouse: context.watch<appBloc>().user_type == 6,
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue.shade700,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            elevation: 5,
          ),
          child: const Text(
            'View Trades',
            style: TextStyle(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContractsList(List<ContractsModel> contracts) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildHeader(),
        _buildContractsGrid(contracts),
      ],
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Available Trades',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
              color: Colors.grey.shade600,
            ),
          ),
          // TextButton(
          //   onPressed: () {
          //     PersistentNavBarNavigator.pushNewScreen(
          //       context,
          //       screen: Contracts(
          //         isSpot: false,
          //         filtered: false,
          //         showAppbarAndSearch: true,
          //         isWareHouse: Provider.of<appBloc>(context, listen: false).user_type == 6,
          //       ),
          //     );
          //   },
          //   child: Text(
          //     'See all',
          //     style: GoogleFonts.poppins(
          //       fontSize: 18,
          //       fontWeight: FontWeight.w500,
          //       color: Colors.blue,
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }

  Widget _buildContractsGrid(List<ContractsModel> contracts) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final double width = constraints.maxWidth;
        final int crossAxisCount = _calculateCrossAxisCount(width);
        final double aspectRatio = _calculateAspectRatio(width);

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            childAspectRatio: aspectRatio,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
          ),
          itemCount: contracts.length > widget.displayCount
              ? widget.displayCount
              : contracts.length,
          itemBuilder: (context, index) {
            final contract = contracts[index];
            return _buildContractItem(context, contract);
          },
        );
      },
    );
  }

  int _calculateCrossAxisCount(double width) {
    if (width > 1200) return 4;
    if (width > 900) return 3;
    if (width > 600) return 2;
    return 1;
  }

  double _calculateAspectRatio(double width) {
    if (width > 1200) return 1.2;
    if (width > 900) return 1.1;
    if (width > 600) return 1.0;
    return 0.9;
  }

  Widget _buildContractItem(BuildContext context, ContractsModel contract) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: Specificorder(contract: contract),
        );
      },
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildContractImage(contract),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: _buildContractDetails(contract),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContractImage(ContractsModel contract) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
          child: Image.network(
            contract.imageUrl,
            height: 120,
            width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
        Positioned(
          top: 5,
          right: 5,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.green.withOpacity(0.8),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              contract.contractType,
              style: GoogleFonts.poppins(
                fontSize: 10,
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildContractDetails(ContractsModel contract) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              contract.name,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: Colors.green.shade800,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 4),
            Text(
              contract.description,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                fontSize: 12,
                color: Colors.black87,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "\$${contract.price.toStringAsFixed(2)}",
              style: GoogleFonts.poppins(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade600,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: Colors.orange.withOpacity(0.2),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                DateFormat('MMM d').format(contract.deliveryDate),
                style: GoogleFonts.poppins(
                  fontSize: 10,
                  color: Colors.orange.shade800,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}