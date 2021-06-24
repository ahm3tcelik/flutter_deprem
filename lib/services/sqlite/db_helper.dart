import 'dart:async';

import 'package:flutter_deprem/models/deprem.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  Database? _db;

  Future<Database?> get db async {
    if (_db == null) {
      _db = await initializeDb();
    }
    return _db;
  }

  get createDb => null;

  Future<Database> initializeDb() async {
    String dbPath = join(await getDatabasesPath(), "etrade.db");
    var eTrade = await openDatabase(dbPath, version: 1, onCreate: createDb);
    return eTrade;
  }
/*
  void createDb(Database db, int version) async {
    await db.execute(
        "Create table products (id integer primary key, baslik text, aciklama text )");
  }

  Future<List<Deprem>> getProducts() async {
    Database? db = await this.db;

    var response = await db!.query("products");

    return List.generate(
        response.length, (index) => Deprem.fromJson(response[index]));
  }

  Future<int> insert(Deprem product) async {
    Database? db = await this.db;

    var response = await db!.insert("products", product.toJson());
    return response;
  }

  Future<int> delete(int id) async {
    Database? db = await this.db;

    var response = await db!.rawDelete("Delete from products where id=$id");
    return response;
  }

  Future<int> update(Deprem product) async {
    Database? db = await this.db;

    var response = await db!.update("products", product.toJson(),
        where: "id=?", whereArgs: [product.id]);
    return response;
  }
*/
}