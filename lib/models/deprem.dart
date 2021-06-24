import 'package:intl/intl.dart';
import 'package:webfeed/domain/rss_item.dart';

class Deprem {
  final String baslik;
  final String tarih;
  final String saat;
  final String buyukluk;
  final double enlem;
  final double boylam;

  const Deprem({
    required this.baslik,
    required this.tarih,
    required this.saat,
    required this.buyukluk,
    required this.enlem,
    required this.boylam,
  });

  factory Deprem.fromRssItem(RssItem item) {
    var splitDesc = item.description?.split(' ');
    var title = item.title?.split(' ');
    // Son 2 elemanı sil
    title?.removeLast();
    title?.removeLast();
    return Deprem(
      baslik: title?.join(' ') ?? '',
      enlem: double.parse(splitDesc?[4] ?? '0'),
      boylam: double.parse(splitDesc?[5] ?? '0'),
      buyukluk: splitDesc?[6] ?? '0.0',
      saat: DateFormat(DateFormat.HOUR24_MINUTE)
          .format(item.pubDate ?? DateTime.now()),
      tarih: DateFormat('dd.mm.yyyy').format(item.pubDate ?? DateTime.now()),
    );
  }

  factory Deprem.fromJson(Map<String, dynamic> json) {
    return Deprem(
        baslik: json['baslik'],
        tarih: json['tarih'],
        saat: json['saat'],
        buyukluk: json['buyukluk'],
        enlem: json['enlem'],
        boylam: json['boylam']);
  }
  Map<String, dynamic> toJson() {
    return {
      'baslik': baslik,
      'tarih': tarih,
      'saat': saat,
      'buyukluk': buyukluk,
      'enlem': enlem,
      'boylam': boylam
    };
  }
}
