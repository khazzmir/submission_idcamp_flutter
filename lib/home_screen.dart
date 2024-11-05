import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:submission_idcamp_flutter/drink_water_screen.dart';
import 'package:submission_idcamp_flutter/history_screen.dart';
import 'package:submission_idcamp_flutter/statistic_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 1;

  final List<String> _titles = [
    'Statistik',
    'Minum Air',
    'Histori',
    'Seting',
  ];

  // Define the list of screens here
  static const List<Widget> _pages = <Widget>[
    StatisticScreen(),
    DrinkWaterScreen(),
    HistoryScreen(),
    Text('Settings Screen', style: TextStyle(fontSize: 24)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(100),
        child: AppBar(
          title: Center(
              child: Text(_titles[_selectedIndex],
                  style:
                      GoogleFonts.poppins(color: Colors.white, fontSize: 25, fontWeight: FontWeight.w600))),
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/AppBar.png"),
                fit: BoxFit.fill,
              ),
            ),
          ),
          backgroundColor: Colors.transparent,
        ),
      ),
      body: Center(
        child: _pages.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_drink),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: '',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: '',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: const Color(0xFF3299E8),
        unselectedItemColor: const Color(0xFFC2C4C5),
        onTap: _onItemTapped,
      ),
    );
  }
}
