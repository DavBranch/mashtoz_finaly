import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  const TabNavigator({
    required this.navigatorKey,
    required this.tabItem,
  });
  final GlobalKey<NavigatorState>? navigatorKey;
  final String tabItem;

  @override
  Widget build(BuildContext context) {
    Widget? child;
    switch (tabItem) {
      case 'homepage':
        child = HomePage();
        break;
      case 'librarypage':
        child = const LibraryPage();
        break;
      case 'searchpage':
        child = const SearchPage();
        break;
      case 'italianpage':
        child =  ItalianPage();
        break;
      case 'accountpage':
        child = const AccountPage();
        break;
    }
    return Navigator(
      key: navigatorKey,
      onGenerateRoute: (routeSettings) {
        return MaterialPageRoute(
          builder: (context) => child!,
        );
      },
    );
  }}