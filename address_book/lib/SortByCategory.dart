import 'dart:io';
import 'package:address_book/services/ContactListCon.dart';
import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:url_launcher/url_launcher.dart';

import 'models/TimerModel.dart';

final String TASK_NAME = 'Sort by categori';
RecordCon recordCon = new RecordCon();
int idx;
StopWatchTimer _stopWatch;

class SortByCategory extends StatefulWidget {
  final int id;
  StopWatchTimer _stopWatch;
  int idx;

  SortByCategory(this.id, this.idx, this._stopWatch);
  @override
  _SortByCategoryState createState() =>
      _SortByCategoryState(this.id, this.idx, this._stopWatch);
}

class _SortByCategoryState extends State<SortByCategory> {
  int id;
  StopWatchTimer _stopWatch2;
  int idx2;
  _SortByCategoryState(this.id, this.idx2, this._stopWatch2);

  TextEditingController search = new TextEditingController();
  ContactListCon contactListCon = new ContactListCon();
  List<Widget> contactListWidget = new List();
  List contactList = new List();

  @override
  void initState() {
    idx = idx2;
    _stopWatch = _stopWatch2;
    super.initState();
    getContactList().then(
      (result) {
        setState(
          () {},
        );
      },
    );
  }

  void add(String msg) async {
    String currentTime;
    await _stopWatch.onExecute.add(StopWatchExecute.lap);
    await _stopWatch.records.listen((value) async {
      currentTime = value[idx].displayTime;
    });
    recordCon.addRecord(new TimerModel(
      taskName: TASK_NAME,
      countClick: 'Klik ke ' + (idx + 1).toString(),
      actionName: msg,
      time: currentTime,
    ));
    idx++;
  }

  Future getContactList() async {
    contactList = await contactListCon.getAllContactByCategoryId(id);
    String alpha = '';
    await contactList.forEach(
      (data) async {
        if (alpha == '') {
          alpha = data['name'].toString().substring(0, 1);
          contactListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        if (alpha != data['name'].toString().substring(0, 1)) {
          alpha = data['name'].toString().substring(0, 1);
          contactListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        contactListWidget.add(
          ListContact(
            name: data['name'],
            tag: data['cat_name'],
            tagColor: Color(data['color']),
            noTlp: data['phone_number'],
            imgUrl: data['img_url'],
          ),
        );
      },
    );

    if (contactList.length == 0) {
      contactListWidget.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 230,
          ),
          Center(
            child: Text(
              'Tidak ada kontak',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ],
      ));
    }

    setState(() {});
  }

  Future searchContactList(String s) async {
    contactList = await contactListCon.getAllContactByNameAndCategory(s, id);
    String alpha = '';
    await contactList.forEach(
      (data) async {
        if (alpha == '') {
          alpha = data['name'].toString().substring(0, 1);
          contactListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        if (alpha != data['name'].toString().substring(0, 1)) {
          alpha = data['name'].toString().substring(0, 1);
          contactListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        contactListWidget.add(
          ListContact(
            name: data['name'],
            tag: data['cat_name'],
            tagColor: Color(data['color']),
            noTlp: data['phone_number'],
            imgUrl: data['img_url'],
          ),
        );
      },
    );

    if (contactList.length == 0) {
      contactListWidget.add(Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          SizedBox(
            height: 230,
          ),
          Center(
            child: Text(
              'Tidak ada kontak',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 40,
              ),
            ),
          ),
        ],
      ));
    }
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    await add('Menekan tombol kembali');
    Navigator.pop(context, idx);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Kategori"),
      ),
      body: WillPopScope(
        onWillPop: _onBackPressed,
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Column(children: <Widget>[
              SizedBox(
                height: 10,
              ),
              TextField(
                onTap: () async {
                  add('Menekan field cari kontak');
                },
                controller: search,
                onChanged: (text) {
                  contactListWidget = [];
                  if (text != '') {
                    searchContactList(text);
                  } else {
                    getContactList();
                  }
                },
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      color: Colors.black87.withOpacity(0.2),
                      width: 1.3,
                    ),
                    borderRadius: BorderRadius.circular(0),
                  ),
                  prefixIcon: Icon(Icons.search),
                  hintText: 'Cari Kontak',
                ),
              ),
              Column(
                children: contactListWidget,
              )
            ]),
          ),
        ),
      ),
    );
  }
}

class DividerWithText extends StatelessWidget {
  String alphabetic;

  DividerWithText({this.alphabetic});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Padding(
          padding: EdgeInsets.only(left: 5.0),
          child: Text(
            alphabetic,
            style: TextStyle(
              fontSize: 35,
              fontWeight: FontWeight.w600,
              color: Colors.black54,
            ),
          ),
        ),
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10.0),
            child: Divider(
              color: Colors.black,
              height: 0,
            ),
          ),
        ),
      ],
    );
  }
}

class ListContact extends StatelessWidget {
  String name;
  String tag;
  Color tagColor;
  String noTlp;
  String imgUrl;

