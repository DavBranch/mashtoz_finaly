import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/models/book_data/content_list.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'dart:math' as math;
import 'package:mashtoz_flutter/ui/widgets/main_page/bottom_bars_pages/bottom_bar_menu_pages.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/library_pages/books_page.dart';
import 'package:responsive_grid_list/responsive_grid_list.dart';

import 'package:tab_indicator_styler/tab_indicator_styler.dart';

import '../../../../config/palette.dart';

import '../../helper_widgets/menuShow.dart';

class AccountPage extends StatelessWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Palette.textLineOrBackGroundColor,
        extendBodyBehindAppBar: true,
        body: CustomScrollView(
          slivers: [
            SliverAppBar(
              flexibleSpace: Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.only(
                    left: 50.0,
                    top: 23.0,
                  ),
                  child: Container(
                    height: 73,
                    padding: EdgeInsets.only(top: 18),
                    child: Text(
                      'Իմ հաշիվը',
                      style: TextStyle(
                          fontSize: 16,
                          letterSpacing: 1,
                          fontFamily: 'GHEAGrapalat',
                          fontWeight: FontWeight.w700,
                          color: Palette.appBarTitleColor),
                    ),
                  ),
                ),
              ),
              leading: SizedBox(
                width: 8,
                height: 14,
                child: SvgPicture.asset(
                  'assets/images/Favorite_2 2.svg',
                  fit: BoxFit.none,
                ),
              ),
              expandedHeight: 73,
              backgroundColor: Palette.textLineOrBackGroundColor,
              elevation: 0,
              automaticallyImplyLeading: false,
              systemOverlayStyle: SystemUiOverlayStyle(
                  statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
              actions: [
                Padding(
                  padding: const EdgeInsets.only(right: 20.0),
                  child: MenuShow(),
                ),
              ],
            ),
            SliverFillRemaining(
              child: DelegateChild(),
            )
          ],
        ));
  }
}

class DelegateChild extends StatefulWidget {
  DelegateChild({
    Key? key,
  }) : super(key: key);

  @override
  State<DelegateChild> createState() => _DelegateChildState();
}

