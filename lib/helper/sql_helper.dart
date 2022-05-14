import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;
import 'package:todo_list/models/todo.dart';

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE items(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        date TEXT,
        time TEXT,
        location Text
      )
      """);
  }

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'todo.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  static Future<int> createItem(ToDo todo) async {
    final db = await SQLHelper.db();

    final data = {
      'title': todo.title,
      'description': todo.description,
      'date': todo.date,
      'time': todo.time,
      'location': todo.location,
    };
    final id = await db.insert('items', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);

    return id;
  }

  static Future<List<Map<String, dynamic>>> getItems() async {
    final db = await SQLHelper.db();
    return db.query('items', orderBy: "id");
  }

  static Future<List<Map<String, dynamic>>> getItem(int? id) async {
    final db = await SQLHelper.db();
    return db.query('items', where: "id = ?", whereArgs: [id], limit: 1);
  }

  static Future<int> updateItem(ToDo toDo) async {
    final db = await SQLHelper.db();

    final data = {
      'title': toDo.title,
      'description': toDo.description,
      'date': toDo.date,
      'time': toDo.time,
      'location': toDo.location,
    };

    final result = await db.update('items', data,
        where: "id = ?", whereArgs: [toDo.id.toString()]);

    return result;
  }

  static Future<void> deleteItem(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("items", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting an item: $err");
    }
  }
}
