import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/svg.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';
import 'package:mashtoz_flutter/domens/repository/user_data_provider.dart';
import 'package:mashtoz_flutter/ui/widgets/helper_widgets/save_show_dialog.dart';
import 'package:share_plus/share_plus.dart';

import '../../../helper_widgets/menuShow.dart';
import '../../../youtube_videos/advanced_overlay.dart';

class ItaliaLessonShow extends StatefulWidget {
  final Lessons? lessons;
  final bool? isShow;
  final String? idLessons;
  const ItaliaLessonShow({Key? key, this.lessons, this.isShow, this.idLessons})
      : super(key: key);

  @override
  State<ItaliaLessonShow> createState() => _ItaliaLessonShowState(
      lessons: lessons, isShow: isShow, idLessons: idLessons);
}

class _ItaliaLessonShowState extends State<ItaliaLessonShow> {
  Lessons? lessons;
  final bool? isShow;
  final String? idLessons;
  int? custemerId = 0;
  _ItaliaLessonShowState({this.lessons, this.isShow, this.idLessons});
  @override
  void initState() {
    userDataProvider.fetchUserInfo().then((value) => custemerId = value?.id??0);
    bookDataProvider.getLessons().then((ls) {
      ls.forEach((l) {
        if (idLessons != null) {
          if ("(${l.id})".toString().contains(idLessons.toString())) {
            lessons = l;
            setState(() {});
          }
        }
      });
    });
    super.initState();
  }

  final userDataProvider = UserDataProvider();
  final bookDataProvider = BookDataProvider();
  @override
  Widget build(BuildContext context) {
    final orentation = MediaQuery.of(context).orientation;
    print("CustomerId  : ${custemerId}");

    return lessons != null
        ? Scaffold(
            backgroundColor: Palette.textLineOrBackGroundColor,
            body: Padding(
              padding: const EdgeInsets.only(right: 20, left: 20.0),
              child: CustomScrollView(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                slivers: [
                  orentation != Orientation.landscape
                      ? SliverAppBar(
                          // title: Transform(
                          //   transform:
                          //       Matrix4.translationValues(-40.0, 0.0, 0.0),
                          //   child: Text(
                          //     '${lessons?.number}',
                          //     style: TextStyle(
                          //         fontSize: 16,
                          //         letterSpacing: 1,
                          //         fontFamily: 'GHEAGrapalat',
                          //         fontWeight: FontWeight.w700,
                          //         color: Palette.appBarTitleColor),
                          //   ),
                          // ),
                          floating: false,
                          pinned: true,
                          leading: Container(
                            width: 7,
                            height: 14,
                            child: IconButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              //iconSize: 13,
                              icon: const Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Palette.appBarTitleColor,
                              ),
                              padding: const EdgeInsets.only(right: double.infinity),
                              alignment: Alignment.center,
                            ),
                          ),
                          expandedHeight: 77,
                          backgroundColor: Palette.textLineOrBackGroundColor,
                          elevation: 0,
                          automaticallyImplyLeading: false,
                          systemOverlayStyle: const SystemUiOverlayStyle(
                              statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
                          actions: [
                            const MenuShow(),
                          ],
                        )
                      : const SliverToBoxAdapter(),
                  SliverToBoxAdapter(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      child: Column(
                        children: [
                          Container(
                            child: GestureDetector(
                              onTap: () {
                                Navigator.of(context, rootNavigator: true)
                                    .push(MaterialPageRoute(
                                        builder: (context) => VideoView(
                                                  link: lessons!.link!,
                                            )));
                              },
                              child: Stack(
                                children: [
                                  CachedNetworkImage(
                                    imageUrl: lessons!.image!,
                                  ),
                                  const Positioned.fill(
                                    child: Align(
                                      alignment: Alignment.center,
                                      child: Center(
                                        child: Icon(
                                          Icons.play_arrow,
                                          color: Colors.white,
                                          size: 70,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(height: 20),
                          SizedBox(
                            width: MediaQuery.of(context).size.width,
                            child: Flexible(
                              child: Text(
                                lessons!.title ?? '',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 12.0,
                                  fontFamily: 'GHEAGrapalat',
                                  letterSpacing: 1,
                                  color: Color.fromRGBO(84, 112, 126, 1),
                                ),
                                textAlign: TextAlign.start,
                              ),
                            ),
                          ),
                          const SizedBox(height: 15.0),
                          const Divider(),
                          orentation != Orientation.landscape
                              ? Container(
                                  color: Palette.textLineOrBackGroundColor,
                                  width: double.infinity,
                                  height: 49,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          await Share.share(lessons!.link!);
                                          // print('kisvel');

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
                                            //  const SizedBox(width: 16),
                                            SvgPicture.asset(
                                                'assets/images/այքըններ.svg'),
                                            const SizedBox(width: 6),
                                            const Text('Կիսվել')
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      InkWell(
                                        onTap: () {
                                          var data = <String, dynamic>{
                                            'type': 'lessons',
                                            'type_id': lessons?.id,
                                            'customer_id': custemerId,
                                          };
                                          setState(() {
                                            userIsSign(data);
                                          });


                                        },
                                        child: Row(
                                          children: [
                                            SvgPicture.asset(
                                                'assets/images/վելացնել1.svg'),
                                            const SizedBox(width: 6),
                                            const Text('Պահել'),
                                            //const SizedBox(width: 16),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ))
                              : const SizedBox(
                                  height: 0.1,
                                ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        : const Center(
          child: CircularProgressIndicator(
            color: Palette.main,
          ),
        );
  }

  void userIsSign(Map<String, dynamic> data) async {
      showDialog(
          context: context,
          barrierDismissible: false,
          useRootNavigator: true,
          builder: (
            context,
          ) =>
              SaveShowDialog(
                data: data,
                isShow: true,
              ));
  }
}
