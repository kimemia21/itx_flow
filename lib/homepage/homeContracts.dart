import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Serializers/ContractSerializer.dart';
import 'package:itx/global/appbar.dart';
import 'package:itx/homepage/homeOrders.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class HomepageContractsWidget extends StatefulWidget {
  final int displayCount;
  final bool filtered;

  const HomepageContractsWidget({
    Key? key,
    this.displayCount = 6,
    this.filtered = false,
  }) : super(key: key);

  @override
  _HomepageContractsWidgetState createState() =>
      _HomepageContractsWidgetState();
}

class _HomepageContractsWidgetState extends State<HomepageContractsWidget> {
  late Future<List<ContractsModel>> _contractsFuture;

  @override
  void initState() {
    super.initState();
    _contractsFuture = fetchContracts();
  }

  Future<List<ContractsModel>> fetchContracts() async {
    return CommodityService.getContracts(
      context,
      widget.filtered ? "this_user_liked=1" : "",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white),
      child: FutureBuilder<List<ContractsModel>>(
        future: _contractsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('No contracts available'),
                const SizedBox(height: 20), // Spacing between text and button
                ElevatedButton(
                  onPressed: () {
                    PersistentNavBarNavigator.pushNewScreen(context,
                        screen: Contracts(
                            filtered: false, showAppbarAndSearch: true));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue.shade700, // Button color
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(30), // Rounded corners
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 30, vertical: 15), // Button size
                    elevation: 5, // Elevation for shadow effect
                  ),
                  child: Text(
                    'View Contracts',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white, // Text color
                      fontWeight: FontWeight.bold, // Bold text
                    ),
                  ),
                ),
              ],
            );
          } else {
            List<ContractsModel> contracts = snapshot.data!;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Available Contracts',
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                          color: Colors.green.shade800,
                        ),
                      ),
                      TextButton(
                          onPressed: () =>
                              PersistentNavBarNavigator.pushNewScreen(
                                  withNavBar: true,
                                  context,
                                  screen: Contracts(
                                    filtered: false,
                                    showAppbarAndSearch: true,
                                  )),
                          child: Text(
                            'See all',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                              color: Colors.blue,
                            ),
                          )),
                    ],
                  ),
                ),
                GridView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.8,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: contracts.length > widget.displayCount
                      ? widget.displayCount
                      : contracts.length,
                  itemBuilder: (context, index) {
                    final contract = contracts[index];
                    return _buildContractItem(context, contract);
                  },
                ),
              ],
            );
          }
        },
      ),
    );
  }

  Widget _buildContractItem(BuildContext context, ContractsModel contract) {
    return GestureDetector(
      onTap: () {
        PersistentNavBarNavigator.pushNewScreen(
          context,
          screen: Specificorder(
            // productName: "contract",
            // companyId: contract.userCompanyId.toString(),
            // item: contract.name,
            // price: contract.price,
            contract: contract,
            // quantity: contract.qualityGradeId.toString(),
          ),
        );
      },
      child: Container(
        height: 180, // Reduced height
        width: 150, // Added width constraint
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.green.withOpacity(0.1),
              spreadRadius: 1,
              blurRadius: 4,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(12)),
                  child: Image.network(
                    contract.imageUrl,
                    height: 80, // Reduced height
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 5,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
            ),
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    contract.name,
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                      color: Colors.green.shade800,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  SizedBox(height: 2),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "\$${contract.price.toStringAsFixed(2)}",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Colors.green.shade600,
                        ),
                      ),
                      Container(
                        padding:
                            EdgeInsets.symmetric(horizontal: 6, vertical: 2),
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
