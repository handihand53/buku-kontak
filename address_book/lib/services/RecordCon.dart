import 'package:address_book/models/TimerModel.dart';
import 'package:address_book/services/DbLite.dart';
import 'package:sqflite/sqflite.dart';
import 'package:address_book/GLOBAL.dart' as globals;

class RecordCon extends DbLite {
  TimerModel timerModel;

  RecordCon() : super.second();

  Future<List> getRecord() async {
    Database db = await this.initDb();
    final sql =
        'SELECT * FROM ${DbLite.TIMER_LIST} ORDER BY ${DbLite.TIMER_ID} ASC';
    final data = await db.rawQuery(sql);
    return data.toList();
  }

  Future<int> addRecord(TimerModel timerModel) async {
    Database db = await this.initDb();
    final sql =
        'INSERT INTO ${DbLite.TIMER_LIST} (${DbLite.TIMER_COUNT_CLICK}, ${DbLite.TIMER_ACTION_NAME}, ${DbLite.TIMER_TAG}, ${DbLite.TIMER_TASK_NAME}, ${DbLite.TIMER_TIME}) VALUES (?,?,?,?,?)';
    List<dynamic> params = [
      timerModel.countClick,
      timerModel.actionName,
      globals.name,
      timerModel.taskName,
      timerModel.time
    ];
    final result = await db.rawInsert(sql, params);
    await db.close();
    return result;
  }

  Future<List> resetRecord() async {
    Database db = await this.initDb();
    final sql =
        'DELETE FROM ${DbLite.TIMER_LIST}';
    final result = await db.rawQuery(sql);
    await db.close();
    return result;
  }
}
