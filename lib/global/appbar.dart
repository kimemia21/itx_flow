import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ITXAppBar extends StatelessWidget implements PreferredSizeWidget {
  const ITXAppBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.green[600],
      centerTitle: true,
      title:  Text(
        'iTea-X',
        style: GoogleFonts.abel(
            fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
      ),
      leading: IconButton(
        onPressed: () {
          _showLogoutConfirmationDialog(context);
        },
        icon: Icon(Icons.login,color: Colors.white,size: 30,),
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Colors.red, size: 30),
              SizedBox(width: 10),
              Text('Logout Confirmation'),
            ],
          ),
          content: Text('Are you sure you want to log out?',textAlign: TextAlign.center,),
          actions: [
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
            TextButton(
              child: Text('Logout'),
              onPressed: () {
                context.read<appBloc>().changeToken("");

                Navigator.of(context).pop();
                PersistentNavBarNavigator.pushNewScreen(
                    withNavBar: false, context, screen: MainLoginScreen());
                // Close the dialog
                // MainLoginScreen();
                // _triggerLogout(context); // Call logout function
              },
            ),
          ],
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
        );
      },
    );
  }

  void _triggerLogout(BuildContext context) {
    // This clears the token or session data
    context.read<appBloc>().changeToken("");

    // Simulate logout animation
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: AnimatedContainer(
            duration: Duration(seconds: 1),
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: Colors.red.withOpacity(0.5),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.logout,
              size: 60,
              color: Colors.white,
            ),
          ),
        );
      },
    );

    // Add a delay before navigating to the login screen
    Future.delayed(Duration(seconds: 1), () {
      context.read<appBloc>().changeToken("");

      Navigator.of(context).pop();
      PersistentNavBarNavigator.pushNewScreen(
          withNavBar: false, context, screen: MainLoginScreen());

      // Clear the navigation stack and navigate to login screen
      // PersistentNavBarNavigator.pushNewScreen(
      //     withNavBar: true, context, screen: MainLoginScreen());
    });
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