  ListContact({this.name, this.tag, this.tagColor, this.noTlp, this.imgUrl});

  void add(String msg) async {
    String currentTime;
    await _stopWatch.onExecute.add(StopWatchExecute.lap);
    await _stopWatch.records.listen((value) async {
      currentTime = value[idx].displayTime;
    });
    recordCon.addRecord(new TimerModel(
      taskName: TASK_NAME,
      countClick: 'Klik ke ' + (idx + 1).toString(),
      actionName: msg,
      time: currentTime,
    ));
    idx++;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Card(
        elevation: 0,
        color: Colors.white12.withOpacity(0.1),
        child: ListTile(
          contentPadding: EdgeInsets.all(10.0),
          leading: CircleAvatar(
            radius: 29,
            backgroundColor: Colors.blue,
            child: CircleAvatar(
              backgroundImage: imgUrl != ''
                  ? FileImage(File(imgUrl))
                  : ExactAssetImage('assets/images/dummy.jpg'),
              radius: 27,
            ),
          ),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                name,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black87.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
              Container(
                decoration: BoxDecoration(
                  color: tagColor,
                  borderRadius: BorderRadius.all(Radius.circular(20.0)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black54.withOpacity(0.3),
                      blurRadius: 7.0,
                      // has the effect of softening the shadow
                      spreadRadius: 0.2,
                      // has the effect of extending the shadow
                      offset: Offset(
                        0, // horizontal, move right 10
                        2.0, // vertical, move down 10
                      ),
                    )
                  ],
                ),
                child: Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 2.0),
                  child: Text(
                    tag,
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          onTap: () {
            add('Menekan tombol $name');
            infoDialog(context, name, noTlp, imgUrl, tag, tagColor);
          },
        ),
      ),
    );
  }
}

Future<bool> infoDialog(context, String name, String noTlp, String imgUrl,
    String cat, Color color) {
  void add(String msg) async {
    String currentTime;
    await _stopWatch.onExecute.add(StopWatchExecute.lap);
    await _stopWatch.records.listen((value) async {
      currentTime = value[idx].displayTime;
    });
    recordCon.addRecord(new TimerModel(
      taskName: TASK_NAME,
      countClick: 'Klik ke ' + (idx + 1).toString(),
      actionName: msg,
      time: currentTime,
    ));
    idx++;
  }

  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 525.0,
          width: 550.0,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Container(
                    height: 105.0,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10.0),
                        topRight: Radius.circular(10.0),
                      ),
                      color: color,
                    ),
                  ),
                  Column(
                    children: <Widget>[
                      Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 30),
                          height: 180.0,
                          width: 180.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            image: DecorationImage(
                              image: imgUrl != ''
                                  ? FileImage(File(imgUrl))
                                  : ExactAssetImage('assets/images/dummy.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Text(
                          name,
                          style: TextStyle(
                            fontSize: 35,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10),
                        decoration: BoxDecoration(
                          color: color,
                          borderRadius: BorderRadius.all(Radius.circular(20.0)),
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 20.0, vertical: 4.0),
                          child: Text(
                            cat,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                            ),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 10.0),
                        child: Column(
                          children: <Widget>[
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  Icons.phone,
                                  size: 40.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 15.0,
                                ),
                                Text(
                                  noTlp,
                                  style: TextStyle(
                                    fontSize: 30,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 50.0,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: <Widget>[
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54.withOpacity(0.3),
                                        blurRadius: 7.0,
                                        // has the effect of softening the shadow
                                        spreadRadius: 0.2,
                                        // has the effect of extending the shadow
                                        offset: Offset(
                                          0, // horizontal, move right 10
                                          2.0, // vertical, move down 10
                                        ),
                                      ),
                                    ],
                                  ),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      await add('Menekan tombol sms');
                                      launch("sms:${noTlp}");
                                    },
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        SizedBox(
                                          width: 90,
                                        ),
                                        Icon(
                                          Icons.message,
                                          color: Colors.blue,
                                          size: 50.0,
                                        ),
                                        Text(
                                          "SMS",
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 30.0,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black54.withOpacity(0.3),
                                        blurRadius: 7.0,
                                        // has the effect of softening the shadow
                                        spreadRadius: 0.2,
                                        // has the effect of extending the shadow
                                        offset: Offset(
                                          0, // horizontal, move right 10
                                          2.0, // vertical, move down 10
                                        ),
                                      )
                                    ],
                                  ),
                                  child: RaisedButton(
                                    onPressed: () async {
                                      await add('Menekan tombol telepon');
                                      launch("tel:${noTlp}");
                                    },
                                    color: Colors.white,
                                    padding: EdgeInsets.all(10.0),
                                    child: Column(
                                      // Replace with a Row for horizontal icon + text
                                      children: <Widget>[
                                        SizedBox(
                                          width: 90,
                                        ),
                                        Icon(
                                          Icons.phone,
                                          color: Colors.blue,
                                          size: 50.0,
                                        ),
                                        Text(
                                          "Telepon",
                                          style: TextStyle(
                                            fontSize: 30,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
