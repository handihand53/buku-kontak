import 'package:address_book/models/CategoryList.dart';
import 'package:address_book/services/CategoryListCon.dart';
import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:flutter_material_color_picker/flutter_material_color_picker.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';

import 'models/TimerModel.dart';

final String TASK_NAME = 'Tambah Kategori';
RecordCon recordCon = new RecordCon();

class AddCategories extends StatelessWidget {
  StopWatchTimer _stopWatch;
  int idx;

  AddCategories(this.idx, this._stopWatch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tambah Kategori"),
      ),
      body: addCategory(idx, _stopWatch),
    );
  }
}

class addCategory extends StatefulWidget {
  StopWatchTimer _stopWatch;
  int idx;

  addCategory(this.idx, this._stopWatch);

  createState() {
    return addCategoryState(this.idx, this._stopWatch);
  }
}

enum ColorValue { c1, c2, c3, c4, c5, c6, c7, custom }

class addCategoryState extends State<addCategory> {
  StopWatchTimer _stopWatch;
  int idx;

  addCategoryState(this.idx, this._stopWatch);

  double fSize = 30;
  FontWeight fWeight = FontWeight.w500;
  int currentIterate = 0;
  CategoryListCon categoryListCon = new CategoryListCon();
  TextEditingController nameCategory = TextEditingController();
  int storeColor = 0;

  @override
  void initState() {
    super.initState();
  }

  // create some values
  Color pickerColor;
  Color currentColor = Colors.transparent;

// ValueChanged<Color> callback
  void changeColor(Color color) {
    setState(() => pickerColor = color);
  }

  Future<void> _showColorPicker() async {
    await showDialog(
      context: context,
      child: AlertDialog(
        title: const Text('PILIH WARNA KATEGORI!'),
        content: SingleChildScrollView(
          child: BlockPicker(
            pickerColor: currentColor,
            onColorChanged: changeColor,
          ),
        ),
        actions: <Widget>[
          RaisedButton(
            padding: EdgeInsets.all(10.0),
            child: Text('Pilih Warna'),
            onPressed: () {
              setState(() => storeColor = pickerColor.value);
              Navigator.of(context).pop();
            },
          ),
        ],
      ),
    );
  }

