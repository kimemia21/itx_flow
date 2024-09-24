import 'package:flutter/material.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';

class ITXAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ITXAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[600],
      centerTitle: true,
      
      title: const Text(
        'ITX',
        style: TextStyle(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      leading: IconButton(
          onPressed: () {
            PersistentNavBarNavigator.pushNewScreen(
              withNavBar: false,
              context,
                screen: MainLoginScreen());
          },
          icon: Icon(Icons.login)),
      // actions: [
      //   IconButton(
      //     icon: const Icon(Icons.search),
      //     onPressed: () {
      //       // TODO: Implement search functionality
      //     },
      //   ),
      //   IconButton(
      //     icon: const Icon(Icons.person),
      //     onPressed: () {
      //       // TODO: Implement user profile functionality
      //     },
      //   ),
      //   PopupMenuButton<String>(
      //     onSelected: (value) {
      //       // TODO: Handle menu item selection
      //     },
      //     itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
      //       const PopupMenuItem<String>(
      //         value: 'home',
      //         child: Text('Home'),
      //       ),
      //       const PopupMenuItem<String>(
      //         value: 'products',
      //         child: Text('Products'),
      //       ),
      //       const PopupMenuItem<String>(
      //         value: 'services',
      //         child: Text('Services'),
      //       ),
      //       const PopupMenuItem<String>(
      //         value: 'about',
      //         child: Text('About'),
      //       ),
      //       const PopupMenuItem<String>(
      //         value: 'contact',
      //         child: Text('Contact'),
      //       ),
      //     ],
      //   ),
      // ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
