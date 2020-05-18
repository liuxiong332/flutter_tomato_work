import 'package:mywork/tomato_bloc.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

// 将历史数据写入SQLITE数据库
class TomatoStore {
  Future<Database> database;

  Future<void> init() async {
    database = openDatabase(
      join(await getDatabasesPath(), "timer_database.db"),
      onCreate: (db, version) {
        return db.execute("""
          CREATE TABLE tomatos(
            id INTEGER PRIMARY KEY AUTOINCREMENT, 
            name TEXT, 
            start_time INTEGER,
            work_duration INTEGER,
            rest_duration INTEGER,
            stop_time INTEGER
          )
          """);
      },
      version: 1,
    );
    var db = await database;
    print("db $db");
  }

  Future<void> insertRecord(Tomato tomato) async {
    final Database db = await database;
    await db.insert("tomatos", {
      "name": tomato.name,
      "start_time": tomato.startTime.microsecondsSinceEpoch ~/ 1000,
      "work_duration": tomato.workDuration.inMinutes,
      "rest_duration": tomato.restDuration.inMinutes,
      "stop_time": tomato.stopTime != null ? tomato.stopTime.microsecondsSinceEpoch ~/ 1000 : null,
    });
  }

  Future<List<Tomato>> getRecords() async {
    final Database db = await database;
    final List<Map<String, dynamic>> maps = await db.query("tomatos");
    return List.generate(
      maps.length,
      (index) => Tomato.all(
        name: maps[index]["name"],
        startTime: DateTime.fromMicrosecondsSinceEpoch(
          maps[index]["start_time"] * 1000,
        ),
        workDuration: Duration(minutes: maps[index]["work_duration"]),
        restDuration: Duration(minutes: maps[index]["rest_duration"]),
        stopTime: maps[index]["stop_time"] != null ? DateTime.fromMicrosecondsSinceEpoch(
          maps[index]["stop_time"] * 1000,
        ) : null,
      ),
    );
  }
}
