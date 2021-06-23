import 'dart:convert';
import 'dart:io';
import 'package:flutter_deprem/models/deprem.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssService {
  final rssUrl = 'http://koeri.boun.edu.tr/rss/';
  static RssService? _instance;

  static RssService get instance {
    if (_instance == null) {
      _instance = RssService._internal();
    }
    return _instance!;
  }

  RssService._internal();

  Future<List<Deprem>> fetch() async {
    var result;
    final response = await http.get(Uri.parse(rssUrl));
    if (response.statusCode == HttpStatus.ok) {
      var feed = RssFeed.parse(utf8.decode(response.bodyBytes));
      result = feed.items?.map((e) => Deprem.fromRssItem(e)).toList();
    } else {
      print(response.statusCode);
    }
    return result ?? [];
  }
}
