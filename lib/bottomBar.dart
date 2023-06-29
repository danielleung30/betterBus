import 'package:better_bus/controller/appController.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import 'constKey/appMenuKey.dart';

class NavBar extends StatefulWidget {
  const NavBar(
      {super.key,
      required this.isElevated,
      required this.isVisible,
      required this.appController,
      required this.changePage});
  final bool isElevated;
  final bool isVisible;
  final AppController appController;
  final Function changePage;

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  List<String> pageList = [
    MAP_PAGE_KEY,
    SAVED_PAGE_KEY,
    SEARCH_PAGE_KEY,
    SETTING_PAGE_KEY,
  ];

  _tab(int index) {
    widget.changePage(pageList[index]);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        elevation: widget.isElevated ? null : 0.0,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: const Icon(Icons.pin_drop),
            label: 'Map',
            activeIcon: Icon(
              Icons.pin_drop,
              size: 40,
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.favorite),
            label: 'Saved',
            activeIcon: Icon(
              Icons.favorite,
              size: 40,
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.search),
            label: 'Search',
            activeIcon: Icon(
              Icons.search,
              size: 40,
            ),
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: 'settings',
            activeIcon: Icon(
              Icons.settings,
              size: 40,
            ),
          ),
        ],
        currentIndex: pageList.indexOf(widget.appController.currentPage),
        onTap: _tab);
  }
}
