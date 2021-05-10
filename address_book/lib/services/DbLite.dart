import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';

class DbLite {
  static DbLite _dbHelper;
  static Database _database;

  static const CONTACT_LIST_TABLE = 'contact_list';
  static const CONTACT_ID = 'id_con';
  static const CONTACT_NAME = 'name';
  static const PHONE_NUMBER = 'phone_number';
  static const CAT_ID = 'cat_id';
  static const IMG_URL = 'img_url';

  static const CATEGORY_LIST = 'category_list';
  static const CATEGORY_ID = 'id';
  static const CATEGORY_NAME = 'cat_name';
  static const CATEGORY_COLOR = 'color';

  static const TIMER_LIST = 'timer_list';
  static const TIMER_ID = 'timer_id';
  static const TIMER_COUNT_CLICK = 'count_click';
  static const TIMER_TASK_NAME = 'task_name';
  static const TIMER_ACTION_NAME = 'action_name';
  static const TIMER_TAG = 'tag';
  static const TIMER_TIME = 'time';

  static const RESPONDEN_LIST = 'responden_list';
  static const RESPONDEN_ID = 'responden_id';
  static const RESPONDEN_NAME = 'responden_name';
  static const TIMER_ID_FK = 'timer_id_fk';

  DbLite._createObject();
  DbLite.second();

  factory DbLite() {
    if (_dbHelper == null) {
      _dbHelper = DbLite._createObject();
    }
    return _dbHelper;
  }

  Future<Database> initDb() async {
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'addressBook.db';
    var todoDatabase = openDatabase(path, version: 1, onCreate: _createDb);
    return todoDatabase;
  }

  void _createDb(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute('CREATE TABLE ${CONTACT_LIST_TABLE}( '
        '${CONTACT_ID} INTEGER PRIMARY KEY AUTOINCREMENT,'
        '${CONTACT_NAME} TEXT,'
        '${PHONE_NUMBER} TEXT,'
        '${CAT_ID} INTEGER,'
        '${IMG_URL} TEXT'
        ');');
    batch.execute(
        'CREATE TABLE ${CATEGORY_LIST} ('
            '${CATEGORY_ID} INTEGER PRIMARY KEY AUTOINCREMENT,'
            '${CATEGORY_NAME} TEXT,'
            '${CATEGORY_COLOR} INTEGER'
            ');');
    batch.execute(
        'CREATE TABLE ${TIMER_LIST} ('
            '${TIMER_ID} INTEGER PRIMARY KEY AUTOINCREMENT,'
            '${TIMER_TASK_NAME} TEXT,'
            '${TIMER_COUNT_CLICK} TEXT,'
            '${TIMER_ACTION_NAME} TEXT,'
            '${TIMER_TAG} TEXT,'
            '${TIMER_TIME} TEXT'
            ');');

    batch.execute(
        'INSERT INTO ${CATEGORY_LIST} VALUES(1,"Keluarga", 0xfff44336);'
    );
    batch.execute(
        'INSERT INTO ${CATEGORY_LIST} VALUES(2,"Sahabat", 0xff03a9f4);'
    );
    batch.execute(
        'INSERT INTO ${CATEGORY_LIST} VALUES(3,"Arisan", 0xff4caf50);'
    );
    batch.execute(
        'INSERT INTO ${CATEGORY_LIST} VALUES(4,"Alumni", 0xff607d8b);'
    );
    List<dynamic> res = await batch.commit();
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}
