import 'package:capitis_mad2_assignment_8/screens/client/client_establishments_listing_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/client/client_history_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/client/client_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/client/client_profile_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class ClientDrawerComponent extends StatelessWidget {
  const ClientDrawerComponent({
    super.key,
    required this.id,
    required this.currentScreen,
  });

  final String id;
  final String currentScreen;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          DrawerHeader(child: Text('')),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClientHomeScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Home',
          ),
          ListTile(
            leading: Icon(Icons.business),
            title: Text('Establishments'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder:
                        (context) => ClientEstablishmentsListingScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Establishments',
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClientProfileScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Profile',
          ),
          ListTile(
            leading: Icon(Icons.history),
            title: Text('History'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => ClientHistoryScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'History',
          ),
          Spacer(),
          ListTile(
            iconColor: Colors.red,
            textColor: Colors.red,
            leading: Icon(Icons.logout),
            title: Text('Logout'),
            onTap: () => showLogoutAlert(context),
          ),
        ],
      ),
    );
  }

  void showLogoutAlert(BuildContext context) {
    QuickAlert.show(
      context: context,
      type: QuickAlertType.confirm,
      onConfirmBtnTap: () => logoutUser(context),
    );
  }

  void logoutUser(BuildContext context) async {
    QuickAlert.show(context: context, type: QuickAlertType.loading);
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pop();
    Navigator.of(
      context,
    ).pushReplacement(MaterialPageRoute(builder: (context) => HomeScreen()));
  }
}
