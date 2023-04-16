import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/tab_navigator.dart';

import '../notifications/notification_service.dart';

 enum BottomIcons {
  home,
  library,
  search,
  italian,
  account,
  initall,
}

enum ScreenName {
  books,
  book,
  bookRead,
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => HomeScreenState();
}

class HomeScreenState extends State<HomeScreen> {
 // static BottomIcons? icons = BottomIcons.home;
  final _sessionProvider=SessionDataProvider();
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging.instance;
  FlutterLocalNotificationsPlugin? _flutterLocalNotificationsPlugin;
 // static bool isAccount = false;
 //  static bool isHome = false;
 //  static bool isItalian = false;
 //  static bool isLibrary = false;
 //  static bool isSearch = false;
 //  static bool isSign = false;
 // static List<String> pageKeys = [
 //    'homepage',
 //    'librarypage',
 //    'searchpage',
 //    "italianpage",
 //    'accountpage'
 //  ];
 //
 //  ScreenName secrenName = ScreenName.book;
 //
 // static var currentIndex = 0;
 // static String _currentPage = "homepage";
 // static Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
 //    "homepage": GlobalKey<NavigatorState>(),
 //    "librarypage": GlobalKey<NavigatorState>(),
 //    "searchpage": GlobalKey<NavigatorState>(),
 //    "italianpage": GlobalKey<NavigatorState>(),
 //    "accountpage": GlobalKey<NavigatorState>(),
 //  };

  @override
  void initState() {
    // if(icons==BottomIcons.home){
    //   isHome=true;
    // }
    NotificationService.initialize(context);

    FirebaseMessaging.instance.getInitialMessage().then((message) {
      if (message != null) {
        final routeFromMessage = message.data["route"];

        Navigator.of(context).pushNamed(routeFromMessage);
      }
    });
    FirebaseMessaging.onMessage.listen((message) {
      if (message.notification != null) {
        print(message.notification!.body);
        print(message.notification!.title);
      }

      NotificationService.display(message);
    });

    // FirebaseMessaging.onMessageOpenedApp.listen((message) {
    //   // final routeFromMessage = message.data["route"];
    //   //
    //   // Navigator.of(context).pushNamed(routeFromMessage);
    // });
hasToken();
    super.initState();
  }
  Future<bool> hasToken() async{
    String? hasToken = await _sessionProvider.readsAccessToken();
    if(hasToken != null){

      return true;

    }
    return   false;
  }
  final List<String> _tabItems = ['homepage', 'librarypage', 'searchpage', 'italianpage', 'accountpage'];
  int _currentIndex = 0;

  // Create a GlobalKey for each TabNavigator instance
  final GlobalKey<NavigatorState> _homeNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _libraryNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _searchNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _italianNavigatorKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> _accountNavigatorKey = GlobalKey<NavigatorState>();


  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Check if we're at the first tab
        if (_currentIndex == 0 && !_homeNavigatorKey!.currentState!.canPop()) {
          // If so, let the system handle the back button press
          return true;
        } else if (_homeNavigatorKey!.currentState!.canPop()) {
          _homeNavigatorKey!.currentState!.pop();
        } else if (_currentIndex > 0) {
          // If there is no previous page to pop, switch to the previous tab
          setState(() => _currentIndex -= 1);
        } else {
          // Otherwise, stay in the same tab and let the system handle the back button press
          return true;
        }
        return false;
      },


      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: [
            // Use the TabNavigator widget for each tab
            TabNavigator(navigatorKey: _homeNavigatorKey, tabItem: _tabItems[0]),
            TabNavigator(navigatorKey: _libraryNavigatorKey, tabItem: _tabItems[1]),
            TabNavigator(navigatorKey: _searchNavigatorKey, tabItem: _tabItems[2]),
            TabNavigator(navigatorKey: _italianNavigatorKey, tabItem: _tabItems[3]),
            TabNavigator(navigatorKey: _accountNavigatorKey, tabItem: _tabItems[4]),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Palette.main,
          fixedColor:Palette.cursor,
          currentIndex: _currentIndex,
          elevation: 0.0,
          onTap: (int index) => setState(() => _currentIndex = index),
          items: [
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon:  SvgPicture.asset(
            'assets/images/home.svg',
              width: 25,
              height: 30,
              ),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(

                                          'assets/images/library.svg',
                                          width: 25,
                                          height: 30,
                                        ),
              label: 'Library',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon: SvgPicture.asset(
                                      'assets/images/search2.svg',
                                      width: 25,
                                      height: 27,
                                    ),
              label: 'Search',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,

              icon:SvgPicture.asset(
                'assets/images/italian_lessons.svg',
                width: 25,
                height: 27,
              ),
              label: 'Italian',
            ),
            BottomNavigationBarItem(
              backgroundColor: Palette.barColor,
              icon:SvgPicture.asset(
                'assets/images/profile.svg',
                width: 25,
                height: 27,
              ),
              label: 'Account',
            ),
          ],
        ),
      ),
    );
  }

}
