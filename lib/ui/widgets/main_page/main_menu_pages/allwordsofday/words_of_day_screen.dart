import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mashtoz_flutter/config/palette.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';
import 'package:mashtoz_flutter/domens/repository/book_data_provdier.dart';

import '../../../../../main.dart';
import '../../../helper_widgets/menuShow.dart';

class AfterWordsOfDayScreen extends StatefulWidget {
  const AfterWordsOfDayScreen({Key? key}) : super(key: key);

  @override
  State<AfterWordsOfDayScreen> createState() => _AfterWordsOfDayScreenState();
}

class _AfterWordsOfDayScreenState extends State<AfterWordsOfDayScreen> {
  Future<List<WordOfDay>>? _futureAfterWordsDay;
  final _bookDataProvider = BookDataProvider();

  @override
  void initState() {
    _futureAfterWordsDay = _bookDataProvider.getAfterWordsOfDay();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: ()async{
        // Navigator.of(context).pop();
        return false;
      },
      child: SafeArea(
      child:
      Scaffold(
        backgroundColor: Palette.searchBackGroundColor,
        appBar: AppBar(
          leading:  isWhichPlatform ? IconButton(
            padding: EdgeInsets.only(left:isWhichPlatform?  20 : 0.0  ,right: 20),
            alignment: Alignment.centerRight,
            onPressed: ()=>Navigator.of(context).pop(), icon: Icon(Icons.arrow_back_ios_new_outlined),color:Palette.appBarTitleColor,):null,
          leadingWidth: isWhichPlatform ? 20 : null,
          title: Align(
            alignment: Alignment.centerLeft,
            child: Padding(
              padding:  EdgeInsets.only(left: isWhichPlatform ? 20 :0.0),
              child: Text(
                'Նախորդ խոսքեր',
                style: TextStyle(
                    fontSize: 20,
                    letterSpacing: 1,
                    fontFamily: 'GHEAGrapalat',
                    fontWeight: FontWeight.bold,
                    color: Palette.appBarTitleColor),
              ),
            ),
          ),
          backgroundColor: Palette.searchBackGroundColor,
          elevation: 0,
          automaticallyImplyLeading: false,
          systemOverlayStyle: SystemUiOverlayStyle(
              statusBarColor: Color.fromRGBO(25, 4, 18, 1)),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: MenuShow(),
            ),
          ],
        ),
        body: FutureBuilder<List<WordOfDay>>(
          future: _futureAfterWordsDay,
          builder: (BuildContext context, AsyncSnapshot<List<WordOfDay>> snapshot) {
            var data = snapshot.data;
          if(snapshot.connectionState == ConnectionState.waiting){
            return const Center(child: Text('Waiting...'),);

          }
          if(snapshot.connectionState == ConnectionState.done) {
            return ListView.builder(
              itemCount: snapshot.data?.length,
              itemBuilder: (context,index) {
              WordOfDay?  wordOfDay =  snapshot.data?[index];
                return Column(
                  children: [
                    Container(
                      height: 339,

                      child: Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.only(
                                right: 20.0, left: 20.0),
                            color: const Color.fromRGBO(
                                246, 246, 246, 1),
                            child: Stack(
                              children: [
                                Positioned.fill(
                                    child: Align(
                                        alignment: Alignment
                                            .bottomRight,
                                        child: Container(
                                            padding: const EdgeInsets
                                                .only(
                                                left:
                                                16.0,
                                                right:
                                                16.0),
                                            height: 50,
                                            child: Row(
                                              mainAxisAlignment : MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  '${wordOfDay?.author}',
                                                  textAlign:
                                                  TextAlign
                                                      .center,
                                                ),

                                              ],
                                            )))),
                                Positioned.fill(
                                  top: 14.0,
                                  left: 16.0,
                                  right: 7.0,
                                  bottom: 61,
                                  child: Align(
                                    alignment:
                                    Alignment.topCenter,
                                    child: Container(
                                        color: const Color.fromRGBO(
                                            246, 246, 246, 1),
                                        width:
                                        double.infinity,
                                        height: 264,
                                        child: Scrollbar(
                                            thickness: 1.5,
                                            radius: const Radius
                                                .circular(12),
                                            thumbVisibility:
                                            false,
                                            showTrackOnHover:
                                            true,
                                            child: Center(
                                                child:
                                                ListView(
                                                  scrollDirection:
                                                  Axis.vertical,
                                                  shrinkWrap:
                                                  true,
                                                  children: [
                                                    Padding(
                                                        padding: const EdgeInsets
                                                            .all(
                                                            12.0),
                                                        child: Text(
                                                            '${wordOfDay?.summary}'))
                                                  ],
                                                )))),
                                  ),
                                ),
                                const Positioned.fill(
                                    bottom: 40,
                                    child: Align(
                                      alignment: Alignment
                                          .bottomCenter,
                                      child: Padding(
                                        padding:
                                        EdgeInsets
                                            .only(
                                            right: 20.0,
                                            left: 20.0),
                                        child: Divider(
                                          thickness: 1,
                                        ),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20,),

                  ],
                );
              }
            );
          }else if (snapshot.hasError){
            print('error');
          }

            return const CircularProgressIndicator(color: Palette.main,);
        },

        ),
      )),
    );
  }
}
