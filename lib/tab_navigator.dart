import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  TabNavigator({required this.navigatorKey, required this.tabItem});
  final GlobalKey<NavigatorState>? navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    if (tabItem == "homepage")
      child = HomePage();
    else if (tabItem == "librarypage")
      child = LibraryPage();
    else if (tabItem == "searchpage")
      child = SearchPage();
    else if (tabItem == "italianpage")
      child = ItalianPage();
    else if (tabItem == "accountpage") child = AccountPage();

    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
            builder: (context) => child!);
      },
    );
  }
}
