import 'package:flutter/material.dart';

import 'CalendarPage.dart';

class SettingsNoAccount extends StatelessWidget{
  const SettingsNoAccount(
    {
      required this.createAccount,
    }
  );
  final void Function() createAccount;
  @override
  void _showErrorDialog(BuildContext context) {
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
            onTap: () { createAccount(); print("Creating an account");},
            leading: Icon(Icons.account_circle),
            title: Text('Create an account'),
          ),


        ],
      ),
    );
    }  
  }