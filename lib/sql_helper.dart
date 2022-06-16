import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute(
        """CREATE TABLE items(id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,image TEXT,firstname TEXT,lastname TEXT,mobile TEXT,password TEXT,date TEXT,address TEXT,createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP)""");
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Update an item by id
  static Future<int> updateItem(
      int id,
      String image,
      String firstname,
      String lastname,
      String mobile,
      String password,
      String date,
      String address) async {
    final db = await SQLHelper.db();

    final data = {
      'image': image,
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'password': password,
      'date': date,
      'address': address,
    };

    final result =
        await db.update('items', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Create new item (journal)
  static Future<int> createItem(String image, String firstname, String lastname,
      String mobile, String password, String date, String address) async {
    final db = await SQLHelper.db();

    final data = {
      'image': image,
      'firstname': firstname,
      'lastname': lastname,
      'mobile': mobile,
      'password': password,
      'date': date,
      'address': address
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all items (journals)
  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  // Read a single item by id
  // The app doesn't use this method but I put here in case you want to see it
  static Future<List<Map<String, dynamic>>> getItem(int id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<List<Map<String, dynamic>>> selectLogin(
      String mobile, String pass) async {
    final db = await SQLHelper.db();
    return db.query('items',
        where: "mobile = ? AND password = ? ",
        whereArgs: [mobile, pass],
        limit: 1);
  }

  static Future<List<Map<String, dynamic>>> getdate(String mobile) async {
    final db = await SQLHelper.db();
    return db.query('items',
        where: "mobile = ?", whereArgs: [mobile], limit: 1);
  }

  // Delete
  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
