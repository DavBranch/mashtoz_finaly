import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/globals.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tab_indicator_styler/tab_indicator_styler.dart';
import '../../../../../domens/models/book_data/data.dart';
import '../../../../../domens/models/user.dart';
import '../../../../../domens/repository/user_data_provider.dart';
import '../../../helper_widgets/menuShow.dart';
import '../../../helper_widgets/save_show_dialog.dart';
import '/config/palette.dart';

class DictionaryArmItl extends StatefulWidget {
  const DictionaryArmItl({
    Key? key,
    required this.characters,
    required this.characterByindex,
    required this.characterIndex,
    required this.isShow,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  final bool isShow;

  @override
  _DictionaryArmItlState createState() => _DictionaryArmItlState(
      characters: characters,
      characterByindex: characterByindex,
      characterIndex: characterIndex,
      isShow: isShow);
}

class _DictionaryArmItlState extends State<DictionaryArmItl>
    with SingleTickerProviderStateMixin {
  _DictionaryArmItlState(
      {required this.characters,
      required this.characterByindex,
      required this.characterIndex,
      required this.isShow});

  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  final List<Object> characters;
  Future<List<Data>?>? charctersData;
  final bool isShow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(slivers: [
          SliverAppBar(
            flexibleSpace: Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 50.0,
                ),
                child: Container(
                  height: 73,
                  padding: EdgeInsets.only(top: 18),
                  child: Text(
                    isShow ? 'Հայերեն-իտալերեն' : 'Իտալերեն- Հայերեն',
                    style: TextStyle(
                        fontSize: 14,
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
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back_ios_new_outlined,
                  color: Palette.appBarTitleColor,
                ),
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
            child: DelegateChild(
              characterByindex: characterByindex,
              characterIndex: characterIndex,
              characters: characters,
              isShow: isShow,
            ),
          )
        ]),
      ),
    );
  }
}

class DelegateChild extends StatefulWidget {
  DelegateChild({
    Key? key,
    required this.characterByindex,
    required this.characters,
    required this.characterIndex,
    required this.isShow,
  }) : super(key: key);

  final String characterByindex;
  final int characterIndex;
  final Object characters;
  final bool isShow;

  @override
  State<DelegateChild> createState() => _DelegateChildState(
      characterByindex: characterByindex,
      characters: characters,
      characterIndex: characterIndex,
      isShow: isShow);
}

