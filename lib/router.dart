import 'package:better_bus/controller/appController.dart';
import 'package:better_bus/page/map.dart';
import 'package:better_bus/page/saved.dart';
import 'package:better_bus/page/search.dart';
import 'package:better_bus/page/setting.dart';
import 'package:flutter/material.dart';

import 'constKey/appMenuKey.dart';

class PageRouter extends StatefulWidget {
  const PageRouter({super.key, required this.appController});
  final AppController appController;
  @override
  State<PageRouter> createState() => _PageRouterState();
}

class _PageRouterState extends State<PageRouter> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    switchPage(AppController controller) {
      print("123");
      switch (controller.currentPage) {
        case MAP_PAGE_KEY:
          return MapPage();
        case SEARCH_PAGE_KEY:
          return SearchPage();
        case SETTING_PAGE_KEY:
          return SettingPage();
        case SAVED_PAGE_KEY:
          return SavedPage();
        default:
          return MapPage();
      }
    }

    return Container(
      child: switchPage(widget.appController),
    );
  }
}
