import 'dart:io';

import 'package:address_book/AddCategories.dart';
import 'package:address_book/SortByCategory.dart';
import 'models/TimerModel.dart';
import 'package:address_book/services/CategoryListCon.dart';
import 'package:address_book/services/ContactListCon.dart';
import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:url_launcher/url_launcher.dart';
import 'AddContact.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

final StopWatchTimer _stopWatchTimer = StopWatchTimer();
int _clickIdx = 0;
final String TASK_NAME = 'Desain 1';

RecordCon recordCon = new RecordCon();
ContactListCon contactListCon = new ContactListCon();

class Desain1 extends StatefulWidget {
  @override
  _Desain1State createState() => _Desain1State();
}

class _Desain1State extends State<Desain1> with SingleTickerProviderStateMixin {
  TabController _tabController;
  TextEditingController search = new TextEditingController();
  CategoryListCon categoryListCon = new CategoryListCon();

  List<Widget> categoryListWidget = new List();
  List<Widget> categoryListWidget2 = new List();
  List<Widget> contactListWidget = new List();

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
    _clickIdx = 0;
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    getCategoryList();
    getContactList().then(
      (result) {
        setState(
          () {},
        );
      },
    );
    _tabController = TabController(length: 2, vsync: this, initialIndex: 0);
    _tabController.addListener(_handleTabIndex);
    super.initState();
  }

  @override
  void dispose() async {
    _tabController.removeListener(_handleTabIndex);
    _tabController.dispose();
    super.dispose();
  }

  Future getCategoryList() async {
    String alpha = '';
    //contactList.sort((a, b) {
    //       return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
    //     });
    //     await contactList.forEach(
    //       (data) async {
    //         if (alpha == '') {
    //           alpha = data['name'].toLowerCase().toString().substring(0, 1);
    //           contactListWidget.add(
    //             DividerWithText(
    //               alphabetic: alpha.toUpperCase(),
    //             ),
    //           );
    //         }
    //
    //         if (alpha != data['name'].toLowerCase().toString().substring(0, 1)) {
    //           alpha = data['name'].toLowerCase().toString().substring(0, 1);
    //           contactListWidget.add(
    //             DividerWithText(
    //               alphabetic: alpha.toUpperCase(),
    //             ),
    //           );
    //         }
    //
    //         contactListWidget.add(
    //           ListContact(
    //             name: data['name'],
    //             tag: data['cat_name'],
    //             tagColor: Color(data['color']),
    //             noTlp: data['phone_number'],
    //             imgUrl: data['img_url'],
    //             id: data['id_con'],
    //           ),
    //         );
    //       },
    //     );
    //     setState(() {
    //       this.categoryListWidget2 = categoryListWidget;
    //     });
    categoryListWidget = [];
    categoryList = await categoryListCon.getAllCategory();
    categoryList.sort((a, b) {
      return a['cat_name'].toLowerCase().compareTo(b['cat_name'].toLowerCase());
    });
    //mulai dari sini
    await categoryList.forEach(
      (data) async {
        if (alpha == '') {
          alpha = data['cat_name'].toLowerCase().toString().substring(0, 1);
          categoryListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        if (alpha != data['cat_name'].toLowerCase().toString().substring(0, 1)) {
          alpha = data['cat_name'].toLowerCase().toString().substring(0, 1);
          categoryListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        categoryListWidget.add(
          ListCategory(
            text: data['cat_name'],
            bgColor: Color(
              data['color'],
            ),
            idCat: data['id'],
          ),
        );
      },
    );
  }

  Future searchContactList(String s) async {
    contactList = await contactListCon.getAllContactByName(s);
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
            id: data['id_con'],
          ),
        );
      },
    );
    setState(() {});
  }

  Future getContactList() async {
    contactList = await contactListCon.getAllContact();
    String alpha = '';
    contactList.sort((a, b) {
      return a['name'].toLowerCase().compareTo(b['name'].toLowerCase());
    });
    await contactList.forEach(
      (data) async {
        if (alpha == '') {
          alpha = data['name'].toLowerCase().toString().substring(0, 1);
          contactListWidget.add(
            DividerWithText(
              alphabetic: alpha.toUpperCase(),
            ),
          );
        }

        if (alpha != data['name'].toLowerCase().toString().substring(0, 1)) {
          alpha = data['name'].toLowerCase().toString().substring(0, 1);
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
            id: data['id_con'],
          ),
        );
      },
    );
    setState(() {
      this.categoryListWidget2 = categoryListWidget;
    });
  }

  @override
  Widget build(BuildContext context) {
    setState(() {});
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: MaterialApp(
        home: DefaultTabController(
          length: 2,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              backgroundColor: Colors.blue,
              elevation: 0,
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
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      TextField(
                        controller: search,
                        onTap: () async {
                          String currentTime;
                          await _stopWatchTimer.onExecute
                              .add(StopWatchExecute.lap);
                          await _stopWatchTimer.records.listen((value) async {
                            currentTime = value[_clickIdx].displayTime;
                          });

                          recordCon.addRecord(new TimerModel(
                            taskName: TASK_NAME,
                            countClick: 'Klik ke ' + (_clickIdx + 1).toString(),
                            actionName: 'Menekan tombol cari kontak',
                            time: currentTime,
                          ));
                          _clickIdx++;
                        },
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
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: ListView(
                    children: <Widget>[
                      SizedBox(
                        height: 10,
                      ),
                      Column(
                        children: categoryListWidget2,
                      ),
                    ],
                  ),
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
        ? FloatingActionButton(
            onPressed: () async {
              String currentTime;
              await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
              await _stopWatchTimer.records.listen((value) async {
                currentTime = value[_clickIdx].displayTime;
              });
              recordCon.addRecord(new TimerModel(
                taskName: TASK_NAME,
                countClick: 'Klik ke ' + (_clickIdx + 1).toString(),
                actionName: 'Menekan tombol floating button tambah kontak',
                time: currentTime,
              ));
              _clickIdx++;
              Navigator.of(context).push(_createRouteAddContact()).then(
                (val) {
                  setState(() {
                    _clickIdx = val;
                    contactListWidget = [];
                    getContactList();
                  });
                },
              );
            },
            child: Icon(Icons.add),
            tooltip: "Tambah",
            backgroundColor: Color.fromRGBO(36, 179, 0, 1),
          )
        : FloatingActionButton(
            onPressed: () async {
              String currentTime;
              await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
              await _stopWatchTimer.records.listen((value) async {
                currentTime = value[_clickIdx].displayTime;
              });
              recordCon.addRecord(new TimerModel(
                taskName: TASK_NAME,
                countClick: 'Klik ke ' + (_clickIdx + 1).toString(),
                actionName: 'Menekan tombol floating button tambah kategori',
                time: currentTime,
              ));
              _clickIdx++;

              Navigator.of(context).push(_createRouteAddCategory()).then(
                (val) {
                  _clickIdx = val;
                  setState(() {
                    categoryListWidget = [];
                    getCategoryList();
                  });
                },
              );
            },
            child: Icon(Icons.add),
            tooltip: "Tambah",
            backgroundColor: Color.fromRGBO(36, 179, 0, 1),
          );
  }

  Widget lineBreaker() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            margin: EdgeInsets.only(left: 10.0, right: 10.0),
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

Route _createRouteAddContact() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) =>
        AddContact(_clickIdx, _stopWatchTimer),
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
        AddCategories(_clickIdx, _stopWatchTimer),
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
  int id;
  String tag;
  Color tagColor;
  String noTlp;
  String imgUrl;

  ListContact({this.name, this.tag, this.tagColor, this.noTlp, this.imgUrl, this.id});

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
          onTap: () async {
            String currentTime;
            await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
            await _stopWatchTimer.records.listen((value) async {
              currentTime = value[_clickIdx].displayTime;
            });
            recordCon.addRecord(new TimerModel(
              taskName: TASK_NAME,
              countClick: 'Klik ke ' + (_clickIdx + 1).toString(),
              actionName: 'Menekan tombol $name',
              time: currentTime,
            ));
            _clickIdx++;
            await infoDialog(context, name, noTlp, imgUrl, tag, tagColor, id);
          },
        ),
      ),
    );
  }
}

