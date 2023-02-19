import 'dart:convert';

import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:http/http.dart' as http;

import 'package:mashtoz_flutter/domens/data_providers/session_data_provider.dart';
import 'package:mashtoz_flutter/domens/models/book_data/book_home_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/category_lsit.dart';
import 'package:mashtoz_flutter/domens/models/book_data/gallery_data.dart';
import 'package:mashtoz_flutter/domens/models/book_data/lessons.dart';
import 'package:mashtoz_flutter/domens/models/book_data/word_of_day.dart';

import '../../globals.dart';
import '../models/book_data/content_list.dart';
import '../models/book_data/data.dart';

class BookDataProvider {
  Stream<FileResponse>? fileStream;
  CacheManager? cacheManager;
  final sessionDataProvider = SessionDataProvider();

  //Fetch Category List
  Future<List<BookCategory>> getCategoryLists(String url) async {
    var libraryList = <BookCategory>[];
    //   try {

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    var body = json.decode(response.body);

    var success = body['success'];
    if (success == true) {
      var data = body['data'];

      return (data as List).map((e) => BookCategory.fromJson(e)).toList();

      // print(newData);
      // libraryList.addAll(newData);
    } else {
      print("failed");
    }
    return libraryList;
  }

  //Fetch Library Book By Id
  Future<List<Content>> getLibrarayYbooksById(int idCategory) async {
    var libraryList = <Content>[];
    var response = await http.get(
      Uri.parse(Api.libraryCategoryById(idCategory.toString())),
      headers: <String, String>{
        'Content-Type': 'application/json',
      },
    );

    try {
      print('Fetching from the network');
      var body = json.decode(response.body);
      var content = body['data']['content'];
      var success = body['success'];
      if (success == true) {
        Map.from(content).forEach((key, value) {
          if (key
              .toString()
              .contains(Map.from(value).values.first.toString())) {
            var data = Content.fromJson(value);
            if(data!=null){
              libraryList.add(data);
            }

          }
        });
        //cacheManager?.putFile('url', fileBytes)
        // file.writeAsBytesSync(body, flush: true, mode: FileMode.write);
      } else {
        print("failed");
        return libraryList;
      }
    } catch (e) {
      print("Imherreeeeeee ${e}");
    }
    return libraryList;
  }

  //Fetch Gallery List
  Future<List<dynamic>> fetchGalleryList() async {
    var galleryList = <dynamic>[];

    try {
      var response = await http.get(
        Uri.parse(Api.gallery),
        headers: <String, String>{
          'Content-Type': 'application/json',
        },
      );

      var body = json.decode(response.body);

      var success = body['success'];
      if (success == true) {
        var data = body['data'];
        Map.from(data).forEach((key, value) {
          (value is List)
              ? galleryList.add([key, value])
              : Map<String, dynamic>.from(value).forEach((key2, value2) {
                  var dataf = [key, Gallery.fromJson(value2)];

                  galleryList.add(dataf);
                });
        });
      }
    } catch (e) {
      print(e);
    }

    return galleryList;
  }

  //Main menu list
  Future<List<Data>?> getMenuList() async {
    var response = await http.get(
      Uri.parse(Api.menu),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true) {
      return (datas as List).map((e) => Data.fromJson(e)).toList();
    } else {
      print("failed");
    }
    return null;
  }

  //Dialect Character
  Future<List<String>> getDialect_Encyclopaedia_Characters(String url) async {
    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];

    if (success == true) {
      var dat = List<String>.from(datas.map((x) => x)).toList();
      return dat;
    } else {
      print("failed");
    }
    return [];
  }

  //Data by characters
  Future<List<Data>> getDataByCharacters(String url) async {
    var dialects = <Data>[];

    var response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true) {
      Map.from(datas).values.forEach((element) {
        //print(element);
        var dat = Data.fromJson(element);
        dialects.add(dat);
      });
      return dialects;
    } else {
      print("failed");
    }
    return dialects;
  }

  //Words of Day
  Future<WordOfDay?> getWordsOfDay() async {
    var response = await http.get(
      Uri.parse(Api.wordsOfDay),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true && response.statusCode == 200) {
      var newData = WordOfDay.fromJson(datas);
      return newData;
    } else {
      print("failed");
      return null;
    }
  }

  Future<WordOfDay?> getWordsOfDayByDate(String date) async {
    var response = await http.get(
      Uri.parse(Api.wordsOfDayByDate(date)),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
    );
    var body = json.decode(response.body);
    var success = body['success'];
    var datas = body['data'];
    if (success == true && response.statusCode == 200) {
      if (datas is List) {
        var newData =
            datas.map((e) => WordOfDay.fromJson(e)).toList().length < 0
                ? datas.map((e) => WordOfDay.fromJson(e)).toList().first
                : WordOfDay();
        return newData;
      } else {
        var newData = WordOfDay.fromJson(datas);
        return newData;
      }
    } else {
      print("failed");
      return WordOfDay(summary: 'dadas');
    }
  }

  //Lessons
  Future<List<Lessons>> getLessons() async {
    var dialects = <Lessons>[];
    try {
      var response = await http.get(
        Uri.parse(Api.italianLessons),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['success'];
      var datas = body['data'];
      if (success == true) {
        var dialects = List.from(datas)
            .map(
              (e) => Lessons.fromJson(e),
            )
            .toList();
        return dialects;
      } else {
        print("failed");
        return dialects;
      }
    } catch (e) {
      print(e);
      throw Exception(e);
    }
  }

  Future<HomeData> getHomeData() async {
    try {
      var response = await http.get(
        Uri.parse(Api.getHomeData),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      var body = json.decode(response.body);
      var success = body['success'];
      if (success == true) {
        var data = body['data'] as Map<String, dynamic>;

        var newData = HomeData.fromJson(data);

        return newData;
      }
    } catch (e) {
      print(e);
      // throw Exception(e);
    }
    return HomeData();
  }
}
