import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class MovieManiaDatabase {
  MovieManiaDatabase.init();
  static MovieManiaDatabase instance = MovieManiaDatabase.init();

  final int dbVersion = 1;
  final String databaseName = "MMDB.db";

  final String tableName = "USERS2";
  final String COLUMN_NAME = "USER_NAME";
  final String COLUMN_EMAIL = "USER_EMAIL";
  final String COLUMN_PASSWORD = "USER_PASSWORD";

  Database? _database;

//"/android/data/com.app.mskoll/databaseName.db"
  Future<Database> initDatabase() async {
    _database ??= await openDatabase(
      join(await getDatabasesPath(), databaseName),
      version: dbVersion,
      onCreate: (db, ver) {
        db.execute(
            "CREATE TABLE IF NOT EXSISTS $tableName($COLUMN_NAME text NOT NULL, $COLUMN_EMAIL varchar(45) , $COLUMN_PASSWORD text)");
      },
    );

    return _database!;
  }

  Future<bool> insertUser(String name, String email, String password) async {
    //bool isSuccess = false;

    final Database instance = await initDatabase();
    // await instance
    //     .execute(
    //         "Insert into $tableName($COLUMN_EMAIL,$COLUMN_EMAIL,$COLUMN_PASSWORD)VALUES($name,$email,$password)")
    //     .then((value) {
    //   isSuccess = true;
    // }, onError: (e) {
    //   isSuccess = false;
    // });

    int response = await instance.insert(
      tableName,
      {
        COLUMN_NAME: name,
        COLUMN_EMAIL: email,
        COLUMN_PASSWORD: password,
      },
    );

    return Future.value(response == 0 ? false : true);
  }

  Future<Map<String, Object?>> getUser(String email) async {
    final Database instance = await initDatabase();
    List<Map<String, Object?>> fetched = await instance
        .query(tableName, where: "$COLUMN_EMAIL = ?", whereArgs: [email]);

    if (fetched.isEmpty) {
      return Future.error(
          "You don't have an account with us. Create a new one now");
    }

    return Future.value(fetched.first);
  }
}
