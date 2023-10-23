// import 'package:sqflite/sqflite.dart';

// class PatofyDB {
//   final tableName = "patofy";

//   Future <void> createTable (Database database) async {
//     await database.execute(""" CREATE TABLE IF NOT EXIST $tableName (
//       "id" INTEGER NOT NULL,
//       "title" TEXT NOT NULL,
//       "create_at" INTEGER NOT NULL DEFAULT (cast(strftime('%s','now') as int)),

//     )""");
//   }
// }