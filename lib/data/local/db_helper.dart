import 'dart:io';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';

class DBHelper {
  DBHelper._();

  static final DBHelper getInstance = DBHelper._();
  // // or
  // static DBHelper getInstance() {
  //   return DBHelper._();
  // }
  Database? myDB;
  static final TABLE_NAME = 'pending_uploads';
  static final SNO = 's_no';
  static final IMAGE_FILE = 'image_file';

  Future<Database> getDB() async {
    if(myDB != null){
      return myDB!;
    }else{
      myDB = await openDB();
      return myDB!;
    }
    // // or
    // myDB ??= await openDB();
    // return myDB!;
  }
  Future<Database> openDB() async {
    Directory appDir = await getApplicationDocumentsDirectory();
    final String dbPath = join(appDir.path, 'myDatabase.db');
    return await openDatabase(
      dbPath,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''CREATE TABLE ${TABLE_NAME}(
          ${SNO} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${IMAGE_FILE} TEXT NOT NULL,
          progress REAL DEFAULT 0.0,
          status TEXT DEFAULT 'initial',
          timestamp INTEGER DEFAULT (strftime('%s', 'now'))
        )''');
      },
    );
  }

  // All queries

  // Insert Image
  Future<int> insertPendingUpload(String imagePath) async{
   var db = await getDB();
   return await db.insert(
       TABLE_NAME,
   {
     '${IMAGE_FILE}': imagePath,
     'status': 'initial'
      }
    );
  }

  // Update Status
  Future<void> updateUploadProgress(int s_no, double progress) async{
    var db =  await getDB();
    await db.update(
        TABLE_NAME,
        {
          'progress': progress
      },
      where: '${SNO} = ?',
      whereArgs: [s_no],
    );
  }

  // Delete Uploaded Image
  Future<void> deleteCompletedUpload(int s_no) async{
   var db = await getDB();
   await db.delete(
     TABLE_NAME,
     where: '${SNO} = ?',
     whereArgs: [s_no],
   );
  }

  // Get Pending Image
  Future<List<Map<String, dynamic>>> getPendingUploads() async{
    var db = await getDB();
    return await db.query(
      TABLE_NAME,
      orderBy: 'timestamp ASC',
    );
  }

}
