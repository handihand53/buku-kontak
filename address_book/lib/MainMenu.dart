import 'package:flutter/material.dart';
import 'GLOBAL.dart' as globals;

class MainMenu extends StatelessWidget {
  TextEditingController nama = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('DESAIN ADDRESS BOOK'),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            customBtn(context, 'Demo Desain 1', '/desain1'),
            customBtn(context, 'Demo Desain 2', '/desain2'),
            customBtn(context, 'Demo Desain Test', '/desaintest'),
            customBtn(context, 'Data Responden', '/data'),
          ],
        ),
      ),
    );
  }

  Future<dynamic> _showDialog(BuildContext context) {
    // flutter defined function
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: Text("Masukkan nama responden"),
          content: TextFormField(
            controller: nama,
            decoration: const InputDecoration(
              hintText: 'Masukkan nama',
            ),
            validator: (value) {
              if (value.isEmpty) {
                return 'Please enter some text';
              }
              return null;
            },
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Next"),
              onPressed: () {
                globals.name = nama.text;
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Widget customBtn(BuildContext context, String textBtn, String pathRoute) {
    return RaisedButton(
      onPressed: () async  {
        if (pathRoute != '/data') {
          await _showDialog(context).then((val){
            Navigator.of(context).pushNamedAndRemoveUntil(
              pathRoute,
              ModalRoute.withName('/mainmenu'),
            );
          });
        } else {
          Navigator.of(context).pushNamedAndRemoveUntil(
            pathRoute,
            ModalRoute.withName('/mainmenu'),
          );
        }
      },
      child: Text(textBtn, style: TextStyle(fontSize: 20)),
    );
  }
}
