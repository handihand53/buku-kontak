import 'dart:io';

import 'package:address_book/models/ContactList.dart';
import 'package:address_book/services/CategoryListCon.dart';
import 'package:address_book/services/ContactListCon.dart';
import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'AddCategories.dart';
import 'models/TimerModel.dart';

final String TASK_NAME = 'Tambah Kontak';
RecordCon recordCon = new RecordCon();
StopWatchTimer sw;
int _idx;

class AddContact extends StatelessWidget {
  StopWatchTimer _stopWatch;
  int idx;

  AddContact(this.idx, this._stopWatch);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Text("Tambah Kontak"),
      ),
      body: RegisterScreen(idx, _stopWatch),
    );
  }
}

class RegisterScreen extends StatefulWidget {
  int idx;
  StopWatchTimer _stopWatch;

  RegisterScreen(this.idx, this._stopWatch);

  createState() {
    return RegisterScreenState(idx, _stopWatch);
  }
}

class RegisterScreenState extends State<RegisterScreen> {
  int idx = 0;
  StopWatchTimer _stopWatch;
  RegisterScreenState(this.idx, this._stopWatch);
  List<DropdownMenuItem<String>> listDrop = [];
  String selected = null;
  double fSize = 30;
  FontWeight fWeight = FontWeight.w500;
  final _formKey = GlobalKey<FormState>();
  File imageFile;
  File imgpathCoba;
  List categoryList = new List();
  String imagePath = '';
  TextEditingController contactName = new TextEditingController();
  TextEditingController phoneNumber = new TextEditingController();

  CategoryListCon categoryListCon = new CategoryListCon();
  ContactListCon contactListCon = new ContactListCon();

  @override
  void initState() {
    super.initState();
    getCategoryList();
  }

  void getCategoryList() async {
    categoryList = await categoryListCon.getAllCategory();
    listDrop = [];
    categoryList.forEach(
      (data) {
        listDrop.add(
          DropdownMenuItem(
            child: Text(
              data['cat_name'],
              style: TextStyle(
                fontSize: fSize,
                fontWeight: fWeight,
              ),
            ),
            value: data['id'].toString(),
          ),
        );
      },
    );
    setState(() {});
  }

  Future<bool> _onBackPressed() async {
    await add('Menekan tombol kembali');
    Navigator.pop(context, idx);
  }

