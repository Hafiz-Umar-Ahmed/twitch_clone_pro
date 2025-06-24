import 'package:flutter/material.dart';
import 'package:twitch_clone_pro/screens/browse_screen.dart';
import 'package:twitch_clone_pro/screens/feed_screen.dart';
import 'package:twitch_clone_pro/screens/golive_screen.dart';
import 'package:twitch_clone_pro/utils/colors.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  static const routeName = '/homeScreen';

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;

  onPageChange(int page) {
    setState(() {
      _page = page;
    });
  }

  List<Widget> pages = [
    const FeedScreen(),
    const GoLiveScreen(),
    const BrowseScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: buttonColor,
        unselectedItemColor: primaryColor,
        backgroundColor: backgroundColor,
        unselectedFontSize: 12,
        currentIndex: _page,
        onTap: onPageChange,
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.favorite_rounded),
            label: 'Following',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle_outline_sharp),
            label: 'Go Live',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.copy), label: 'Browse'),
        ],
      ),
      body: pages[_page],
    );
  }
}
