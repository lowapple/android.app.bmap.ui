import 'package:bmap/components/atoms/like_item.dart';
import 'package:bmap/models/like_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DataStorageLocal {
  var _db;

  Future<Database> get database async {
    if (_db != null) return _db;
    _db = openDatabase(join(await getDatabasesPath(), "parking.db"),
        onCreate: (db, version) async {
      await db.execute(
          "CREATE TABLE like_item(id INTEGER PRIMARY KEY, type TEXT, likeName TEXT, likeAddress TEXT)");
      return;
    }, version: 2);
    return _db;
  }

  Future<void> deleteLikeItem(LikeModel item) async {
    final db = await database;
    await db.delete('like_item', where: 'id = ?', whereArgs: [item.id]);
  }

  Future<void> insertLikeItem(LikeModel item) async {
    final db = await database;
    await db.insert('like_item', item.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<List<LikeModel>> likeItems() async {
    final db = await database;
    final items = await db.query('like_item');
    return List.generate(items.length, (index) {
      return LikeModel.fromJson(items[index]);
    });
  }
}
