// import 'package:flutter/material.dart';
// import 'package:itx/global/app.dart';

// class TabItem {
//   final String tabName;
//   final IconData icon;
//   final GlobalKey<NavigatorState> key = GlobalKey<NavigatorState>();
//   final Widget page;

//   TabItem({
//     required this.tabName,
//     required this.icon,
//     required this.page,
//   });

//   Widget buildPage(int currentTab) {
//     return Offstage(
//       offstage: currentTab != AppState.currentTab,
//       child: TickerMode(
//         enabled: currentTab == AppState.currentTab,
//         child: Navigator(
//           key: key,
//           onGenerateRoute: (routeSettings) {
//             return MaterialPageRoute(
//               builder: (_) => page,
//             );
//           },
//         ),
//       ),
//     );
//   }
// }
