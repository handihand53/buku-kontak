import 'package:address_book/models/ContactList.dart';
import 'package:address_book/services/DbLite.dart';
import 'package:sqflite/sqflite.dart';

class ContactListCon extends DbLite{
  ContactList contactList;
  ContactListCon() : super.second();

  Future<List> getAllContact() async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CONTACT_LIST_TABLE} '
        'INNER JOIN ${DbLite.CATEGORY_LIST} '
        'ON ${DbLite.CONTACT_LIST_TABLE}.cat_id '
        '= ${DbLite.CATEGORY_LIST}.id'
        ' ORDER BY ${DbLite.CONTACT_NAME} ASC';
    final data = await db.rawQuery(sql);
    return data.toList();
  }

  Future<List>getAllContactByLimit(int offset, int limit) async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CONTACT_LIST_TABLE} '
        'INNER JOIN ${DbLite.CATEGORY_LIST} '
        'ON ${DbLite.CONTACT_LIST_TABLE}.cat_id '
        '= ${DbLite.CATEGORY_LIST}.id'
        ' ORDER BY ${DbLite.CONTACT_NAME} ASC'
        ' LIMIT ?, ?';
    List<dynamic> params = [offset, limit];
    final data = await db.rawQuery(sql, params);
    return data.toList();
  }

  Future<List> getAllContactByName(String s) async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CONTACT_LIST_TABLE} '
        'INNER JOIN ${DbLite.CATEGORY_LIST} '
        'ON ${DbLite.CONTACT_LIST_TABLE}.cat_id '
        '= ${DbLite.CATEGORY_LIST}.id'
        ' WHERE ${DbLite.CONTACT_LIST_TABLE}.${DbLite.CONTACT_NAME} LIKE "${s}%"'
        ' ORDER BY ${DbLite.CONTACT_NAME} ASC';
    List<dynamic> params = [s];
    final data = await db.rawQuery(sql);
    return data.toList();
  }

  Future<List> getAllContactByCategoryId(int id) async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CONTACT_LIST_TABLE} '
        'INNER JOIN ${DbLite.CATEGORY_LIST} '
        'ON ${DbLite.CONTACT_LIST_TABLE}.cat_id '
        '= ${DbLite.CATEGORY_LIST}.id'
        ' WHERE ${DbLite.CONTACT_LIST_TABLE}.${DbLite.CAT_ID} = ?'
        ' GROUP BY ${DbLite.CONTACT_ID}'
        ' ORDER BY ${DbLite.CONTACT_NAME} ASC';
    List<dynamic> params = [id];
    final data = await db.rawQuery(sql, params);
    return data.toList();
  }

  Future<List> getAllContactByNameAndCategory(String s, int catId) async {
    Database db = await this.initDb();
    final sql = 'SELECT * FROM ${DbLite.CONTACT_LIST_TABLE} '
        'INNER JOIN ${DbLite.CATEGORY_LIST} '
        'ON ${DbLite.CONTACT_LIST_TABLE}.cat_id '
        '= ${DbLite.CATEGORY_LIST}.id'
        ' WHERE ${DbLite.CONTACT_LIST_TABLE}.${DbLite.CONTACT_NAME} LIKE "${s}%"'
        ' AND ${DbLite.CONTACT_LIST_TABLE}.${DbLite.CAT_ID} = ?'
        ' ORDER BY ${DbLite.CONTACT_NAME} ASC';
    List<dynamic> params = [catId];
    final data = await db.rawQuery(sql, params);
    return data.toList();
  }

  Future<int> addContact (ContactList contactList) async {
    Database db = await this.initDb();
    final sql = 'INSERT INTO ${DbLite.CONTACT_LIST_TABLE} (${DbLite.CONTACT_NAME}, ${DbLite.PHONE_NUMBER}, ${DbLite.CAT_ID}, ${DbLite.IMG_URL}) VALUES (?,?,?,?)';
    List<dynamic> params = [contactList.name, contactList.phoneNumber, contactList.catId, contactList.imgUrl];
    final result = await db.rawInsert(sql, params);
    await db.close();
    return result;
  }

  Future<List> deleteContact(int id) async {
    Database db = await this.initDb();
    final sql =
        'DELETE FROM ${DbLite.CONTACT_LIST_TABLE} where ${DbLite.CONTACT_ID} = "${id}"';
    print(sql);
    final result = await db.rawQuery(sql);
    await db.close();
    return result;
  }

}