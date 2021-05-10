import 'package:address_book/models/CategoryList.dart';
import 'package:address_book/services/DbLite.dart';
import 'package:sqflite/sqflite.dart';

class CategoryListCon extends DbLite{
  CategoryList categoryList;
  CategoryListCon() : super.second();

  Future<List> getAllCategory() async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CATEGORY_LIST} ORDER BY ${DbLite.CATEGORY_NAME} ASC';
    final data = await db.rawQuery(sql);
    return data.toList();
  }

  Future<List> getAllCategoryById(int id) async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CATEGORY_LIST} WHERE ${DbLite.CATEGORY_ID} = ?';
    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);
    return data.toList();
  }

  Future<int> addCat(CategoryList categoryList) async {
    Database db = await this.initDb();
    final sql = 'INSERT INTO ${DbLite.CATEGORY_LIST} (${DbLite.CATEGORY_NAME}, ${DbLite.CATEGORY_COLOR}) VALUES (?,?)';
    List<dynamic> params = [categoryList.name, categoryList.color];
    final result = await db.rawInsert(sql, params);
    await db.close();
    return result;
  }
}