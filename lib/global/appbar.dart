import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:itx/Commodities.dart/ComDropDown.dart';
import 'package:itx/authentication/LoginScreen.dart';
import 'package:itx/chatbox/ChatList.dart';
import 'package:itx/state/AppBloc.dart';
import 'package:persistent_bottom_nav_bar/persistent_bottom_nav_bar.dart';
import 'package:provider/provider.dart';

class ITXAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  const ITXAppBar({Key? key, required this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      flexibleSpace: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Colors.green[800]!,
              Colors.green[600]!,
            ],
          ),
        ),
      ),
      toolbarHeight: 70, // Increased height for better spacing
      leadingWidth: MediaQuery.of(context).size.width * 0.4,
      leading: Padding(
        padding: const EdgeInsets.only(left: 16.0),
        child: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontSize: 20,
              letterSpacing: 0.5,
              shadows: [
                Shadow(
                  blurRadius: 3,
                  color: Colors.black26,
                  offset: Offset(0, 1),
                ),
              ],
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ),

      title: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.only(top: 8),
            padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(8),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 4,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: CommodityDropdown(
              onCommoditySelected: (onCommoditySelected) {},
              isForAppBar: true,
            ),
          ),
          SizedBox(height: 4),
          Text(
            context.watch<appBloc>().commodityName ?? "",
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontWeight: FontWeight.w400,
              fontSize: 14,
            ),
          ),
        ],
      ),
      centerTitle: true,
      actions: [
        Container(
          margin: EdgeInsets.only(right: 8),
          child: Theme(
            data: Theme.of(context).copyWith(
              popupMenuTheme: PopupMenuThemeData(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                elevation: 4,
              ),
            ),
            child: PopupMenuButton<String>(
              icon: Container(
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.more_vert, color: Colors.white),
              ),
              offset: Offset(0, 45),
              onSelected: (String value) {
                if (value == 'logout') {
                  _showLogoutConfirmationDialog(context);
                } else {
                  if (value == "messages") {
                    try {
                      PersistentNavBarNavigator.pushNewScreen(
                        context,
                        screen: ChatListScreen(),
                        withNavBar: true,
                      );
                    } catch (e) {
                      print("got this error in messages tab $e");
                    }
                  }
                }
              },
              itemBuilder: (BuildContext context) => [
                // _buildPopupMenuItem('notification', 'Notifications',
                //     Icons.notifications_outlined),
                _buildPopupMenuItem(
                    'messages', 'Messages', Icons.message_outlined),
                _buildPopupMenuItem('logout', 'Log Out', Icons.logout_rounded,
                    isDestructive: true),
                 _buildPopupMenuItem(' ChangeRole', 'Role', Icons.person,
                    isDestructive: true),
              ],
            ),
          ),
        ),
      ],
    );
  }

  PopupMenuItem<String> _buildPopupMenuItem(
      String value, String text, IconData icon,
      {bool isDestructive = false}) {
    return PopupMenuItem<String>(
      value: value,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 20,
            color: isDestructive ? Colors.red[400] : Colors.grey[700],
          ),
          SizedBox(width: 12),
          Text(
            text,
            style: GoogleFonts.poppins(
              color: isDestructive ? Colors.red[400] : Colors.grey[800],
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 8,
          child: Container(
            padding: EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.red[50],
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.logout_rounded,
                    color: Colors.red[400],
                    size: 32,
                  ),
                ),
                SizedBox(height: 16),
                Text(
                  'Log Out',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w600,
                    color: Colors.grey[800],
                  ),
                ),
                SizedBox(height: 8),
                Text(
                  'Are you sure you want to log out?',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.poppins(
                    color: Colors.grey[600],
                    fontSize: 14,
                  ),
                ),
                SizedBox(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      style: TextButton.styleFrom(
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: GoogleFonts.poppins(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        context.read<appBloc>().changeToken("");
                        Navigator.of(context).pop();
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => MainLoginScreen()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red[400],
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Log Out',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(70); // Match with toolbarHeight
}
