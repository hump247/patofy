

// import 'package:patofy/helpers/patofy_db.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:path/path.dart';

// class DatabaseService{
//   Database? _database;

//   Future <Database> get database async {
//     if (_database != null) {

//       print("Database not initilized");
//       return _database!;
      
//     } else {
//       _database = await _initialize();

//       print("Database initlialized");
//       return _database!;
//     }
//   }

//   Future<String> get fullPath async{

//     const name = "patofy.db";

//     final path = await getDatabasesPath();

//     return join(path,name);

//   }

//   Future<Database>  _initialize() async{

//     final path = await fullPath;

//     var database = await openDatabase(
//       path,
//       version: 1,
//       onCreate: create,
//       singleInstance: true
//     );

//     return database;

//   }

//   Future <void> create(Database database, int version) async =>
//   await PatofyDB().createTable(database);
// }