class _DelegateChildState extends State<DelegateChild>
    with SingleTickerProviderStateMixin {
  _DelegateChildState({
    required this.characterByindex,
    required this.characters,
    required this.characterIndex,
    required this.isShow,
  });

  final bookDataProvider = BookDataProvider();
  final String characterByindex;
  final int characterIndex;
  final Object characters;
  final userDataProvider = UserDataProvider();
  int? custemerId;
  Future<List<Data>?>? charctersDataArmenian;
  Future<List<Data>?>? charctersDataItalian;
  final bool isShow;

  late TabController _tabController;

  @override
  void initState() {
    _tabController = TabController(
        length: isShow ? wordsArm.length : wordsIt.length,
        vsync: this,
        initialIndex: characterIndex,
        animationDuration: Duration.zero);
    isShow
        ? charctersDataArmenian = bookDataProvider.getDataByCharacters(
            Api.armenianDictionaryByCharacters(characterByindex))
        : charctersDataItalian = bookDataProvider.getDataByCharacters(
            Api.italianDictionaryByCharacters(characterByindex));
    userDataProvider.fetchUserInfo().then((value) => custemerId = value?.id??0);

    super.initState();
  }

  Widget buildData() {
    print('dadas');
    return FutureBuilder<List<Data>?>(
      future: isShow ? charctersDataArmenian : charctersDataItalian,
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
            return const Text('Error');
          } else if (snapshot.hasData) {
            return ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.vertical,
              itemCount: data?.length,
              itemBuilder: (context, index) {
                return ExpansionTile(
                  title: Text(
                    '${data?[index].title}',
                    style: TextStyle(
                      fontFamily: 'GHEAGrapalat',
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1,
                    ),
                  ),
                  controlAffinity: ListTileControlAffinity.leading,
                  leading: SvgPicture.asset('assets/images/line24.svg'),
                  initiallyExpanded: false,
                  children: [
                    Container(
                      color: Color.fromRGBO(246, 246, 246, 1),
                      child: ListTile(
                        title: Text('${data?[index].body}'),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(left: 25.0, right: 25.0),
                      color: Color.fromRGBO(255, 255, 255, 1),
                      width: double.infinity,
                      height: 49,
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () async {
                              await Share.share(data![index].sharurl!);
                              // showDialog(
                              //     context: context,
                              //     barrierDismissible: true,
                              //     builder: (
                              //       context,
                              //     ) =>
                              //         SaveShowDialog(
                              //           isShow: false,
                              //         ));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/այքըններ.svg'),
                                const SizedBox(width: 6),
                                const Text('Կիսվել ')
                              ],
                            ),
                          ),
                          Spacer(),
                          InkWell(
                            onTap: () {
                              var saveData = <String, dynamic>{
                                'type': isShow ? 'armenians' : 'italians',
                                'type_id': data?[index].id,
                                'customer_id': custemerId,
                              };
                              setState(() {
                                userIsSign(saveData);
                              });

                              //    showDialog(
                              // context: context,
                              // barrierDismissible: false,
                              // builder: (
                              //   context,
                              // ) =>
                              //     SaveShowDialog(isShow: true));
                            },
                            child: Row(
                              children: [
                                SvgPicture.asset('assets/images/վելացնել1.svg'),
                                const SizedBox(width: 6),
                                const Text('Պահել'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                );
              },
            );
          } else {
            return const Text('Empty data');
          }
        } else {
          return Text('State: ${snapshot.connectionState}');
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    print("dadas");
    return DefaultTabController(
        initialIndex: characterIndex,
        length: isShow ? wordsArm.length : wordsIt.length,
        child: Scaffold(
            backgroundColor: Palette.textLineOrBackGroundColor,
            appBar: PreferredSize(
                preferredSize: Size(18.0, 50.0),
                child: Container(
                    color: Color.fromRGBO(246, 246, 246, 1),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 7.0),
                      child: TabBar(
                        indicatorWeight: 2,
                        unselectedLabelColor:
                            const Color.fromRGBO(122, 108, 115, 1),
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
                        labelPadding:
                            const EdgeInsets.symmetric(horizontal: 15),
                        onTap: (index) {
                          print(wordsIt.elementAt(index).toLowerCase());
                          setState(() {
                            isShow
                                ? characters
                                        .toString()
                                        .toLowerCase()
                                        .contains(wordsArm.elementAt(index))
                                    ? charctersDataArmenian =
                                        bookDataProvider.getDataByCharacters(
                                            Api.armenianDictionaryByCharacters(
                                                wordsArm.elementAt(index)))
                                    : null
                                : characters.toString().toLowerCase().contains(
                                        wordsIt.elementAt(index).toLowerCase())
                                    ? charctersDataItalian =
                                        bookDataProvider.getDataByCharacters(
                                            Api.italianDictionaryByCharacters(
                                                wordsIt
                                                    .elementAt(index)
                                                    .toLowerCase()))
                                    : null;
                          });
                        },
                        tabs: isShow
                            ? wordsArm.map((tabName) {
                                return Tab(
                                  child: Text(
                                    tabName,
                                    style: TextStyle(
                                      fontFamily: 'ArshaluyseArtU',
                                      fontSize: 23,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: characters
                                              .toString()
                                              .toLowerCase()
                                              .contains(tabName.toLowerCase())
                                          ? null
                                          : Color.fromRGBO(186, 166, 177, 1),
                                    ),
                                  ),
                                );
                              }).toList()
                            : wordsIt.map((tabName) {
                                return Tab(
                                  child: Text(
                                    tabName,
                                    style: TextStyle(
                                      fontFamily: 'ArshaluyseArtU',
                                      fontSize: 30,
                                      fontStyle: FontStyle.normal,
                                      fontWeight: FontWeight.bold,
                                      color: characters
                                              .toString()
                                              .toLowerCase()
                                              .contains(tabName.toLowerCase())
                                          ? null
                                          : Color.fromRGBO(186, 166, 177, 1),
                                    ),
                                  ),
                                );
                              }).toList(),
                      ),
                    ))),
            body: TabBarView(
                physics: NeverScrollableScrollPhysics(),
                controller: _tabController,
                children: isShow
                    ? wordsArm
                        .map(
                          (e) => characters
                                  .toString()
                                  .toLowerCase()
                                  .contains(e.toLowerCase())
                              ? buildData()
                              : Container(
                                  child: Center(
                                    child: Text('Empty data'),
                                  ),
                                ),
                        )
                        .toList()
                    : wordsIt
                        .map(
                          (e) => characters
                                  .toString()
                                  .toLowerCase()
                                  .contains(e.toLowerCase())
                              ? buildData()
                              : Container(
                                  child: Center(
                                      child: CircularProgressIndicator(
                                  strokeWidth: 2.0,
                                  color: Palette.main,
                                ))),
                        )
                        .toList())));
  }

  void userIsSign(Map<String, dynamic> data) async {
    Users? hasId = await userDataProvider.fetchUserInfo();
    bool isSign = await userDataProvider.saveFavorite(data);

    if (!isSign || hasId == null) {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (
            context,
          ) =>
              SaveShowDialog(
                isShow: true,
              ));
    }
  }
}

class ItalianArmenian extends StatelessWidget {
  const ItalianArmenian({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Scaffold(
        body: GridView.count(
          mainAxisSpacing: 30,
          crossAxisCount: 7,
          physics: NeverScrollableScrollPhysics(),
          children: List.generate(wordsIt.length, (index) {
            return Center(
              child: InkWell(
                onTap: () {
                  print('hi');
                },
                child: Text(
                  '${wordsIt[index]}',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.rye(
                      fontSize: 20,
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.bold),
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

List<String> wordsIt = [
  'A',
  'B',
  'C',
  'D',
  'E',
  'F',
  'G',
  'H',
  'I',
  'J',
  'K',
  'L',
  'M',
  'N',
  'O',
  'P',
  'Q',
  'R',
  'S',
  'T',
  'U',
  '',
  'V',
  'W',
  'X',
  'Y',
  'Z'
];
