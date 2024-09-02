import 'package:flutter/material.dart';

import 'package:easy_sidemenu/easy_sidemenu.dart';
import 'package:flutter/material.dart';
import 'package:itx/web/DocumentScreen.dart';
import 'package:itx/web/GlobalExchange.dart';
import 'package:itx/web/MetaTrading.dart';
import 'package:itx/web/NewContract.dart';

class MyHomepageWeb extends StatelessWidget {
  const MyHomepageWeb({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'easy_sidemenu Demo',
      theme: ThemeData(primarySwatch: Colors.blue, useMaterial3: false),
      home: const MyHomePageWeb(title: 'easy_sidemenu Demo'),
      debugShowCheckedModeBanner: false,
    );
  }
}

class MyHomePageWeb extends StatefulWidget {
  const MyHomePageWeb({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageWebState createState() => _MyHomePageWebState();
}

class _MyHomePageWebState extends State<MyHomePageWeb> {
  PageController pageController = PageController();
  SideMenuController sideMenu = SideMenuController();

  @override
  void initState() {
    sideMenu.addListener((index) {
      pageController.jumpToPage(index);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          SideMenu(
            controller: sideMenu,
            style: SideMenuStyle(
                showTooltip: true,
                displayMode: SideMenuDisplayMode.auto,
                openSideMenuWidth: 200,
                showHamburger: true,
                itemOuterPadding: EdgeInsets.all(5),
                iconSize: 20,
                hoverColor: Colors.blue[50],
                selectedHoverColor: Colors.blue[50],
                selectedColor: Colors.grey.shade300,
                selectedTitleTextStyle: const TextStyle(color: Colors.black),
                selectedIconColor: Colors.black,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                backgroundColor: Colors.white),
            title: Column(
              children: [
                ConstrainedBox(
                    constraints: const BoxConstraints(
                      maxHeight: 150,
                      maxWidth: 150,
                    ),
                    child: Text("Acme inc.")),
                const Divider(
                  indent: 8.0,
                  endIndent: 8.0,
                ),
              ],
            ),
            items: [
              SideMenuItem(
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                title: "Home",
                // icon: const Icon(Icons.home),
                tooltipContent: "This is a tooltip for Dashboard item",
              ),
              SideMenuItem(



                title: 'Market',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.supervisor_account),
              ),

              SideMenuItem(
                title: 'Orders',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: 'Contracts',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.supervisor_account),
              ),
              SideMenuItem(
                title: 'Profile',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.supervisor_account),
              ),
                   SideMenuItem(
                builder: (context, displayMode) {
                  return const Divider(
                    endIndent: 8,
                    indent: 8,
                  );
                },
              ),

              SideMenuItem(
                title: 'Settings',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
              ),
              SideMenuItem(
                title: 'Help',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.download),
              ),
         
              SideMenuItem(
                title: 'FeedBack',
                onTap: (index, _) {
                  sideMenu.changePage(index);
                },
                // icon: const Icon(Icons.settings),
              ),
       
            ],
          ),
          const VerticalDivider(
            width: 0,
          ),
          Expanded(
            child: PageView(
              controller: pageController,
              children: [
                Container(
                  color: Colors.white,
                  child:Metatrading()
                ),
                Container(
                  color: Colors.white,
                  child:  Center(
                    child: NewContractPage()
                  ),
                ),
                Container(
                  color: Colors.white,
                  child:  Center(
                    child: NewContractPage()
                  ),
                ),

                ContractsPage(),
                Container(
                  color: Colors.white,
                  child:  Center(
                    child: DocumentsScreen()
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Settings',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'Help',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),
                     Container(
                  color: Colors.white,
                  child: const Center(
                    child: Text(
                      'FeedBack',
                      style: TextStyle(fontSize: 35),
                    ),
                  ),
                ),

                // this is for SideMenuItem with builder (divider)
           
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ContractsPage extends StatefulWidget {
  @override
  _ContractsPageState createState() => _ContractsPageState();
}

class _ContractsPageState extends State<ContractsPage> {
  String _currentFilter = 'All';
  final List<Map<String, dynamic>> _contracts = [
    {
      'id': '#1',
      'status': 'Open',
      'quantity': 10000,
      'price': 0.2500,
      'balance': 512.000
    },
    {
      'id': '#2',
      'status': 'Open',
      'quantity': 5000,
      'price': 0.1000,
      'balance': 6.000
    },
    {
      'id': '#3',
      'status': 'Closed',
      'quantity': 15000,
      'price': 0.3010,
      'balance': 918.500
    },
    {
      'id': '#4',
      'status': 'Open',
      'quantity': 8000,
      'price': 0.1180,
      'balance': 355.000
    },
    {
      'id': '#5',
      'status': 'Closed',
      'quantity': 12000,
      'price': 0.2540,
      'balance': 814.000
    },
  ];

  List<Map<String, dynamic>> get filteredContracts {
    if (_currentFilter == 'All') return _contracts;
    return _contracts
        .where((contract) => contract['status'] == _currentFilter)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Your contracts',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey.shade300,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Icon(Icons.search, color: Colors.grey),
                  // SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                _buildFilterButton('All'),
                SizedBox(width: 8),
                _buildFilterButton('Open'),
                SizedBox(width: 8),
                _buildFilterButton('Closed'),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: DataTable(
                  decoration: BoxDecoration(
                      borderRadius: BorderRadiusDirectional.circular(10)),
                  columns: [
                    DataColumn(label: Text('Contract')),
                    DataColumn(label: Text('Status')),
                    DataColumn(label: Text('Quantity')),
                    DataColumn(label: Text('Price')),
                    DataColumn(label: Text('Balance')),
                    DataColumn(label: Text('Actions')),
                  ],
                  rows: filteredContracts.map((contract) {
                    return DataRow(cells: [
                      DataCell(Text(contract['id'])),
                      DataCell(Text(contract['status'])),
                      DataCell(Text(contract['quantity'].toString())),
                      DataCell(
                          Text('\$${contract['price'].toStringAsFixed(4)}')),
                      DataCell(
                          Text('\$${contract['balance'].toStringAsFixed(3)}')),
                      DataCell(TextButton(
                        child: Text('Amend',
                            style: TextStyle(color: Colors.orange)),
                        onPressed: () {
                          // Handle amend action
                        },
                      )),
                    ]);
                  }).toList(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterButton(String filter) {
    return ElevatedButton(
      child: Text(filter),
      style: ElevatedButton.styleFrom(
        foregroundColor: _currentFilter == filter ? Colors.white : Colors.black,
        backgroundColor:
            _currentFilter == filter ? Colors.blue : Colors.grey[300],
      ),
      onPressed: () {
        setState(() {
          _currentFilter = filter;
        });
      },
    );
  }
}
