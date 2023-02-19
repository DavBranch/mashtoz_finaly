import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/domens/models/book_data/data.dart';
import 'package:mashtoz_flutter/domens/repository/info_data_provider.dart';
import 'package:mashtoz_flutter/globals.dart';

import 'package:mashtoz_flutter/ui/widgets/helper_widgets/menuShow.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/size_config.dart';
import 'package:mashtoz_flutter/ui/widgets/main_page/main_menu_pages/contact_page.dart';
import '../../../../config/palette.dart';

class InfoPage extends StatefulWidget {
  final bool isShow;
  const InfoPage({Key? key, required this.isShow}) : super(key: key);

  @override
  State<InfoPage> createState() => _InfoPageState(isShow: isShow);
}

class _InfoPageState extends State<InfoPage> {
  final infoDataProvider = InfoDataProvider();
  final bool isShow;

  _InfoPageState({required this.isShow});

  Future<Data>? futureInfoAbautUs;
  Future<Data>? futureInfoDonation;
  @override
  void initState() {
    futureInfoAbautUs = infoDataProvider.getInfoAbaoutUs_Donation(Api.abaoutUs);
    futureInfoDonation =
        infoDataProvider.getInfoAbaoutUs_Donation(Api.donation);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isShow
          ? const Color.fromRGBO(117, 99, 111, 1)
          : Color.fromRGBO(226, 224, 224, 1),
      body: SafeArea(
        child: FutureBuilder<Data>(
          future: isShow ? futureInfoAbautUs : futureInfoDonation,
          builder: (context, snapshot) {
            var characters = snapshot.data;
            if (snapshot.hasData) {
              return CustomScrollView(slivers: [
                SliverAppBar(
                  leading: IconButton(onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back_ios_new_outlined),color:isShow? Colors.white:const Color.fromRGBO(117, 99, 111, 1),),
                  flexibleSpace: Container(
                    margin: EdgeInsets.only(left: 50),
                    height: double.infinity,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: EdgeInsets.only(left: 20.0),
                        child: Text(
                          '${characters?.title}',
                          style: TextStyle(
                              fontSize: 16,
                              letterSpacing: 1,
                              fontFamily: 'GHEAGrapalat',
                              fontWeight: FontWeight.w700,
                              color: isShow
                                  ? Palette.textLineOrBackGroundColor
                                  : const Color.fromRGBO(117, 99, 111, 1)),
                          textAlign: TextAlign.start,
                        ),
                      ),
                    ),
                  ),
                  expandedHeight: 51,
                  backgroundColor: isShow
                      ? const Color.fromRGBO(117, 99, 111, 1)
                      : Color.fromRGBO(226, 224, 224, 1),
                  elevation: 0,
                  automaticallyImplyLeading: false,
                  systemOverlayStyle: SystemUiOverlayStyle(
                      statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                  actions: [
                    Padding(
                        padding: EdgeInsets.only(right: 20.0),
                        child: MenuShow()),
                  ],
                ),
                SliverFillRemaining(
                  hasScrollBody: true,
                  child: Stack(
                    children: [
                      isShow
                          ? Positioned.fill(
                              top: 63,
                              child: Align(
                                alignment: Alignment.topCenter,
                                child: SizedBox(
                                  width: 120.0,
                                  height: 120.0,
                                  child: Expanded(
                                    child: CircleAvatar(
                                      backgroundColor: Colors.transparent,
                                      child: CachedNetworkImage(
                                        imageUrl: "${characters?.image!}",
                                        fit: BoxFit.cover,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      Positioned.fill(
                        top: isShow ? 235 : 0.0,
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          physics: NeverScrollableScrollPhysics(),
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        right: 20.0, left: 20.0),
                                    child: Text(
                                      '${characters?.body?.replaceAll('&nbsp;', ' ')}',
                                      style: TextStyle(
                                        fontFamily: 'GHEAGpalat',
                                        fontWeight: FontWeight.w400,
                                        letterSpacing: 1.2,
                                        fontSize: 14,
                                        color: isShow
                                            ? Palette.textLineOrBackGroundColor
                                            : Color.fromRGBO(51, 51, 51, 1),
                                      ),
                                      textAlign: TextAlign.justify,
                                    ),
                                  ),
                                  isShow &&
                                          SizeConfig.orentation ==
                                              Orientation.portrait
                                      ? SizedBox(height: 30)
                                      : isShow
                                          ? SizedBox(height: 300)
                                          : SizedBox(height: 0.1),
                                  isShow
                                      ? Container(
                                          padding: EdgeInsets.only(top: 20),
                                          alignment: Alignment(0.0, -1.0),
                                          color:
                                              Color.fromRGBO(226, 224, 224, 1),
                                          height: 100,
                                          width: double.infinity,
                                          child: Expanded(
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                RichText(
                                                  textAlign: TextAlign.center,
                                                  text: TextSpan(
                                                    style: TextStyle(
                                                        fontFamily:
                                                            'GHEAGpalat',
                                                        fontWeight:
                                                            FontWeight.w400,
                                                        letterSpacing: 1.2,
                                                        fontSize: 14,
                                                        color: Colors.black),
                                                    children: <TextSpan>[
                                                      TextSpan(
                                                        text:
                                                            'Հուսով եմ, այս կայքի էջերը օգտակար\n',
                                                      ),
                                                      TextSpan(
                                                        text:
                                                            'են լինում Ձեզ։\n',
                                                      ),
                                                      TextSpan(
                                                          text:
                                                              'Որևէ հարցով, '),
                                                      TextSpan(
                                                        text: ' գրեցեք ինձ:',
                                                        style: TextStyle(
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                        recognizer:
                                                            TapGestureRecognizer()
                                                              ..onTap = () {
                                                                Navigator.push(
                                                                    context,
                                                                    MaterialPageRoute(
                                                                        builder:
                                                                            (_) =>
                                                                                Contact()));
                                                              },
                                                      ),
                                                    ],
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        )
                                      : Container(),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      // isShow
                      //     ? Positioned.fill(
                      //         bottom: 93,
                      //         child: Align(
                      //           alignment: Alignment.bottomCenter,
                      //           child: Container(
                      //             padding: EdgeInsets.only(top: 20),
                      //             alignment: Alignment(0.0, -1.0),
                      //             color: Color.fromRGBO(226, 224, 224, 1),
                      //             height: 100,
                      //             width: double.infinity,
                      //             child: Expanded(
                      //               child: Row(
                      //                 mainAxisAlignment:
                      //                     MainAxisAlignment.center,
                      //                 children: [
                      //                   RichText(
                      //                     textAlign: TextAlign.center,
                      //                     text: TextSpan(
                      //                       style: TextStyle(
                      //                           fontFamily: 'GHEAGpalat',
                      //                           fontWeight: FontWeight.w400,
                      //                           letterSpacing: 1.2,
                      //                           fontSize: 14,
                      //                           color: Colors.black),
                      //                       children: <TextSpan>[
                      //                         TextSpan(
                      //                           text:
                      //                               'Հուսով եմ, այս կայքի էջերը օգտակար\n',
                      //                         ),
                      //                         TextSpan(
                      //                           text: 'են լինում Ձեզ։\n',
                      //                         ),
                      //                         TextSpan(text: 'Որևէ հարցով, '),
                      //                         TextSpan(
                      //                           text: ' գրեցեք ինձ:',
                      //                           style: TextStyle(
                      //                               fontWeight:
                      //                                   FontWeight.bold),
                      //                           recognizer:
                      //                               TapGestureRecognizer()
                      //                                 ..onTap = () {
                      //                                   Navigator.push(
                      //                                       context,
                      //                                       MaterialPageRoute(
                      //                                           builder: (_) =>
                      //                                               Contact()));
                      //                                 },
                      //                         ),
                      //                       ],
                      //                     ),
                      //                   )
                      //                 ],
                      //               ),
                      //             ),
                      //           ),
                      //         ),
                      //       )
                      //     : Container(),
                    ],
                  ),
                )
              ]);
            } else {
              return Container(
                child: Center(
                    child: CircularProgressIndicator(
                  color: Palette.main,
                )),
              );
            }
          },
        ),
      ),
    );
  }
}
//  FutureBuilder<Data?>(
//                 future: futureInfo,
//                 builder: (context, snapshot) {
//                   var characters = snapshot.data;

//                   if (snapshot.hasData) {
//                     return Column(
//                       children: [
//                         ListView(
//                           scrollDirection: Axis.vertical,
//                           shrinkWrap: true,
//                           padding: EdgeInsets.all(12.0),
//                           physics: NeverScrollableScrollPhysics(),
//                           children: [
//                             Text(
//                               '${characters!.body}',
//                               style: TextStyle(
//                                   fontFamily: 'GHEAGpalat',
//                                   fontWeight: FontWeight.w400,
//                                   letterSpacing: 1.2,
//                                   fontSize: 14,
//                                   color: Palette.textLineOrBackGroundColor),
//                             ),
//                           ],
//                         ),
//                       ],
//                     );
//                   } else {
//                     return Container(
//                       child: Center(child: CircularProgressIndicator()),
//                     );
//                   }
//                 },
//               )