  Widget build(context) {
    return WillPopScope(
      onWillPop: _onBackPressed,
      child: SingleChildScrollView(
        child: Container(
          margin: EdgeInsets.only(left: 20.0, right: 20.0, bottom: 20.0),
          //SET MARGIN DARI CONTAINER
          child: Form(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: imageFile == null
                      ? Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            image: DecorationImage(
                              image: ExactAssetImage('assets/images/dummy.jpg'),
                              fit: BoxFit.cover,
                            ),
                          ),
                        )
                      : Container(
                          margin: EdgeInsets.only(top: 10),
                          height: 150.0,
                          width: 150.0,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(90.0),
                            border: Border.all(
                              color: Colors.white,
                              style: BorderStyle.solid,
                              width: 2.0,
                            ),
                            image: DecorationImage(
                              image: FileImage(imageFile),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                ),
                SizedBox(height: 15.0),
                Center(
                  child: InkWell(
                    child: Text(
                      "Pilih Foto",
                      style: TextStyle(
                        fontSize: fSize,
                        fontWeight: fWeight,
                        color: Colors.blue,
                      ),
                    ),
                    onTap: () async {
                      String currentTime;
                      await _stopWatch.onExecute.add(StopWatchExecute.lap);
                      await _stopWatch.records.listen((value) async {
                        currentTime = value[idx].displayTime;
                      });
                      recordCon.addRecord(new TimerModel(
                        taskName: TASK_NAME,
                        countClick: 'Klik ke ' + (idx + 1).toString(),
                        actionName: 'Menekan pilih foto',
                        time: currentTime,
                      ));
                      idx++;
                      _pickImage();
                    },
                  ),
                ),
                SizedBox(height: 20.0),
                Text(
                  "Nama Lengkap",
                  style: TextStyle(
                    fontSize: fSize - 10.0,
                    fontWeight: fWeight,
                  ),
                ),
                nameField(),
                SizedBox(height: 30.0),
                Text(
                  "Nomor Telepon",
                  style: TextStyle(
                    fontSize: fSize - 10.0,
                    fontWeight: fWeight,
                  ),
                ),
                nomorTeleponField(),
                SizedBox(height: 30.0),
                Text(
                  "Kategori",
                  style: TextStyle(
                    fontSize: fSize - 10.0,
                    fontWeight: fWeight,
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    kategoriField(),
                    RaisedButton(
                      color: Colors.green,
                      elevation: 1.0,
                      padding: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      onPressed: () async {
                        String currentTime;
                        await _stopWatch.onExecute.add(StopWatchExecute.lap);
                        await _stopWatch.records.listen((value) async {
                          currentTime = value[idx].displayTime;
                        });
                        recordCon.addRecord(new TimerModel(
                          taskName: TASK_NAME,
                          countClick: 'Klik ke ' + (idx + 1).toString(),
                          actionName: 'Menekan tombol tambah kategori',
                          time: currentTime,
                        ));
                        idx++;
                        sw = _stopWatch;
                        _idx = idx;
                        Navigator.of(context).push(_createRoute()).then((val){
                          idx = val;
                        });
                      },
                      child: Text(
                        "TAMBAH KATEGORI",
                        style: TextStyle(
                          fontSize: fSize - 10.0,
                          fontWeight: FontWeight.w900,
                          color: Colors.white
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 30.0),
                registerButton(),
                SizedBox(height: 10.0),
                cancelButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<String> get _localPath async {
    final directory = await getExternalStorageDirectory();
    return directory.path;
  }

  Future _pickImage() async {
    imageFile = await ImagePicker.pickImage(source: ImageSource.gallery);
    setState(() {});
  }

  Widget nameField() {
    //MEMBUAT TEXT INPUT
    return TextFormField(
      controller: contactName,
      onTap: () async {
        String currentTime;
        await _stopWatch.onExecute.add(StopWatchExecute.lap);
        await _stopWatch.records.listen((value) async {
          currentTime = value[idx].displayTime;
        });
        recordCon.addRecord(new TimerModel(
          taskName: TASK_NAME,
          countClick: 'Klik ke ' + (idx + 1).toString(),
          actionName: 'Menekan text form nama lengkap',
          time: currentTime,
        ));
        idx++;
      },
      decoration: const InputDecoration(
        hintText: 'Masukkan Nama',
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

  Widget nomorTeleponField() {
    return TextFormField(
      inputFormatters: [WhitelistingTextInputFormatter.digitsOnly],
      keyboardType: TextInputType.number,
      controller: phoneNumber,
      onTap: () async {
        String currentTime;
        await _stopWatch.onExecute.add(StopWatchExecute.lap);
        await _stopWatch.records.listen((value) async {
          currentTime = value[idx].displayTime;
        });
        recordCon.addRecord(new TimerModel(
          taskName: TASK_NAME,
          countClick: 'Klik ke ' + (idx + 1).toString(),
          actionName: 'Menekan text form nomor telepon',
          time: currentTime,
        ));
        idx++;
      },
      decoration: const InputDecoration(
        hintText: 'Masukkan Nomor',
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

  Widget kategoriField() {
    return DropdownButton<String>(
      value: selected,
      hint: Text(
        'Pilih Kategori',
        style: TextStyle(
          fontSize: fSize,
          fontWeight: fWeight,
          color: Colors.black38,
        ),
      ),
      items: listDrop,
      onChanged: (value) async {
        String currentTime;
        await _stopWatch.onExecute.add(StopWatchExecute.lap);
        await _stopWatch.records.listen((value) async {
          currentTime = value[idx].displayTime;
        });
        recordCon.addRecord(new TimerModel(
          taskName: TASK_NAME,
          countClick: 'Klik ke ' + (idx + 1).toString(),
          actionName: 'Menekan dropdown pilih kategori',
          time: currentTime,
        ));
        idx++;
        selected = value;
        setState(() {});
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

  Widget registerButton() {
    return Align(
      alignment: Alignment.center,
      child: Material(
        elevation: 1.0,
        borderRadius: BorderRadius.circular(5.0),
        color: Colors.blue,
        child: MaterialButton(
          minWidth: double.infinity,
          onPressed: () async {
            if (contactName.text == '') {
              await add('Menekan tombol simpan, nama kontak kosong');
              showAlertDialog(
                  context, "PERINGATAN", "Nama kontak tidak boleh kosong!");
            } else if (phoneNumber.text == '') {
              await add('Menekan tombol simpan, nomor telepon kosong');
              showAlertDialog(
                  context, "PERINGATAN", "Nomor telepon tidak boleh kosong!");
            } else if (selected == null) {
              await add('Menekan tombol simpan, kategori kosong');
              showAlertDialog(
                  context, "PERINGATAN", "Silahkan pilih kategori!");
            } else {
              await add('Menekan tombol simpan, sukses');
              if (imageFile != null) {
                final path = await _localPath;
                String filename = imageFile.path
                    .toString()
                    .substring(path.lastIndexOf("/") + 1);
                print(path);
                print(imageFile.path);
                final File newImage = await imageFile.copy('$path/$filename');
                imagePath = newImage.path;
              }

              ContactList contactList = new ContactList.insert(
                name: contactName.text,
                phoneNumber: phoneNumber.text,
                catId: int.parse(selected),
                imgUrl: imagePath,
              );

              await contactListCon
                  .addContact(contactList)
                  .then((e) => Navigator.pop(context, idx));
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
            style: TextStyle(
              fontSize: 35.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}

Route _createRoute() {
  return PageRouteBuilder(
    pageBuilder: (context, animation, secondaryAnimation) => AddCategories(_idx, sw),
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
