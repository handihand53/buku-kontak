import 'dart:io';

import 'package:address_book/services/CategoryListCon.dart';
import 'package:address_book/services/ContactListCon.dart';
import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/material.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddCategories.dart';
import 'AddContact.dart';
import 'SortByCategory.dart';
import 'models/TimerModel.dart';

final StopWatchTimer _stopWatchTimer = StopWatchTimer();
int idx = 0;
int page = 0;
int pageIdx = 0;
final String TASK_NAME = 'Desain 5';
RecordCon recordCon = new RecordCon();
List limitLength = new List();
ContactListCon contactListCon = new ContactListCon();

class Desain2 extends StatefulWidget {
  @override
  _Desain2State createState() => _Desain2State();
}

class _Desain2State extends State<Desain2> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController search = new TextEditingController();
  CategoryListCon categoryListCon = new CategoryListCon();

  List<Widget> categoryListWidget = new List();
  List<Widget> categoryListWidget2 = new List();
  List<Widget> contactListWidget = new List();
  List<Widget> contactListWidget2 = new List();

  List categoryList = new List();
  List contactList = new List();

  void _handleTabIndex() {
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    return showDialog(
          context: context,
          builder: (context) => new AlertDialog(
            title: new Text('Are you sure?'),
            content: new Text('Do you want to exit an App'),
            actions: <Widget>[
              new GestureDetector(
                onTap: () => Navigator.of(context).pop(false),
                child: Text("NO"),
              ),
              SizedBox(height: 16),
              new GestureDetector(
                onTap: () async {
                  _stopWatchTimer.onExecute.add(StopWatchExecute.stop);
                  _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
                  Navigator.of(context).pop(true);
                },
                child: Text("YES"),
              ),
            ],
          ),
        ) ??
        false;
  }

  @override
  void initState() {
    idx = 0;
    page = 0;
    pageIdx = 0;
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    getContactList().then((val) {
      setState(() {});
    });
    getCategoryList();
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
  }

  @override
  void dispose() {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  Future getCategoryList() async {
    categoryListWidget = [];
    categoryList = await categoryListCon.getAllCategory();
    categoryList.forEach(
      (data) {
        categoryListWidget.add(
          ListGridItem(
            text: data['cat_name'],
            bgColor: Color(
              data['color'],
            ),
            idCat: data['id'],
          ),
        );
      },
    );
    setState(() {
      categoryListWidget2 = categoryListWidget;
    });
  }

  Future searchContactList(String s) async {
    contactList = await contactListCon.getAllContactByName(s);
    String alpha = '';
    await contactList.forEach(
      (data) async {
        contactListWidget.add(
          ListContact(
            name: data['name'],
            tag: data['cat_name'],
            tagColor: Color(data['color']),
            noTlp: data['phone_number'],
            imgUrl: data['img_url'],
            id: data['id_con']
          ),
        );
      },
    );
    setState(() {
      contactListWidget2 = contactListWidget;
    });
  }

  Widget getLst() {
    Widget list;
    return list = Column(
      children: contactListWidget,
    );
  }

  Future<void> getContactList() async {
    limitLength = await contactListCon.getAllContact();
    contactList = await contactListCon.getAllContactByLimit(pageIdx, 6);
    contactList.sort((a, b) {
      return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
    });
    await contactList.forEach(
      (data) async {
        contactListWidget.add(
          ListContact(
            name: data['name'],
            tag: data['cat_name'],
            tagColor: Color(data['color']),
            noTlp: data['phone_number'],
            imgUrl: data['img_url'],
            id: data['id_con'],
          ),
        );
      },
    );
    setState(() {
      contactListWidget2 = contactListWidget;
    });
  }

  void add(String msg) async {
    String currentTime;
    await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    await _stopWatchTimer.records.listen((value) async {
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
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Color.fromRGBO(244, 244, 244, 1),
            appBar: AppBar(
              backgroundColor: Colors.blue,
              flexibleSpace: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TabBar(
                    indicatorSize: TabBarIndicatorSize.label,
                    indicator: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(10),
                            topRight: Radius.circular(10)),
                        color: Colors.white),
                    controller: _tabController,
                    onTap: (x) {
                      setState(() {
                        print(x);
                        _tabController.animateTo(x);
                      });
                    },
                    indicatorPadding: EdgeInsets.all(0),
                    labelPadding: EdgeInsets.all(0),
                    indicatorColor: Colors.white,
                    indicatorWeight: 5.0,
                    labelColor: Colors.blue,
                    unselectedLabelColor: Colors.white.withOpacity(0.5),
                    tabs: [
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'SEMUA KONTAK',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Tab(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'KATEGORI',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            body: TabBarView(
              controller: _tabController,
              children: [
                Column(
                  children: <Widget>[
                    Expanded(
                      child: GridView.count(
                        crossAxisCount: 2,
                        children: contactListWidget2,
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        RaisedButton(
                          child: Text(
                            'Sebelumnya'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          color: Colors.blue,
                          onPressed: () async {
                            await add('User menekan tombol sebelumnya');
                            if (page - 1 >= 0) {
                              pageIdx -= 6;
                              contactListWidget = [];
                              page--;
                            }
                            getContactList().then((val) {
                              setState(() {});
                            });
                          },
                        ),
                        RaisedButton(
                          color: Colors.green,
                          child: Text(
                            'Tambah Kontak'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          onPressed: () async {
                            await add('User menekan tombol tambah kontak');
                            Navigator.of(context)
                                .push(_createRouteAddContact())
                                .then(
                              (val) {
                                idx = val;
                                setState(() async {
                                  await add(
                                      'User menekan floating button tambah kontak');
                                  contactListWidget = [];
                                  getContactList();
                                });
                              },
                            );
                          },
                        ),
                        RaisedButton(
                          color: Colors.blue,
                          child: Text(
                            'Selanjutnya'.toUpperCase(),
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18.0,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                          onPressed: () async {
                            await add('User menekan tombol selanjutnya');
                            int lmt = ((limitLength.length + 6) / 6).floor();
                            if (page + 1 < lmt) {
                              contactListWidget = [];
                              pageIdx += 6;
                              page++;
                            }
                            getContactList().then((val) {
                              setState(() {});
                            });
                          },
                        )
                      ],
                    )
                  ],
                ),
                GridView.count(
                  crossAxisCount: 2,
                  children: categoryListWidget2,
                ),
              ],
            ),
            floatingActionButton: Container(
              height: 80.0,
              width: 80.0,
              child: FittedBox(
                child: _bottomButtons(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _bottomButtons() {
    return _tabController.index == 0
        ? Container()
        : FloatingActionButton(
            onPressed: () {
              Navigator.of(context).push(_createRouteAddCategory()).then(
                (val) {
                  idx = val;
                  setState(() async {
                    await add('User menekan floating button tambah kategori');
                    categoryListWidget = [];
                    getCategoryList();
                  });
                },
              );
            },
            child: Icon(Icons.add),
            tooltip: "Tambah",
            backgroundColor: Color.fromRGBO(232, 108, 0, 1),
          );
  }
}

Route _createRouteAddContact() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddContact(idx, _stopWatchTimer),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}

Route _createRouteAddCategory() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddCategories(idx, _stopWatchTimer),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      var begin = Offset(0.0, 1.0);
      var end = Offset.zero;
      var curve = Curves.ease;
      var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
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
  int id;

  ListContact({this.name, this.tag, this.tagColor, this.noTlp, this.imgUrl, this.id});

  void add(String msg) async {
    String currentTime;
    await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    await _stopWatchTimer.records.listen((value) async {
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
    return GestureDetector(
      onTap: () async {
        await add('User menekan tombol $name');
        infoDialog(context, name, noTlp, imgUrl, tag, tagColor, id);
      },
      child: Padding(
        padding: EdgeInsets.all(2.0),
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: imgUrl != ''
                    ? FileImage(File(imgUrl))
                    : ExactAssetImage('assets/images/dummy.jpg'),
                fit: BoxFit.cover),
          ),
          height: 150,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Container(
                      color: Colors.black87,
                      child: Text(
                        name,
                        style: TextStyle(
                          fontSize: 35,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

class ListGridItem extends StatelessWidget {
  String text;
  int idCat;
  Color bgColor;

  ListGridItem({this.text, this.bgColor, this.idCat});

  void add(String msg) async {
    String currentTime;
    await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    await _stopWatchTimer.records.listen((value) async {
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

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SortByCategory(idCat, idx, _stopWatchTimer),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        var begin = Offset(0.0, 1.0);
        var end = Offset.zero;
        var curve = Curves.ease;
        var tween =
            Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await add('User menekan kategori $text');
        Navigator.of(context).push(_createRoute()).then((val) {
          idx = val;
        });
      },
      child: Padding(
        padding: EdgeInsets.all(1.0),
        child: Container(
          color: bgColor,
          height: 200,
          child: Center(
            child: Text(
              text,
              style: TextStyle(
                fontSize: 35,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

Future<bool> infoDialog(context, String name, String noTlp, String imgUrl,
    String cat, Color color, int id) {
  void add(String msg) async {
    String currentTime;
    await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
    await _stopWatchTimer.records.listen((value) async {
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
          height: 655.0,
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
                                  size: 20.0,
                                  color: Colors.black,
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  noTlp,
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.w600,
                                  ),
                                )
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
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
                                      await add('User menekan tombol sms');
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
                                      await add('User menekan tombol telepon');
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
                            SizedBox(
                              height: 20.0,
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
                                      await add('User menekan tombol edit');
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
                                          Icons.edit,
                                          color: Colors.blue,
                                          size: 50.0,
                                        ),
                                        Text(
                                          "EDIT",
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
                                      await contactListCon.deleteContact(id);
                                      await add('Menekan tombol hapus kontak ${name}');
                                      Navigator.of(context).pop();
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
                                          Icons.delete,
                                          color: Colors.blue,
                                          size: 50.0,
                                        ),
                                        Text(
                                          "HAPUS",
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
                            SizedBox(
                              height: 10.0,
                            ),
                            RaisedButton(
                              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(18.0),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              color: Colors.blue,
                              textColor: Colors.white,
                              child: Text(
                                "Kembali".toUpperCase(),
                                style: TextStyle(fontSize: 30),
                              ),
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