class ListCategory extends StatelessWidget {
  String text;
  int idCat;
  Color bgColor;

  ListCategory({this.text, this.bgColor, this.idCat});

  Route _createRoute() {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) =>
          SortByCategory(idCat, _clickIdx, _stopWatchTimer),
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
    return Container(
      child: Card(
        elevation: 0,
        color: Colors.black.withOpacity(0.1),
        child: ListTile(
          contentPadding: EdgeInsets.only(left: 10, top: 5, bottom: 5),
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                text,
                style: TextStyle(
                  fontSize: 30,
                  color: Colors.black87.withOpacity(0.6),
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height: 3.0,
              ),
            ],
          ),
          onTap: () async {
            String currentTime;
            await _stopWatchTimer.onExecute.add(StopWatchExecute.lap);
            await _stopWatchTimer.records.listen((value) async {
              currentTime = value[_clickIdx].displayTime;
            });
            recordCon.addRecord(new TimerModel(
              taskName: TASK_NAME,
              countClick: 'Klik ke ' + (_clickIdx + 1).toString(),
              actionName: 'Menekan tombol category $text',
              time: currentTime,
            ));
            _clickIdx++;

            Navigator.of(context).push(_createRoute()).then((val) {
              idx = val;
            });
          },
        ),
      ),
    );
  }
}

