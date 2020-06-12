import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:castillo_crud/model/model_game.dart';
import 'package:sqflite/sql.dart';
import 'package:sqflite/sqlite_api.dart';

class GameDataProvider{
  GameDataProvider._();

  static final GameDataProvider db = GameDataProvider._();
  Database _database;

  Future<Database>get database async{
    if(_database != null) return _database;
    _database = await getDatabaseInstacia();
    return _database;
  }

  Future<Database> getDatabaseInstacia() async{
    Directory directory = await getApplicationDocumentsDirectory();
    String path = join(directory.path, "game.db");
    return await openDatabase(path, version: 1,
      onCreate: (Database db, int version) async{
        await db.execute("CREATE TABLE Game ("
          "id integer primary key,"
          "nombre TEXT,"
          "descripcion TEXT,"
          "costo TEXT,"
          "moneda TEXT,"
          "imagen TEXT,"
          "logic integer"
        ")");
      }
    );
  }

  Future<List<Game>>getAllGames() async {
    final db = await database;
    var response = await db.query("Game");
    List<Game> list = response.map((c)=> Game.fromMap(c)).toList();
    return list;
  }

  Future<List<Game>> getPhotos() async {
    var dbClient = await database;
    List<Map> maps = await dbClient.query("Game", columns: ["id", "imagen"]);
    List<Game> employees = [];
    if (maps.length > 0) {
      for (int i = 0; i < maps.length; i++) {
        employees.add(Game.fromMap(maps[i]));
      }
    }
    return employees;
  }

  Future<Game>getGameWhitId(int id) async{
    final db = await database;
    var response = await db.query("Game",where: "id = ?",whereArgs: [id]);
    return response.isNotEmpty ? Game.fromMap(response.first) : null;
  }

  addGame(Game game )async{
    final db = await database;
    var table = await db.rawQuery("Select MAX(id)+1 as id FROM Game");
    int id = table.first["id"];
    game.id = id;
    var raw = await db.insert("Game",game.toMap(),conflictAlgorithm: ConflictAlgorithm.replace,);
    return raw;
  }

  deleteGameWhithId(int id)async{
    final db = await database;
    return db.delete("Game", where: "id = ?", whereArgs: [id]);
  }

  deleteAllGame() async{
    final db = await database;
    db.delete("Game");
  }

  updateGame(Game game) async{
    final db = await database;
    var response = await db.update("Game", game.toMap(),where: "id = ?", whereArgs: [game.id]);
    return response;
  }

}