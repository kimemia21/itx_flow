import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Serializers/CommodityModel.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/global/AppBloc.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/requests/Requests.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:logging/logging.dart';

class Commodities extends StatefulWidget {
  final ScrollController? scrollController;
  const Commodities({Key? key, this.scrollController}) : super(key: key);

  @override
  State<Commodities> createState() => _CommoditiesState();
}

class _CommoditiesState extends State<Commodities> {
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

  Future<void> _loadCommodities(
      {required BuildContext context, required bool isFilter, text}) async {
    setState(() => isLoading = true);
    try {
      final stopwatch = Stopwatch()..start();
      allCommodities =
          await CommodityService.fetchCommodities(context, isFilter, text);
      stopwatch.stop();
      _logger.info('Commodities loaded in ${stopwatch.elapsedMilliseconds}ms');
    } catch (e) {
      _logger.severe('Error loading commodities: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text('Failed to load commodities. Please try again.'),
            backgroundColor: Colors.red),
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
    _logger.info(
        'Commodity ${commodity.name} toggled in ${stopwatch.elapsedMilliseconds}ms');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _buildAppBar(),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildHeader(),
            _buildSearchField(), // This will remain, but won't affect the list
            Expanded(child: _buildCommodityList()),
            _buildSelectedCommodities(),
            SizedBox(height: 16),
            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  AppBar _buildAppBar() {
    return AppBar(
      centerTitle: true,
      automaticallyImplyLeading: false,
      // leading: IconButton(
      //   onPressed: () => PersistentNavBarNavigator.pushNewScreen(context,
      //       screen: MainLoginScreen(), withNavBar: false),
      //   icon: Icon(Icons.arrow_back, color: Colors.white),
      // ),
      backgroundColor: Colors.green.shade800,
      title: Text('Commodities of Interest',
          style: GoogleFonts.poppins(
              color: Colors.white, fontWeight: FontWeight.w600, fontSize: 18)),
      actions: [
        IconButton(
          icon: Icon(Icons.refresh, color: Colors.white),
          onPressed: () {
            _loadCommodities(context: context, isFilter: false);
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text('Refreshing commodities...'),
                duration: Duration(seconds: 1)));
          },
        ),
      ],
    );
  }

  Widget _buildHeader() {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      alignment: Alignment.center,
      child: Text("Add Commodities of Interest",
          style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 22,
              color: Colors.green.shade800)),
    );
  }

  Widget _buildSearchField() {
    return TextField(
      decoration: InputDecoration(
        hintText: 'Search Commodities',
        prefixIcon: Icon(Icons.search),
        border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      onChanged: (text) {
        _loadCommodities(context: context, isFilter: true, text: text);

        // Search field exists, but doesn't filter anymore
      },
    );
  }

  Widget _buildCommodityList() {
    if (isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    if (allCommodities.isEmpty) {
      return Center(
  child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.warning_amber_rounded, size: 48, color: Colors.black54),
      SizedBox(height: 10),
      Text(
        'No commodities available',
        style: GoogleFonts.poppins(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: Colors.black54,
        ),
        textAlign: TextAlign.center,
      ),
      SizedBox(height: 5),
      // Text(
      //   'Please check back later.',
      //   style: GoogleFonts.poppins(
      //     fontSize: 16,
      //     fontWeight: FontWeight.w400,
      //     color: Colors.grey.shade600,
      //   ),
      //   textAlign: TextAlign.center,
      // ),
    ],
  ),
);

    }
    return ListView.builder(
      itemCount: allCommodities.length,
      itemBuilder: (context, index) {
        final commodity = allCommodities[index];
        return Card(
          margin: EdgeInsets.symmetric(vertical: 6.0),
          elevation: 2,
          child: ListTile(
            onTap: () => _toggleCommodity(commodity),
            trailing: Checkbox(
              value: userItems.contains(commodity.name),
              activeColor: Colors.green.shade800,
              onChanged: (bool? value) => _toggleCommodity(commodity),
            ),
            title: Text(commodity.name!,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600, color: Colors.black87)),
            subtitle: Text(commodity.packagingName!,
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400, color: Colors.grey.shade700)),
          ),
        );
      },
    );
  }

  Widget _buildSelectedCommodities() {
    return Text(
      userItems.isNotEmpty
          ? 'Selected: ${userItems.join(', ')}'
          : "No commodities selected",
      style: GoogleFonts.poppins(
          fontSize: 16,
          fontWeight: FontWeight.w600,
          color: Colors.green.shade800),
    );
  }

  Widget _buildSubmitButton() {
    return GestureDetector(
      onTap: _submitCommodities,
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
                offset: Offset(0, 3))
          ],
        ),
        child: context.watch<appBloc>().isLoading
            ? LoadingAnimationWidget.staggeredDotsWave(
                color: Colors.white, size: 20)
            : Text("Done",
                style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    fontSize: 20)),
      ),
    );
  }

  void _submitCommodities() {
    if (userItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.black,
          content: Text("Please select a commodity",
              style: GoogleFonts.poppins(
                  fontWeight: FontWeight.w600,
                  fontSize: 16,
                  color: Colors.white)),
        ),
      );
    } else {
      String user_type = Provider.of<appBloc>(context, listen: false).user_type;
      AuthRequest.UserCommodities(
          context: context,
          user_type: user_type,
          commodities: userItemsId.toList());
    }
  }
}
