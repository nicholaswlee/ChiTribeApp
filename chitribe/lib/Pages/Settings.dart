import 'package:flutter/material.dart';

import 'CalendarPage.dart';

class Settings extends StatelessWidget{
  const Settings(
    {
      required this.signOut,
      required this.deleteAccount,
    }
  );
  final void Function() signOut;
  final void Function() deleteAccount;
  @override
  void _showErrorDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(
            "Are you sure you would like to delete your account?",
            style: const TextStyle(fontSize: 24),
          ),
          actions: <Widget>[
            FilterButton(
              onPressed: () {
                print("Deleting account...");
                deleteAccount();
                Navigator.of(context).pop();
                
              },
              child: const Text(
                'Yes, delete my account and data',
                style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                ),
              ),
            ),
            FilterButton(
              onPressed: () {
                Navigator.of(context).pop();
                
              },
              child: const Text(
                'No, do not delete my account',
                style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children:  <Widget>[
          DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.red[700],
            ),
            child: Text(
              'Settings',
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
              ),
            ),
          ),
          ListTile(
            onTap: () { signOut(); print("Signing out");},
            leading: Icon(Icons.logout),
            title: Text('Log Out'),
          ),
          ListTile(
            onTap: () {_showErrorDialog(context);},
            leading: Icon(Icons.delete),
            title: Text('Delete Account'),
          ),


        ],
      ),
    );
    }  
  }