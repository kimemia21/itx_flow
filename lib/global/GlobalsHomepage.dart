import 'dart:convert';

import 'package:cherry_toast/cherry_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_client_sse/constants/sse_request_type_enum.dart';
import 'package:flutter_client_sse/flutter_client_sse.dart';
import 'package:itx/Commodities.dart/Commodites.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/SpecificOrder.dart';
import 'package:itx/Contracts/SpotItem.dart';
import 'package:itx/Contracts/SpotTrader.dart';
import 'package:itx/Serializers/ChatMessages.dart';
import 'package:itx/Serializers/TestPage.dart';
import 'package:itx/chatbox/chatNotifications.dart';
import 'package:itx/global/WatchList.dart';
import 'package:itx/global/comms.dart';
import 'package:itx/homepage/UserHomepage.dart';
import 'package:itx/myOrders.dart/MyOrders.dart';
import 'package:itx/requests/HomepageRequest.dart';
import 'package:itx/rss/RSSFEED.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';
import 'package:another_flushbar/flushbar.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = PersistentTabController();
    Sse();
  }
void Sse() {
  SSEClient.subscribeToSSE(
    method: SSERequestType.GET,
    url: grace_ip,
    header: {
      "x-auth-token": currentUser.token,
      "Accept": "text/event-stream",
      "Cache-Control": "no-cache",
    },
  ).listen(
    (event) {
      try {
        Map<String, dynamic> data = jsonDecode(event.data!);
        final List<dynamic> data2 = data["unreadMessages"];

        final List<ChatsMessages> messages =
            data2.map((json) => ChatsMessages.fromJson(json)).toList();

        final appBloc bloc = context.read<appBloc>();
        if (messages.length > bloc.Messages.length) {
          bloc.changeMessages(messages); // Update the bloc state

          // Show the alert for the newest message
          final latestMessage = messages.last;
          showNotification(
            context,
            title: latestMessage.senderName,
            message: latestMessage.message,
            length:bloc.Messages.length, 
          );
        }
      } catch (e) {
        print("event error $e");
      }
    },
  );
}



void showNotification(BuildContext context, {
  required String title, 
  required String message, 
  required int length
}) {
  Flushbar(
    title: title,
    titleColor: Colors.white,
    message: message,
    messageText: Row(
      children: [
        Text(
          "Unread Messages: $length", 
          style: TextStyle(
            color: Colors.white.withOpacity(0.9),
            fontWeight: FontWeight.w500,
          ),
        ),
        const Spacer(),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white24,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            '$length',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        )
      ],
    ),
    icon: Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.white24,
      ),
      child: const Icon(
        Icons.notifications_outlined,
        size: 28.0,
        color: Colors.white,
      ),
    ),
    duration: const Duration(seconds: 20), 
    flushbarPosition: FlushbarPosition.TOP,
    backgroundColor: Colors.black87,
    margin: const EdgeInsets.all(8),
    borderRadius: BorderRadius.circular(16),
    boxShadows: [
      BoxShadow(
        color: Colors.black.withOpacity(0.2),
        blurRadius: 15,
        offset: const Offset(0, 5),
      )
    ],
    mainButton: IconButton(
      icon: const Icon(
        Icons.close, 
        color: Colors.white70,
      ),
      onPressed: () {
        // You can add additional logic here if needed
      },
    ),
  ).show(context);
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
      UserOrdersScreen(),
      RSSFeedView()
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
        PersistentBottomNavBarItem(
          icon: const Icon(Icons.library_books),
          title: "News",
          activeColorPrimary: Colors.red,
          inactiveColorPrimary: Colors.grey,
        ),
      ];

  @override
  Widget build(BuildContext context) {
    return context.watch<appBloc>().user_type == 6
        ? Contracts(
            contractName: "WareHouse",
            isSpot: false,
            filtered: false,
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
