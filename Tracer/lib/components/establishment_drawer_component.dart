import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_home_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_profile_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/establishment/establishment_visitors_screen.dart';
import 'package:capitis_mad2_assignment_8/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:quickalert/models/quickalert_type.dart';
import 'package:quickalert/widgets/quickalert_dialog.dart';

class EstablishmentDrawerComponent extends StatelessWidget {
  const EstablishmentDrawerComponent({
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
                    builder: (context) => EstablishmentHomeScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Home',
          ),
          ListTile(
            leading: Icon(Icons.person),
            title: Text('Profile'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EstablishmentProfileScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Profile',
          ),
          ListTile(
            leading: Icon(Icons.visibility),
            title: Text('Visitors'),
            onTap:
                () => Navigator.of(context).pushReplacement(
                  MaterialPageRoute(
                    builder: (context) => EstablishmentVisitorsScreen(uid: id),
                  ),
                ),
            selected: currentScreen == 'Visitors',
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