class _DelegateChildState extends State<DelegateChild>
    with SingleTickerProviderStateMixin {
  final userDataProvider = UserDataProvider();

  Future<List<UserAccount>?>? favoriteFuture;

  late TabController _tabController;
  var types = <String>[
    'libraries',
    'encyclopedias',
    'lessons',
    'dialects',
    'audiolibraries',
    'gallery',
    'armenians',
    'italians',
  ];

  int drawableIndex = 0;
  Widget buildList(
      {required Content data, required int index, required int listCount}) {
    if (drawableIndex == 0) {
      return ResponsiveGridList(
        horizontalGridSpacing: 16, // Horizontal space between grid items

        verticalGridMargin: 50, // Vertical space around the grid
        minItemWidth:
        388, // The minimum item width (can be smaller, if the layout constraints are smaller)
        minItemsPerRow:
        1, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow: 4, // The m
        shrinkWrap: true,
        children: List.generate(data.content!.length, (index) {
          return index % 2 != 0
              ? Transform(
              alignment: Alignment.center,
              transform: Matrix4.rotationY(math.pi),
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: BookCard(
                  isOdd: true,
                  book: data,
                  categorys: BookCategory(
                    categoryTitle: data.title!,
                    id: data.id!,
                    title: data.title!,
                    type: 'librarian',
                  ),
                ),
              ))
              : Padding(
            padding: const EdgeInsets.all(15.0),
            child: BookCard(
              isOdd: false,
              book: data,
              categorys: BookCategory(
                categoryTitle: data.title!,
                id: data.id!,
                title: data.title!,
                type: 'librarian',
              ),
            ),
          );
        }),
      );
      // return index % 2 != 0
      //     ? BookCard(
      //         book: data,
      //         isOdd: false,
      //         categorys: BookCategory(
      //           categoryTitle: data.title!,
      //           id: data.id!,
      //           title: data.title!,
      //           type: 'librarian',
      //         ))
      //     : BookCard(
      //         book: data,
      //         isOdd: false,
      //         categorys: BookCategory(
      //           categoryTitle: data.title!,
      //           id: data.id!,
      //           title: data.title!,
      //           type: 'librarian',
      //         ));
    } else if (drawableIndex == 1) {
      return carachtersList(data, index);
    } else if (drawableIndex == 2) {
      return ResponsiveGridListBuilder(
        horizontalGridSpacing: 16, // Horizontal space between grid items

        verticalGridMargin: 50, // Vertical space around the grid
        minItemWidth:
        300, // The minimum item width (can be smaller, if the layout constraints are smaller)
        minItemsPerRow:
        1, // The minimum items to show in a single row. Takes precedence over minItemWidth
        maxItemsPerRow: 4, // T The m`
        gridItems: List.generate(listCount, (index) {
          return index % 2 != 0
              ? Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationY(math.pi),
            child: ITLesson(
              isOdd: true,
              italianLesson: Lessons(
                  id: data.id,
                  image: data.image,
                  title: data.title,
                  link: data.videoLink,
                  number: data.number),
            ),
          )
              : ITLesson(
            isOdd: false,
            italianLesson: Lessons(
                id: data.id,
                image: data.image,
                title: data.title,
                link: data.videoLink,
                number: data.number),
          );
        }),
        builder: (context, items) {
          return ListView(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            physics: AlwaysScrollableScrollPhysics(),
            children: items,
          );
        },
      );
      // return ITLesson(
      //   italianLesson: Lessons(
      //       id: data.id,
      //       image: data.image,
      //       title: data.title,
      //       link: data.videoLink,
      //       number: data.number),
      //   isOdd: index % 2 != 0 ? false : true,
      // );
    } else if (drawableIndex == 3) {
      return carachtersList(data, index);
    } else if (drawableIndex == 4) {
      return carachtersList(data, index);
    } else if (drawableIndex == 5) {}
    return Text('data');
  }

  @override
  void initState() {
    _tabController = TabController(
        length: listAccountElements.length,
        vsync: this,
        initialIndex: 0,
        animationDuration: Duration.zero);
    favoriteFuture = userDataProvider.getFavorites();

    super.initState();
  }

  Widget carachtersList(Content data, int index) {
    return GestureDetector(
      onTap: () {
        // Navigator.push(
        //     context,
        //     MaterialPageRoute(
        //         builder: (_) => BookReadScreen(
        //               encyclopediaBody: data[index],
        //             )));
      },
      child: Container(
        padding: EdgeInsets.only(right: 20.0, left: 22.0),
        child: Column(
          children: [
            SizedBox(
              height: 30,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0.0),
                    child: Text(
                      '0${index + 1}',
                      style: TextStyle(
                        color: Palette.main,
                        fontFamily: 'GHEAGrapalat',
                        fontSize: 16.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 10.0),
                Expanded(
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: Container(
                      width: 260,
                      child: Text(
                        '${data.title}',
                        style: TextStyle(
                            fontFamily: 'GHEAGrapalat',
                            fontSize: 16.0,
                            fontWeight: FontWeight.w700,
                            color: Color.fromRGBO(113, 141, 156, 1)),
                        textAlign: TextAlign.start,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Divider(
              thickness: 1,
              color: Color.fromRGBO(226, 224, 224, 1),
            )
          ],
        ),
      ),
    );
  }

  Widget buildData() {
    return Padding(
      padding: EdgeInsets.only(left: 10.0, right: 10.0),
      child: Column(
        children: [
          SizedBox(height: 52),
          FutureBuilder<List<UserAccount>?>(
              future: favoriteFuture,
              builder: (context, snapshot) {
                var data = snapshot.data;
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Container(
                      child: Center(
                          child: CircularProgressIndicator(
                            strokeWidth: 2.0,
                            color: Palette.main,
                          )));
                } else if (snapshot.connectionState == ConnectionState.done) {
                  if (snapshot.hasError) {
                    return const Text('Something went wrong');
                  } else if (snapshot.hasData) {
                    var data = snapshot.data;
                    return !data!.isEmpty? Expanded(
                      child: Container(
                        child: ListView.builder(
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemCount: data?.length,
                          itemBuilder: (context, index) {
                            if (data![index].type! == types[drawableIndex]) {
                              return buildList(
                                  data: data[index].content,
                                  index: index,
                                  listCount: data.length);
                            }
                            return Container(
                              width: 0.1,
                              height: 0.1,
                            );
                          },
                        ),
                      ),
                    ) : Center(child:Text('Դեռևս գրառումներ չկան',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Palette.barColor),),);
                  } else {
                    return const Center(child:Text('Դեռևս գրառումներ չկան',style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,color: Palette.barColor),),);
                  }
                } else {
                  return Text('State: ${snapshot.connectionState}');
                }
              }),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: listAccountElements.length,
      child: Scaffold(
        backgroundColor: Palette.textLineOrBackGroundColor,
        appBar: PreferredSize(
          preferredSize: Size(18.0, 50.0),
          child: Container(
            color: Color.fromRGBO(246, 246, 246, 1),
            child: Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TabBar(
                  indicatorWeight: 2,
                  unselectedLabelColor: const Color.fromRGBO(122, 108, 115, 1),
                  labelColor: const Color.fromRGBO(251, 196, 102, 1),
                  indicatorColor: Colors.amber,
                  indicator: MaterialIndicator(
                    color: Colors.amber,
                    height: 2,
                    topLeftRadius: 0,
                    topRightRadius: 0,
                    bottomLeftRadius: 5,
                    bottomRightRadius: 5,
                    tabPosition: TabPosition.top,
                    paintingStyle: PaintingStyle.fill,
                  ),
                  controller: _tabController,
                  isScrollable: true,
                  labelPadding: const EdgeInsets.symmetric(horizontal: 15),
                  onTap: (index) {
                    setState(() {
                      drawableIndex = index;
                    });
                  },
                  tabs: listAccountElements.map((tabName) {
                    return Tab(
                      child: Text(
                        tabName,
                        style: TextStyle(
                          fontFamily: 'GHEABrapalat',
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          letterSpacing: 1,
                          color: listAccountElements
                              .toString()
                              .toLowerCase()
                              .contains(tabName.toLowerCase())
                              ? null
                              : Color.fromRGBO(186, 166, 177, 1),
                        ),
                      ),
                    );
                  }).toList()),
            ),
          ),
        ),
        body: TabBarView(
            physics: NeverScrollableScrollPhysics(),
            controller: _tabController,
            children: listAccountElements
                .map(
                  (e) => listAccountElements
                  .toString()
                  .toLowerCase()
                  .contains(e.toLowerCase())
                  ? buildData()
                  : Center(
                child: Text('Դեռևս գրառումներ չկան',style: TextStyle(color: Palette.barColor),),
              ),
            )
                .toList()),

        //     ))
      ),
    );
  }
}

var listAccountElements = [
  'Գրադարան',
  'Հանրագիտարան',
  'Իտալերենի դասեր',
  'Համաբարբառ',
  'Ձայնադարան',
  'Պատկերադարան'
];
