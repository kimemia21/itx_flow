import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:itx/web/SpotPage/WebSpot.dart';
import 'package:itx/web/contracts/Contract.dart';
import 'package:itx/web/homepage/WebHomepage.dart';
import 'package:itx/web/orders/orders.dart';
import 'package:provider/provider.dart';

class WebNav extends StatefulWidget {
  final int initialIndex;

  WebNav({this.initialIndex = 0});

  @override
  _WebNavState createState() => _WebNavState();
}

class _WebNavState extends State<WebNav> {
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
  }

  List<Widget> _buildScreens() {
    return [
      WebHomePage(),
      WebContracts(
          isSpot: false,
          filtered: true,
          showAppbarAndSearch: true,
          isWareHouse: context.watch<appBloc>().user_type == 6),
      WebSpottrader(),
      WebOrdersScreen()
    ];
  }

  List<String> _navItems() => ["Home", "Watchlist", "Trades", "Account"];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
            children: [
              _buildPersistentNavBar(constraints),
              Expanded(
                child: _buildScreens()[_selectedIndex],
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildPersistentNavBar(BoxConstraints constraints) {
    bool isDesktop = constraints.maxWidth > 600;

    return Container(
      decoration: BoxDecoration(
        color: Colors.green,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 3,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'iTea-X',
                style: GoogleFonts.abel(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white),
              ),
              if (isDesktop)
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: List.generate(_navItems().length, (index) {
                    return _buildNavItem(index);
                  }),
                )
              else
                IconButton(
                  icon: Icon(Icons.menu, color: Colors.white),
                  onPressed: () {
                    _showMobileNavDrawer(context);
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    bool isSelected = _selectedIndex == index;
    return InkWell(
      onTap: () => _onItemTapped(index),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: isSelected ? Colors.white : Colors.transparent,
              width: 2,
            ),
          ),
        ),
        child: Text(
          _navItems()[index],
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.white70,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }

  void _showMobileNavDrawer(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: _navItems().asMap().entries.map((entry) {
              int idx = entry.key;
              String val = entry.value;
              return ListTile(
                leading: Icon(_getIconForItem(val)),
                title: Text(val),
                selected: _selectedIndex == idx,
                onTap: () {
                  _onItemTapped(idx);
                  Navigator.pop(context);
                },
              );
            }).toList(),
          ),
        );
      },
    );
  }

  IconData _getIconForItem(String item) {
    switch (item) {
      case "Home":
        return Icons.home;
      case "Watchlist":
        return Icons.visibility;
      case "Trades":
        return Icons.attach_money_outlined;
      case "Account":
        return Icons.person;
      default:
        return Icons.error;
    }
  }
}
