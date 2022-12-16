import 'dart:convert';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:sqflite_create_operation/database/data_model.dart';

class DB{
  Future<Database> initDb()async{
    String path = await getDatabasesPath();
    return openDatabase(
      join(path, "MYDb.db"),
      onCreate: (database, version) async {
        await database.execute(
          """
            CREATE TABLE MyTable(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name TEXT NOT NULL
            
            )
          """
        );
      },
      version: 1

    );
    
  }

  Future<bool> insertData(DataModel, dataModel)async{
      final Database db = await initDb();
      db.insert("MyTable", dataModel.toMap());
      return true;
  }

  Future<List<DataModel>> getData()async{
    
      final Database db = await initDb();
      final List<Map<String, dynamic>> datas = await db.query("MyTable");
      return datas.map((e) => DataModel.fromMap(e)).toList();
      
  }


  Future<void> update(DataModel dataModel, int id)async{
      final Database db = await initDb();
      await db.update("MyTable", dataModel.toMap(), where: "id=?",whereArgs: [id]);
  }
}