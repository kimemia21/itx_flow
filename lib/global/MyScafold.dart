import 'package:flutter/material.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class MyHomepage extends StatefulWidget {
  final int initialIndex;
  final Widget? newScreen;

  // Add default values for the constructor parameters
  MyHomepage({this.initialIndex = 0, this.newScreen});

  @override
  _MyHomepageState createState() => _MyHomepageState();
}

class _MyHomepageState extends State<MyHomepage> {
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

  List<CustomNavBarScreen> _buildScreens() => [
        CustomNavBarScreen(
            routeAndNavigatorSettings: RouteAndNavigatorSettings(
              initialRoute: "/",
              routes: {
                "/first": (final context) =>
                    Commodites(scrollController: _scrollControllers.first),
                "/second": (final context) =>
                    Commodites(scrollController: _scrollControllers.first),
              },
            ),
            screen: Commodites(scrollController: _scrollControllers.first)),
        CustomNavBarScreen(
            screen: Commodites(scrollController: _scrollControllers.first)),
        CustomNavBarScreen(
            screen: Commodites(scrollController: _scrollControllers.first)),
        CustomNavBarScreen(
            screen: Commodites(scrollController: _scrollControllers.first)),
        CustomNavBarScreen(
            screen: Commodites(scrollController: _scrollControllers.first)),
      ];

  // List<PersistentBottomNavBarItem> is just for example here. It can be anything you want like List<YourItemWidget>
  List<PersistentBottomNavBarItem> _navBarsItems() => [
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.home),
          title: "Home",
          activeColorPrimary: Colors.blue,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.visibility),
          title: "Watchlist",
          activeColorPrimary: Colors.teal,
          inactiveColorPrimary: Colors.grey,
        ),
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.bar_chart),
          title: "Market",
          activeColorPrimary: Colors.deepOrange,
          inactiveColorPrimary: Colors.grey,
        ),
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
  Widget build(final BuildContext context) => Scaffold(
        // appBar: AppBar(title: const Text("Navigation Bar Demo")),
        drawer: const Drawer(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text("This is the Drawer"),
              ],
            ),
          ),
        ),
        body: PersistentTabView.custom(
          context,
          controller: _controller,
          screens: _buildScreens(),
          itemCount: 5,
          isVisible: !_hideNavBar,
          hideOnScrollSettings: HideOnScrollSettings(
            hideNavBarOnScroll: true,
            scrollControllers: _scrollControllers,
          ),
          backgroundColor: Colors.grey.shade900,
          customWidget: CustomNavBarWidget(
            _navBarsItems(),
            onItemSelected: (final index) {
              //Scroll to top
              if (index == _controller.index) {
                _scrollControllers[index].animateTo(0,
                    duration: const Duration(milliseconds: 100),
                    curve: Curves.ease);
              }

              setState(() {
                _controller.index = index; // THIS IS CRITICAL!! Don't miss it!
              });
            },
            selectedIndex: _controller.index,
          ),
        ),
      );
}

class CustomNavBarWidget extends StatelessWidget {
  const CustomNavBarWidget(
    this.items, {
    required this.selectedIndex,
    required this.onItemSelected,
    final Key? key,
  }) : super(key: key);
  final int selectedIndex;
  // List<PersistentBottomNavBarItem> is just for example here. It can be anything you want like List<YourItemWidget>
  final List<PersistentBottomNavBarItem> items;
  final ValueChanged<int> onItemSelected;

  Widget _buildItem(
          final PersistentBottomNavBarItem item, final bool isSelected) =>
      Container(
        alignment: Alignment.center,
        height: kBottomNavigationBarHeight,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Flexible(
              child: IconTheme(
                data: IconThemeData(
                    size: 26,
                    color: isSelected
                        ? (item.activeColorSecondary ?? item.activeColorPrimary)
                        : item.inactiveColorPrimary ?? item.activeColorPrimary),
                child: isSelected ? item.icon : item.inactiveIcon ?? item.icon,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Material(
                type: MaterialType.transparency,
                child: FittedBox(
                    child: Text(
                  item.title ?? "",
                  style: TextStyle(
                      color: isSelected
                          ? (item.activeColorSecondary ??
                              item.activeColorPrimary)
                          : item.inactiveColorPrimary,
                      fontWeight: FontWeight.w400,
                      fontSize: 12),
                )),
              ),
            )
          ],
        ),
      );

  @override
  Widget build(final BuildContext context) => Container(
        color: Colors.grey.shade900,
        child: SizedBox(
          width: double.infinity,
          height: kBottomNavigationBarHeight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: items.map((final item) {
              final int index = items.indexOf(item);
              return Flexible(
                child: GestureDetector(
                  onTap: () {
                    onItemSelected(index);
                  },
                  child: _buildItem(item, selectedIndex == index),
                ),
              );
            }).toList(),
          ),
        ),
      );
}
