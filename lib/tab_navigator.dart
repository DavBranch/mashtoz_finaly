import 'package:flutter/material.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';

import 'auth_service.dart';

class TabNavigatorRoutes {
  static const String root = '/';
  static const String detail = '/detail';
}

class TabNavigator extends StatelessWidget {
  final _sessionProvider = SessionDataProvider();
   TabNavigator({Key? key,
    required this.navigatorKey,
    required this.tabItem,
  }) : super(key: key);
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

        child =  FutureBuilder<Widget>(
    future: AuthService().handleAuthState(),
    builder: (BuildContext context, AsyncSnapshot<Widget> snapshot) {
    if (snapshot.connectionState == ConnectionState.done) {
    if (snapshot.hasError) {

    return Text('Error: ${snapshot.error}');

    } else {

    return snapshot.data!;

    }
    } else {

      return const CircularProgressIndicator();

    }
    },
    );
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


  }

  bool hasToken() {
    String? hasToken;
    Future.delayed(Duration(milliseconds: 400,),()async{
      hasToken  = await  _sessionProvider.readsAccessToken();});

    if(hasToken != null){

      return true;

    }
    return   false;
  }
}