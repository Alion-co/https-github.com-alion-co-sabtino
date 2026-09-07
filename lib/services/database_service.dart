// lib/services/database_service.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

import '../location_model.dart';



class DatabaseService {


  static Database? _database;



  static Future<Database> get database async {


    if (_database != null) {

      return _database!;

    }


    _database = await _initDatabase();


    return _database!;


  }





  static Future<Database> _initDatabase() async {


    final dbPath = await getDatabasesPath();


    final path = join(

      dbPath,

      "locations.db",

    );



    return openDatabase(


      path,


      version: 1,


      onCreate: (db, version) async {


        await db.execute('''

        CREATE TABLE locations(

          id INTEGER PRIMARY KEY AUTOINCREMENT,

          name TEXT,

          address TEXT,

          phone TEXT,

          latitude REAL,

          longitude REAL

        )

        ''');


      },


    );


  }







  static Future<void> insertLocation(

      LocationData location

      ) async {


    final db = await database;


    await db.insert(

      "locations",

      location.toMap(),

    );


  }







  static Future<List<LocationData>> getLocations() async {


    final db = await database;


    final result = await db.query(

      "locations",

      orderBy: "id DESC",

    );



    return result.map((e) {


      return LocationData.fromMap(e);


    }).toList();


  }







  static Future<void> updateLocation(

      LocationData location

      ) async {


    final db = await database;


    await db.update(

      "locations",

      location.toMap(),

      where: "id = ?",

      whereArgs: [location.id],

    );


  }







  static Future<void> deleteLocation(

      int id

      ) async {


    final db = await database;


    await db.delete(

      "locations",

      where: "id = ?",

      whereArgs: [id],

    );


  }







  static Future<void> deleteLocations(

      List<int> ids

      ) async {


    final db = await database;


    for (var id in ids) {


      await db.delete(

        "locations",

        where: "id = ?",

        whereArgs: [id],

      );


    }


  }







  static Future<void> deleteAllLocations() async {


    final db = await database;


    await db.delete(

      "locations",

    );


  }



}