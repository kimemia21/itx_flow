import 'package:bottom_navy_bar/bottom_navy_bar.dart';
import 'package:flutter/material.dart';
import 'package:itx/Contracts/Contracts.dart';
import 'package:itx/Contracts/Create.dart';
import 'package:itx/Contracts/MyContracts.dart';

class MyScaffold extends StatefulWidget {
  final Widget body;
  final bool hasDrawer;
  final String title;
  const MyScaffold(
      {super.key,
      required this.body,
      this.hasDrawer = false,
      required this.title});

  @override
  State<MyScaffold> createState() => _MyScaffoldState();
}

class _MyScaffoldState extends State<MyScaffold> {
  int _currentIndex = 0;

  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Bottom Nav Bar")),
      body: SizedBox.expand(
        child: PageView(
          controller: _pageController,
          onPageChanged: (index) {
            setState(() => _currentIndex = index);
          },
          children: <Widget>[
            Contracts(),
            CreateContract(),
            Container(
              color: Colors.green,
            ),
            Container(
              color: Colors.blue,
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavyBar(
        selectedIndex: _currentIndex,
        onItemSelected: (index) {
          setState(() => _currentIndex = index);
        
          _pageController.jumpToPage(index);
        },
        items: <BottomNavyBarItem>[
          BottomNavyBarItem(title: Text('Item One'), icon: Icon(Icons.home)),
          BottomNavyBarItem(title: Text('Item Two'), icon: Icon(Icons.apps)),
          BottomNavyBarItem(
              title: Text('Item Three'), icon: Icon(Icons.chat_bubble)),
          BottomNavyBarItem(
              title: Text('Item Four'), icon: Icon(Icons.settings)),
        ],
      ),
    );
  }
}