  Future<bool> _onBackPressed() async {
    await add('Menekan tombol kembali');
    Navigator.pop(context, idx);
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

  Widget iterateWidget() {
    currentIterate %= 7;
    Widget widget;
    if (currentIterate == 0) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4294915328),
      );
      currentIterate++;
    } else if (currentIterate == 1) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4278226943),
      );
      currentIterate++;
    } else if (currentIterate == 2) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4294180608),
      );
      currentIterate++;
    } else if (currentIterate == 3) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4279029763),
      );
      currentIterate++;
    } else if (currentIterate == 4) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4278436560),
      );
      currentIterate++;
    } else if (currentIterate == 5) {
      widget = CircleColor(
        circleSize: 30.0,
        color: Color(4290315216),
      );
      currentIterate++;
    } else if (currentIterate == 6) {
      widget = Text(
        'PILIH WARNA LAINNYA',
        style: TextStyle(
          fontWeight: FontWeight.w900,
        ),
      );
      currentIterate++;
    }

    return widget;
  }

  ColorValue _character;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, top: 20.0),
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  "Kategori",
                  style: TextStyle(
                    fontSize: fSize - 10.0,
                    fontWeight: fWeight,
                  ),
                ),
                nameField(),
                SizedBox(height: 15.0),
                Text(
                  "Warna Latar Kategori",
                  style: TextStyle(
                    fontSize: fSize - 10.0,
                    fontWeight: fWeight,
                  ),
                ),
                RadioListTile<ColorValue>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleColor(
                        circleSize: 30.0,
                        color: Color(4294915328),
                      ),
                    ],
                  ),
                  value: ColorValue.c1,
                  groupValue: _character,
                  onChanged: (ColorValue value) async {
                    await add('User menekan warna 1');
                    setState(() {
                      this.storeColor = 4294915328;
                      _character = value;
                    });
                  },
                ),
                RadioListTile<ColorValue>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleColor(
                        circleSize: 30.0,
                        color: Color(4278226943),
                      ),
                    ],
                  ),
                  value: ColorValue.c2,
                  groupValue: _character,
                  onChanged: (ColorValue value) async {
                    await add('User menekan warna 2');
                    setState(() {
                      this.storeColor = 4278226943;
                      _character = value;
                    });
                  },
                ),
                RadioListTile<ColorValue>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleColor(
                        circleSize: 30.0,
                        color: Color(4279029763),
                      ),
                    ],
                  ),
                  value: ColorValue.c4,
                  groupValue: _character,
                  onChanged: (ColorValue value) async {
                    await add('User menekan warna 4');
                    setState(() {
                      this.storeColor = 4279029763;
                      _character = value;
                    });
                  },
                ),
                RadioListTile<ColorValue>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      CircleColor(
                        circleSize: 30.0,
                        color: Color(4278436560),
                      ),
                    ],
                  ),
                  value: ColorValue.c5,
                  groupValue: _character,
                  onChanged: (ColorValue value) async {
                    await add('User menekan warna 5');
                    setState(() {
                      this.storeColor = 4278436560;
                      _character = value;
                    });
                  },
                ),
                RadioListTile<ColorValue>(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      RaisedButton(
                        color: Colors.green,
                        child: Text(
                          'PILIH WARNA LAINNYA',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 17,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ),
                    ],
                  ),
                  value: ColorValue.c7,
                  groupValue: _character,
                  onChanged: (ColorValue value) async {
                    await add('User menekan pilih warna');
                    this.storeColor = 0;
                    await _showColorPicker().then((val) => {});
                    if (this.storeColor != 0) {
                      setState(() {
                        _character = value;
                      });
                    }
                  },
                ),
                Padding(
                  padding: EdgeInsets.only(
                    left: 10,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Warna pilihan anda',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      SizedBox(
                        height: 5.0,
                      ),
                      CircleColor(
                        circleSize: 30.0,
                        color: Color(storeColor),
                        elevation: 0,
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30.0),
                registerButton(),
                SizedBox(height: 10.0),
                cancelButton(),
                SizedBox(height: 10.0),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget nameField() {
    //MEMBUAT TEXT INPUT
    return TextFormField(
      onTap: () async {
        add('User menekan field tambah kategori');
      },
      controller: nameCategory,
      decoration: const InputDecoration(
        hintText: 'Masukkan Kategori',
        hintStyle: TextStyle(
          fontSize: 30,
          color: Colors.black38,
        ),
      ),
      style: TextStyle(
        fontSize: fSize,
        fontWeight: fWeight,
      ),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  Widget registerButton() {
    //MEMBUAT TOMBOL
    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: () async {
            if (nameCategory.text == '') {
              add('User menekan simpan, tetapi nama kategori kosong');
              showAlertDialog(
                context,
                "PERINGATAN",
                "Nama kategori tidak boleh kosong!",
              );
            } else if (storeColor == 0) {
              add('User menekan simpan, tetapi warna kategori kosong');
              showAlertDialog(
                context,
                "PERINGATAN",
                "Silahkan pilih warna latar kategori",
              );
            } else {
              add('User menekan simpan, sukses');

              CategoryList categoryList = new CategoryList.insert(
                  name: nameCategory.text, color: storeColor);
              await categoryListCon.addCat(categoryList);
              Navigator.pop(context, idx);
            }
          },
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50.0),
          child: Text(
            'SIMPAN',
            style: TextStyle(fontSize: 35.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget cancelButton() {
    //MEMBUAT TOMBOL
    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.deepOrangeAccent,
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: () async {
            await add('Menekan tombol batal');
            Navigator.pop(context, idx);
          },
          padding: EdgeInsets.symmetric(vertical: 15, horizontal: 50.0),
          child: Text(
            'BATAL',
            style: TextStyle(fontSize: 35.0, color: Colors.white),
          ),
        ),
      ),
    );
  }

  showAlertDialog(BuildContext context, String msg, String msgContent) {
    Widget okButton = RaisedButton(
      padding: EdgeInsets.symmetric(
        vertical: 7,
        horizontal: 15,
      ),
      child: Text(
        "Mengerti",
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 24,
        ),
      ),
      color: Color.fromRGBO(232, 108, 0, 1),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    AlertDialog alert = AlertDialog(
      title: Text(
        msg,
        style: TextStyle(
          color: Colors.blue,
          fontSize: 26,
          fontWeight: FontWeight.w600,
        ),
      ),
      content: Text(
        msgContent,
        style: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w600,
        ),
      ),
      actions: [
        okButton,
      ],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