Future<bool> infoDialog(context, String name, String noTlp, String imgUrl,
    String cat, Color color, int id) {
  return showDialog(
    context: context,
    barrierDismissible: true,
    builder: (BuildContext context) {
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Container(
          height: 605.0,
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
                      ),
                      Container(
                        margin: EdgeInsets.only(top: 0),
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
                                  width: 10.0,
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
                                      String currentTime;
                                      await _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.lap);
                                      await _stopWatchTimer.records
                                          .listen((value) async {
                                        currentTime =
                                            value[_clickIdx].displayTime;
                                      });
                                      recordCon.addRecord(new TimerModel(
                                        taskName: TASK_NAME,
                                        countClick: 'Klik ke ' +
                                            (_clickIdx + 1).toString(),
                                        actionName:
                                            'Menekan tombol sms ke $noTlp',
                                        time: currentTime,
                                      ));
                                      _clickIdx++;
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
                                      String currentTime;
                                      await _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.lap);
                                      await _stopWatchTimer.records
                                          .listen((value) async {
                                        currentTime =
                                            value[_clickIdx].displayTime;
                                      });
                                      recordCon.addRecord(new TimerModel(
                                        taskName: TASK_NAME,
                                        countClick: 'Klik ke ' +
                                            (_clickIdx + 1).toString(),
                                        actionName:
                                            'Menekan tombol telepon ke $noTlp',
                                        time: currentTime,
                                      ));
                                      _clickIdx++;

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
                                      String currentTime;
                                      await _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.lap);
                                      await _stopWatchTimer.records
                                          .listen((value) async {
                                        currentTime =
                                            value[_clickIdx].displayTime;
                                      });
                                      recordCon.addRecord(new TimerModel(
                                        taskName: TASK_NAME,
                                        countClick: 'Klik ke ' +
                                            (_clickIdx + 1).toString(),
                                        actionName: 'Menekan tombol edit',
                                        time: currentTime,
                                      ));
                                      _clickIdx++;
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
                                      String currentTime;
                                      await _stopWatchTimer.onExecute
                                          .add(StopWatchExecute.lap);
                                      await _stopWatchTimer.records
                                          .listen((value) async {
                                        currentTime =
                                            value[_clickIdx].displayTime;
                                      });
                                      await contactListCon.deleteContact(id);
                                      await recordCon.addRecord(new TimerModel(
                                        taskName: TASK_NAME,
                                        countClick: 'Klik ke ' +
                                            (_clickIdx + 1).toString(),
                                        actionName:
                                            'Menekan tombol hapus kontak ${name}',
                                        time: currentTime,
                                      ));
                                      _clickIdx++;
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
