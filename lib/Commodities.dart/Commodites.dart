import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/authentication/Documents.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class Commodities extends StatefulWidget {
  final ScrollController? scrollController;
  const Commodities({this.scrollController});

  @override
  State<Commodities> createState() => _CommoditiesState();
}

class _CommoditiesState extends State<Commodities> {
  List<String> userItems = [];
  List<int> userItemsId = [];
  String searchText = '';
  List<Commodity> allCommodities = [];
  List<Commodity> filteredCommodities = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCommodities();
  }

  Future<void> _loadCommodities() async {
    setState(() {
      isLoading = true;
    });
    try {
      allCommodities = await CommodityService.fetchCommodities(context);
      _filterCommodities();
    } catch (e) {
      print("Error loading commodities: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load commodities. Please try again.'),
          backgroundColor: Colors.red,
        ),
      );
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _filterCommodities() {
    setState(() {
      if (searchText.isEmpty) {
        filteredCommodities = List.from(allCommodities);
      } else {
        filteredCommodities = allCommodities
            .where((commodity) =>
                commodity.name
                    .toLowerCase()
                    .contains(searchText.toLowerCase()) ||
                commodity.packagingName
                    .toLowerCase()
                    .contains(searchText.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 255, 255, 1),
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: false,
        leading: IconButton(
          onPressed: () => PersistentNavBarNavigator.pushNewScreen(
            withNavBar: false,
            context,
            screen: MainLoginScreen(),
          ),
          icon: Icon(color: Colors.white, Icons.arrow_back),
        ),
        backgroundColor: Colors.green.shade800,
        title: Text(
          'Commodities of Interest',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 18,
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.white),
            onPressed: () {
              _loadCommodities();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshing commodities...'),
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              margin: EdgeInsets.only(bottom: 10),
              alignment: Alignment.center,
              child: Text(
                "Add Commodities of Interest",
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 22,
                  color: Colors.green.shade800,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: TextField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  labelText: 'Search Commodities',
                  labelStyle: TextStyle(color: Colors.green.shade800),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.green.shade800,
                  ),
                  fillColor: Colors.green.shade50,
                  filled: true,
                ),
                onChanged: (text) {
                  setState(() {
                    searchText = text;
                    _filterCommodities();
                  });
                },
              ),
            ),
            Expanded(
              child: isLoading
                  ? Center(child: CircularProgressIndicator())
                  : filteredCommodities.isEmpty
                      ? Center(
                          child: Text(
                            'No commodities available',
                            style: GoogleFonts.poppins(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                              color: Colors.red.shade600,
                            ),
                          ),
                        )
                      : ListView.builder(
                          itemCount: filteredCommodities.length,
                          itemBuilder: (context, index) {
                            final commodity = filteredCommodities[index];
                            return Card(
                              margin: EdgeInsets.symmetric(vertical: 6.0),
                              elevation: 2,
                              child: ListTile(
                                onTap: () {
                                  setState(() {
                                    if (userItems.contains(commodity.name)) {
                                      userItems.remove(commodity.name);
                                      userItemsId.remove(commodity.id);
                                    } else {
                                      userItems.add(commodity.name);
                                      userItemsId.add(commodity.id);
                                    }
                                    context
                                        .read<appBloc>()
                                        .changeCommodites(userItems);
                                  });
                                },
                                trailing: Checkbox(
                                  value: userItems.contains(commodity.name),
                                  activeColor: Colors.green.shade800,
                                  onChanged: (bool? value) {
                                    setState(() {
                                      if (value!) {
                                        userItems.add(commodity.name);
                                        userItemsId.add(commodity.id);
                                      } else {
                                        userItems.remove(commodity.name);
                                        userItemsId.remove(commodity.id);
                                      }
                                      context
                                          .read<appBloc>()
                                          .changeCommodites(userItems);
                                    });
                                  },
                                ),
                                title: Text(
                                  commodity.name,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    color: Colors.black87,
                                  ),
                                ),
                                subtitle: Text(
                                  commodity.packagingName,
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w400,
                                    color: Colors.grey.shade700,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
            ),
            Text(
              userItems.isNotEmpty
                  ? 'Selected: ${userItems.join(', ')}'
                  : "No commodities selected",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.green.shade800,
              ),
            ),
            SizedBox(height: 16),
            Align(
              alignment: Alignment.bottomCenter,
              child: GestureDetector(
                onTap: () {
                  if (userItems.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        backgroundColor: Colors.black,
                        content: Text(
                          "Please select a commodity",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            fontSize: 16,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    );
                  } else {
                    String user_type =
                        Provider.of<appBloc>(context, listen: false).user_type;
                    AuthRequest.UserCommodities(
                        context: context,
                        user_type: user_type,
                        commodities: userItemsId);
                  }
                },
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width * 0.8,
                  height: 50,
                  decoration: BoxDecoration(
                    color: Colors.green.shade800,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.green.withOpacity(0.3),
                        blurRadius: 5,
                        spreadRadius: 2,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: context.watch<appBloc>().isLoading
                      ? Center(
                          child: LoadingAnimationWidget.staggeredDotsWave(
                          color: Colors.white,
                          size: 20,
                        ))
                      : Text(
                          "Done",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            fontSize: 20,
                          ),
                        ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}