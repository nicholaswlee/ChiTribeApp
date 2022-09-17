import 'package:chitribe/Pages/FakeFavoritedPage.dart';
import 'package:flutter/material.dart';
import '../Pages/CalendarPage.dart';
import '../Pages/FakeEventPage.dart';
import '../Pages/FavoritedPage.dart';
import '../Pages/HomePage.dart';
import '../Pages/Settings.dart';
import '../Pages/SettingsNoAccount.dart';
import 'auth_widgets.dart';

class NoAccount extends StatefulWidget {
  const NoAccount(
    {
      required this.startLoginFlow
    }
  );
  final void Function() startLoginFlow;
  @override
  State<NoAccount> createState() => NoAccountState();
}

class NoAccountState extends State<NoAccount> {
  static List<Widget> _widgetOptions  = [];
  void initState(){
    _widgetOptions = <Widget>[
        HomePage(),
        FakeEventPage(startLoginFlow: widget.startLoginFlow),
        FakeFavoritedPage(startLoginFlow: widget.startLoginFlow)
      ];
  }
  int _selectedIndex = 0;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }
  

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      
      drawer: SettingsNoAccount(createAccount: widget.startLoginFlow),
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Image.asset('assets/logo.png', height: AppBar().preferredSize.height, fit: BoxFit.fitWidth),
        backgroundColor: Colors.black,
        
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.red[700],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home,size:30),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month ,size:30),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite, size:30),
            label: 'Favorited',
          ),
        ],
        currentIndex: _selectedIndex,
        showSelectedLabels: false,
        showUnselectedLabels: false,
        selectedItemColor: Colors.white,
        onTap: _onItemTapped,
      ),
    );
  }
}

