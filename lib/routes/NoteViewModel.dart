import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:sqflite/sqflite.dart' as sql;

class NoteViewModel {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        diary TEXT,
        tag TEXT,
        img INTEGER,
        lat TEXT,
        lng TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """); // 一旦画像と位置情報はパス
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'note4.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(
      String diary, String? tag, int img, String lat, String lng) async {
    final db = await NoteViewModel.db();

    final data = {
      'diary': diary,
      'tag': tag,
      'img': img,
      'lat': lat,
      'lng': lng,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  static Future<List<Map<String, dynamic>>> getNotes() async {
    final db = await NoteViewModel.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await NoteViewModel.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  // itemsからimgがある投稿のidとimgとlatとlngのみを取得する関数(map_route.dartで使用)
  static Future<List<Map<String, dynamic>>> getImageLatLng() async {
    final db = await NoteViewModel.db();
    return db.query('items', columns: ['id','img','lat','lng'], where: "img != ?", whereArgs: [0], orderBy: "id");
  }

  static Future<int> updateItem(
      int id, String diary, String? tag, int img, String lat, String lng) async {
    final db = await NoteViewModel.db();

    final data = {
      'diary': diary,
      'tag': tag,
      'img': img,
      'lat': lat,
      'lng': lng,
      // 'createdAt': DateTime.now().toString()
    };

    //print(lat);

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await NoteViewModel.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
