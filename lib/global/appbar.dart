import 'package:flutter/material.dart';

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
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white
        ),
      ),
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