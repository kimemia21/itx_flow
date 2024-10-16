import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Contracts/SpotItem.dart';
import 'package:itx/Contracts/SpotTrader.dart';
import 'package:itx/Serializers/TestPage.dart';
import 'package:itx/global/WatchList.dart';
import 'package:itx/homepage/UserHomepage.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class GlobalsHomePage extends StatefulWidget {
  final int initialIndex;
  final Widget? newScreen;

  // Add default values for the constructor parameters
  GlobalsHomePage({this.initialIndex = 0, this.newScreen});

  @override
  _GlobalsHomePageState createState() => _GlobalsHomePageState();
}

class _GlobalsHomePageState extends State<GlobalsHomePage> {
  late PersistentTabController _controller;
  final List<ScrollController> _scrollControllers = [
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
    ScrollController(),
  ];
  late bool _hideNavBar;

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    _hideNavBar = false;
  }

  @override
  void dispose() {
    for (final element in _scrollControllers) {
      element.dispose();
    }
    super.dispose();
  }

  List<Widget> _buildScreens() {
    return [
      Userhomepage(),

      Contracts(
          contractName: "WatchList",
          isSpot: false,
          filtered: true,
          showAppbarAndSearch: true,
          isWareHouse: context.watch<appBloc>().user_type == 6),
//

      Spottrader(),
      UserOrdersScreen()
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.green.shade300,
          inactiveColorPrimary: Colors.green,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.visibility),
          title: "Watchlist",
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: Colors.grey,
        ),
        // PersistentBottomNavBarItem(
        //   icon: const Icon(Icons.bar_chart),
        //   title: "Market",
        //   activeColorPrimary: Colors.deepOrange,
        //   inactiveColorPrimary: Colors.grey,
        // ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.attach_money_outlined),
          title: "Trades",
          activeColorPrimary: Colors.indigo,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.person),
          title: "Account",
          activeColorPrimary: Colors.indigo,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return context.watch<appBloc>().user_type == 6
        ? Contracts(
           contractName:"WareHouse",
            isSpot: false,
            filtered: true,
            showAppbarAndSearch: true,
            isWareHouse: context.watch<appBloc>().user_type == 6,
          )
        : PersistentTabView(
            context,
            controller: _controller,
            screens: _buildScreens(),
            items: _navBarsItems(),
            handleAndroidBackButtonPress: true, // Default is true.
            resizeToAvoidBottomInset:
                true, // This needs to be true if you want to move up the screen on a non-scrollable screen when keyboard appears. Default is true.
            stateManagement: true, // Default is true.
            hideNavigationBarWhenKeyboardAppears: true,
            // popBehaviorOnSelectedNavBarItemPress: PopActionScreensType.all,
            padding: const EdgeInsets.only(top: 8),
            backgroundColor: Colors.grey.shade200,
            isVisible: true,
            animationSettings: const NavBarAnimationSettings(
              navBarItemAnimation: ItemAnimationSettings(
                // Navigation Bar's items animation properties.
                duration: Duration(milliseconds: 300),
                curve: Curves.ease,
              ),
              screenTransitionAnimation: ScreenTransitionAnimationSettings(
                // Screen transition animation on change of selected tab.
                animateTabTransition: true,
                duration: Duration(milliseconds: 400),
                screenTransitionAnimationType:
                    ScreenTransitionAnimationType.fadeIn,
              ),
            ),
            confineToSafeArea: true,
            navBarHeight: kBottomNavigationBarHeight,
            navBarStyle: NavBarStyle
                .style9, // Choose the nav bar style with this property
          );
  }
}
