import 'dart:convert';
import 'dart:io';
import '../models/deprem.dart';
import 'package:http/http.dart' as http;
import 'package:webfeed/webfeed.dart';

class RssService {
  final rssUrl = 'http://koeri.boun.edu.tr/rss/';
  static RssService? _instance;

  // singleton
  static RssService get instance {
    if (_instance == null) {
      _instance = RssService._internal();
    }
    return _instance!;
  }

  RssService._internal();

  // koeri.boun.edu.tr'den rss verileri çek
  Future<List<Deprem>> fetch() async {
    var result;
    // get isteği gönder
    final response = await http.get(Uri.parse(rssUrl));
    // başarılıysa gelen veriyi işle
    if (response.statusCode == HttpStatus.ok) {
      var feed = RssFeed.parse(utf8.decode(response.bodyBytes));
      result = feed.items?.map((e) => Deprem.fromRssItem(e)).toList();
    } else {
      print(response.statusCode);
    }
    return result ?? [];
  }
}
