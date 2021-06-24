import 'dart:async';
import '../../models/deprem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  final _tableName = "depremler";
  Database? _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db!;
  }

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "etrade.db");
    var eTrade = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTrade;
  }

  // SQLITE veri tabanını oluştur
  void createDb(Database db, int version) async {
    await db.execute(
        "Create table $_tableName (id integer primary key, baslik text, tarih text, saat text, buyukluk text ,enlem real, boylam real )");
  }

  // db'den tüm depremleri çek
  Future<List<Deprem>> getDepremler() async {
    Database? db = await this.db;

    var response = await db.query(_tableName);

    return response.map((e) => Deprem.fromJson(e)).toList();
  }

  // Dbdeki kayıtları silip yeni gelen verileri üzerine yaz
  Future<void> batchInsertOverWrite(List<Deprem> depremler) async {
    Database? db = await this.db;

    Batch _batch = db.batch();
    _batch.delete(_tableName);
    depremler.forEach((deprem) {
      _batch.insert(_tableName, deprem.toJson());
    });

    _batch.commit();
  }

  // başlığa göre depremleri getir
  Future<List<Deprem>> search(String key) async {
    final db = await this.db;
    var response = await db.query(_tableName, where: "baslik LIKE '%$key%' ");
    return response.map((e) => Deprem.fromJson(e)).toList();
  }

  // depremleri seçeneğe göre sıralı getir
  Future<List<Deprem>> sortBy(Object option) async {
    final db = await this.db;
    var response = await db.query(_tableName, orderBy: "buyukluk $option ");
    return response.map((e) => Deprem.fromJson(e)).toList();
  }
}
