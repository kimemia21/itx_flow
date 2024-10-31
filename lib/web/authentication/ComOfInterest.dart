import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:itx/web/global/WebGlobals.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class WebCommoditiesOfInterest extends StatefulWidget {
  final bool isWareHouse;
  const WebCommoditiesOfInterest({Key? key, required this.isWareHouse}) : super(key: key);

  @override
  State<WebCommoditiesOfInterest> createState() => _WebCommoditiesOfInterestState();
}

class _WebCommoditiesOfInterestState extends State<WebCommoditiesOfInterest> {
  final Set<String> userItems = {};
  final Set<int> userItemsId = {};
  List<Commodity> allCommodities = [];
  bool isLoading = true;
  final Logger _logger = Logger('Commodities');

  @override
  void initState() {
    super.initState();
    _loadCommodities(context: context, isFilter: false);
  }

  Future<void> _loadCommodities({
    required BuildContext context,
    required bool isFilter,
    String? text,
  }) async {
    setState(() => isLoading = true);
    try {
      final stopwatch = Stopwatch()..start();
      allCommodities = await CommodityService.fetchCommodities(context, isFilter, text);
      stopwatch.stop();
      _logger.info('Commodities loaded in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e) {
      _logger.severe('Error loading commodities: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to load commodities.Please try again.'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      setState(() => isLoading = false);
    }
  }

  void _toggleCommodity(Commodity commodity) {
    final stopwatch = Stopwatch()..start();
    setState(() {
      if (userItems.contains(commodity.name)) {
        userItems.remove(commodity.name);
        userItemsId.remove(commodity.id);
      } else {
        userItems.add(commodity.name!);
        userItemsId.add(commodity.id!);
      }
      context.read<appBloc>().changeCommodites(userItems.toList());
    });
    stopwatch.stop();
    _logger.info('Commodity ${commodity.name} toggled in ${stopwatch.elapsedMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade300,
      body: LayoutBuilder(
        builder: (context, constraints) {
          double screenWidth = MediaQuery.of(context).size.width;
          double screenHeight = MediaQuery.of(context).size.height;
          bool isMobile = screenWidth < 900;

          return Center(
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              constraints: BoxConstraints(maxWidth: 1200),
              child: Card(
                elevation: 30,
                shadowColor: Colors.black.withOpacity(0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Container(
                    height: isMobile ? screenHeight * 0.9 : screenHeight * 0.85,
                    color: Colors.white,
                    child: Column(
                      children: [
                        _buildAppBar(),
                        Expanded(
                          child: SingleChildScrollView(
                            padding: EdgeInsets.all(isMobile ? 20 : 40),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                _buildHeader(),
                                SizedBox(height: 10),
                                _buildSearchField(),
                                SizedBox(height: 10),
                                _buildCommodityList(),
                                SizedBox(height: 5),
                                Visibility(
                                  visible: userItems.isNotEmpty,
                                  child:
                                _buildSelectedCommodities(),),
                                SizedBox(height: 10),
                                _buildSubmitButton(),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildAppBar() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Webglobals.itxLogo(),
          Expanded(
            child: Text(
              'Commodities of Interest',
              textAlign: TextAlign.center,
              style: GoogleFonts.poppins(
                fontSize: 22,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade400,
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.refresh, color: Colors.green.shade400),
            onPressed: () {
              _loadCommodities(context: context, isFilter: false);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Refreshing commodities...'),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  backgroundColor: Colors.green.shade400,
                  duration: Duration(seconds: 1),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Text(
      "Select Commodities of Interest",
      style: GoogleFonts.poppins(
        fontSize: 20,
        fontWeight: FontWeight.w500,
        color: Colors.grey.shade600,
      ),
    );
  }

  Widget _buildSearchField() {
    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: TextField(
        style: GoogleFonts.poppins(
          fontSize: 16,
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: 'Search Commodities',
          hintStyle: GoogleFonts.poppins(color: Colors.grey.shade400),
          prefixIcon: Icon(Icons.search, color: Colors.grey.shade400),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          contentPadding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
        ),
        onChanged: (text) {
          _loadCommodities(context: context, isFilter: true, text: text);
        },
      ),
    );
  }

  Widget _buildCommodityList() {
    if (isLoading) {
      return Container(
        height: 300,
        child: Center(
          child: LoadingAnimationWidget.staggeredDotsWave(
            color: Colors.green.shade400,
            size: 40,
          ),
        ),
      );
    }

    if (allCommodities.isEmpty) {
      return Container(
        height: 300,
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.inventory_2_outlined,
                  size: 64, color: Colors.grey.shade400),
              SizedBox(height: 16),
              Text(
                'No commodities available',
                style: GoogleFonts.poppins(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      width: MediaQuery.of(context).size.width * 0.4,
      child: Card(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: BorderSide(color: Colors.grey.shade200),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: allCommodities.length,
          separatorBuilder: (context, index) => Divider(height: 1),
          itemBuilder: (context, index) {
            final commodity = allCommodities[index];
            return ListTile(
              selectedTileColor: Colors.green.shade200,
              onTap: () => _toggleCommodity(commodity),
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              title: Text(
                commodity.name!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              subtitle: Text(
                commodity.packagingName!,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  color: Colors.grey.shade600,
                ),
              ),
              trailing: Checkbox(
                value: userItems.contains(commodity.name),
                activeColor: Colors.green.shade400,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4),
                ),
                onChanged: (bool? value) => _toggleCommodity(commodity),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildSelectedCommodities() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 24),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Selected Commodities',
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.grey.shade700,
            ),
          ),
          SizedBox(height: 8),
          Text(
            userItems.isNotEmpty
                ? userItems.join(', ')
                : "No commodities selected",
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 50,
      child: MaterialButton(
        onPressed: _submitCommodities,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        color: Colors.green.shade400,
        elevation: 0,
        highlightElevation: 0,
        child: context.watch<appBloc>().isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white,
                size: 20,
              )
            : Text(
                "Done",
                style: GoogleFonts.poppins(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }

  void _submitCommodities() {
    if (userItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Please select at least one commodity",
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } else {
      AuthRequest.UserCommodities(
        isWarehouse: widget.isWareHouse,
        isWeb: true,
        context: context,
        commodities: userItemsId.toList(),
      );
    }
  }
}