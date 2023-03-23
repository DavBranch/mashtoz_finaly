import 'package:cross_connectivity/cross_connectivity.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/bottom_bar_color_notifire.dart';
import 'package:mashtoz_flutter/tab_navigator.dart';
import 'package:mashtoz_flutter/ui/utils/log_out_changenotifire.dart';
import 'package:provider/provider.dart';

import '../../../auth_service.dart';
import '../buttons/bottom_navigation_bar/bottom_app_bar.dart';
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
 static BottomIcons? icons = BottomIcons.home;
  final _sessionProvider=SessionDataProvider();
 static bool isAccount = false;
  static bool isHome = false;
  static bool isItalian = false;
  static bool isLibrary = false;
  static bool isSearch = false;
  static bool isSign = false;
 static List<String> pageKeys = [
    'homepage',
    'librarypage',
    'searchpage',
    "italianpage",
    'accountpage'
  ];

  ScreenName secrenName = ScreenName.book;

 static var currentIndex = 0;
 static String _currentPage = "homepage";
 static Map<String, GlobalKey<NavigatorState>> _navigatorKeys = {
    "homepage": GlobalKey<NavigatorState>(),
    "librarypage": GlobalKey<NavigatorState>(),
    "searchpage": GlobalKey<NavigatorState>(),
    "italianpage": GlobalKey<NavigatorState>(),
    "accountpage": GlobalKey<NavigatorState>(),
  };

  @override
  void initState() {
    if(icons==BottomIcons.home){
      isHome=true;
    }
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

    FirebaseMessaging.onMessageOpenedApp.listen((message) {
      final routeFromMessage = message.data["route"];

      Navigator.of(context).pushNamed(routeFromMessage);
    });
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
  tirgleColor() {
    return icons == BottomIcons.library
        ? Palette.libraryBacgroundColor
        : false || icons == BottomIcons.home
            ? Palette.textLineOrBackGroundColor
            : false || icons == BottomIcons.search
                ? Palette.searchBackGroundColor
                : false || icons == BottomIcons.italian
                    ? Palette.textLineOrBackGroundColor
                    : false || icons == BottomIcons.account
                        ? !isSign?  Color.fromRGBO(
      83,
      66,
      76,
      1,
    ):Palette.textLineOrBackGroundColor
                        : null;
  }

  Widget buildMyNavBar(
    BuildContext context,
  ) {
    final color =
        Provider.of<BottomColorNotifire>(context, listen: true).barColor;
    return SizedBox(
      height: 80,
      // padding: const EdgeInsets.only(top: 14),
      child: Stack(
        children: [
          Container(
            color: color,
            width: double.infinity,
            height: 20,
            // color: Colors.black,
            child: Row(
              // mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icons == BottomIcons.home
                    ? Expanded(
                        child: CustomPaint(
                          size: const Size(42, 22),
                          painter: Triangle(),
                        ),
                      )
                    : Expanded(child: Container()),
                icons == BottomIcons.library
                    ? Expanded(
                        child: CustomPaint(
                          size: const Size(42, 22),
                          painter: Triangle(),
                        ),
                      )
                    : Expanded(child: Container()),
                icons == BottomIcons.search
                    ? Expanded(
                        child: CustomPaint(
                          size: const Size(42, 22),
                          painter: Triangle(),
                        ),
                      )
                    : Expanded(child: Container()),
                icons == BottomIcons.italian
                    ? Expanded(
                        child: CustomPaint(
                          size: const Size(42, 22),
                          painter: Triangle(),
                        ),
                      )
                    : Expanded(child: Container()),
                icons == BottomIcons.account
                    ? Expanded(
                        child: CustomPaint(
                          size: const Size(42, 22),
                          painter: Triangle(),
                        ),
                      )
                    : Expanded(child: Container()),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.only(top: 20),
            height: 100,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Expanded(
                  child: SizedBox.expand(
                    child: Container(
                      height: 55,
                      color: const Color.fromRGBO(83, 66, 77, 1),
                      child: Row(
                        children: [
                          // const SizedBox(width: 22.0),
                          Expanded(
                            child: Align(
                              alignment: Alignment.center,
                              child: BottomBar(
                                onPressed: () {
                                  setState(() {
                                    context
                                        .read<BottomColorNotifire>()
                                        .setColor(
                                            Palette.textLineOrBackGroundColor);
                                    selectTab(pageKeys[0], 0);
                                    setState(() {
                                      icons = BottomIcons.home;
                                    });
                                    isHome = true;
                                    isLibrary = false;
                                    isSearch = false;
                                    isItalian = false;
                                    isAccount = false;
                                  });
                                },
                                bottomIcons:
                                    icons == BottomIcons.home ? true : false,
                                path: SvgPicture.asset(
                                  'assets/images/home.svg',
                                  color: isHome ? Palette.cursor : null,
                                  width: 25,
                                  height: 30,
                                ),
                              ),
                            ),
                          ),
                          //  const SizedBox(width: 45.0),
                          Expanded(
                            child: BottomBar(
                              onPressed: () {
                                //  print('library');
                                setState(() {
                                  icons = BottomIcons.library;
                                  // onItemTaped(1);
                                  context
                                      .read<BottomColorNotifire>()
                                      .setColor(Palette.libraryBacgroundColor);
                                  selectTab(pageKeys[1], 1);
                                  isLibrary = true;

                                  isHome = false;
                                  isSearch = false;
                                  isItalian = false;
                                  isAccount = false;
                                });
                              },
                              bottomIcons:
                                  icons == BottomIcons.library ? true : false,
                              path: SvgPicture.asset(
                                'assets/images/library.svg',
                                color: isLibrary ? Palette.cursor : null,
                                width: 25,
                                height: 30,
                              ),
                            ),
                          ),
                          //const SizedBox(width: 45.0),
                          Expanded(
                            child: BottomBar(
                                onPressed: () {
                                  // print('search');

                                  //onItemTaped(2);
                                  context
                                      .read<BottomColorNotifire>()
                                      .setColor(Palette.searchBackGroundColor);
                                  selectTab(pageKeys[2], 2);
                                  icons = BottomIcons.search;
                                  isSearch = true;
                                  isHome = false;
                                  isLibrary = false;
                                  isItalian = false;
                                  isAccount = false;
                                },
                                bottomIcons:
                                    icons == BottomIcons.search ? true : false,
                                path: SvgPicture.asset(
                                  'assets/images/search2.svg',
                                  color: isSearch ? Palette.cursor : null,
                                  width: 25,
                                  height: 27,
                                )),
                          ),
                          // const SizedBox(width: 45.0),
                          Expanded(
                            child: BottomBar(
                              onPressed: () {
                                //    print('italian');
                                context.read<BottomColorNotifire>().setColor(
                                    Palette.textLineOrBackGroundColor);
                                setState(() {
                                  icons = BottomIcons.italian;
                                  // _currentIndex = 3;
                                  selectTab(pageKeys[3], 3);
                                  isItalian = true;
                                  isHome = false;
                                  isLibrary = false;
                                  isSearch = false;
                                  isAccount = false;
                                });
                              },
                              bottomIcons:
                                  icons == BottomIcons.italian ? true : false,
                              path: SvgPicture.asset(
                                'assets/images/italian_lessons.svg',
                                color: isItalian ? Palette.cursor : null,
                                width: 25,
                                height: 30,
                              ),
                            ),
                          ),
                          // const SizedBox(width: 40.0),
                          Expanded(
                            child: BottomBar(
                              onPressed: () async{
                                bool isSign = await hasToken();                                setState(() {
                                  //    onItemTaped(4);
                                  context.read<BottomColorNotifire>().setColor(
                                      Palette.textLineOrBackGroundColor);
                                 isSign? selectTab(pageKeys[4], 4): Navigator.of(context,rootNavigator: true).push(MaterialPageRoute(
                                   builder: (_) => AuthService().handleAuthState(),
                                 ),).whenComplete(()=>setState((){
                                   icons = null;
                                   isAccount = false;
                                 }));
                                  icons = BottomIcons.account;
                                  isAccount = true;
                                  isHome = false;
                                  isLibrary = false;
                                  isSearch = false;
                                  isItalian = false;
                                });
                              },
                              bottomIcons:
                                  icons == BottomIcons.account ? true : false,
                              path: SvgPicture.asset(
                                'assets/images/profile.svg',
                                color: isAccount ? Palette.cursor : null,
                                width: 25,
                                height: 27,
                              ),
                            ),
                          ),
                          //const SizedBox(width: 40.0),
                        ],
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }



  Widget _buildOffstageNavigator(String tabItem) {
    return Offstage(
      offstage: _currentPage != tabItem,
      child: TabNavigator(
        navigatorKey: _navigatorKeys[tabItem],
        tabItem: tabItem,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final isFirstRouteInCurrentTab =
            !await _navigatorKeys[_currentPage]!.currentState!.maybePop();
        print(currentIndex);

        if(!isFirstRouteInCurrentTab){
          context
              .read<BottomColorNotifire>()
              .setColor(
              Palette.textLineOrBackGroundColor);
        }
        if (isFirstRouteInCurrentTab) {
          if (_currentPage ==  "librarypage") {
            setState(() {
              context
                  .read<BottomColorNotifire>()
                  .setColor(
                  Palette.textLineOrBackGroundColor);
              selectTab(pageKeys[0], 0);
              setState(() {
                icons = BottomIcons.home;
              });
              isHome = true;
              isLibrary = false;
              isSearch = false;
              isItalian = false;
              isAccount = false;
            });

            return false;
          }
          if (_currentPage ==  "searchpage") {
            setState(() {
              icons = BottomIcons.library;
              // onItemTaped(1);
              context
                  .read<BottomColorNotifire>()
                  .setColor(Palette.libraryBacgroundColor);
              selectTab(pageKeys[1], 1);
              isLibrary = true;

              isHome = false;
              isSearch = false;
              isItalian = false;
              isAccount = false;
            });

            return false;
          }
          if (_currentPage ==  "italianpage") {
            context
                .read<BottomColorNotifire>()
                .setColor(Palette.searchBackGroundColor);
            selectTab(pageKeys[2], 2);
            icons = BottomIcons.search;
            isSearch = true;
            isHome = false;
            isLibrary = false;
            isItalian = false;
            isAccount = false;

            return false;
          }
          if (_currentPage ==  "accountpage") {
            context.read<BottomColorNotifire>().setColor(
                Palette.textLineOrBackGroundColor);
            setState(() {
              icons = BottomIcons.italian;
              // _currentIndex = 3;
              selectTab(pageKeys[3], 3);
              isItalian = true;
              isHome = false;
              isLibrary = false;
              isSearch = false;
              isAccount = false;
            });

            return false;
          }

        }
        // let system handle back button if we're on the first route
        return isFirstRouteInCurrentTab;
      },
      child: LoadingOverlay(
          isLoading:context.watch<UserLogOutNotifier>().userLogOut,
          opacity: 0.1,
          progressIndicator: CircularProgressIndicator(),
        child: Scaffold(
            backgroundColor: Palette.textLineOrBackGroundColor,
            body: ConnectivityBuilder(
              builder:(context,isConnect,status){
                if(isConnect==true){
                 return Stack(
                    children: [
                      _buildOffstageNavigator(
                          _navigatorKeys.keys.elementAt(currentIndex)),
                    ],
                  );
                }
                else{

                 return Center(child: AlertDialog(
                  elevation: 0.1,
                  backgroundColor: Palette.barColor,
                  title: Text('Ինտերնետ կապը կորել է:\nՄիացրեք կամ Ստուգեք ձեր կապը և նորից փորձեք:',style: TextStyle(color: Colors.white,fontSize: 18),),),);}

              }
            ),
            resizeToAvoidBottomInset: false,
            bottomNavigationBar: buildMyNavBar(context)),
      ),
    );
  }
 static void selectTab(String tabItem, int index) {
    if (tabItem == currentIndex) {
      _navigatorKeys[tabItem]?.currentState?.popUntil((route) => route.isFirst);
    } else {

        _currentPage = pageKeys[index];
        currentIndex = index;

    }
  }
}
