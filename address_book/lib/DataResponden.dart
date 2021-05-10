import 'package:address_book/services/RecordCon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DataResponden extends StatefulWidget {
  @override
  _DataRespondenState createState() => _DataRespondenState();
}

class _DataRespondenState extends State<DataResponden> {
  List<TableRow> tableListWidget2 = new List();
  List<TableRow> tableListWidget = new List();
  RecordCon recordCon = new RecordCon();
  List recordList = new List();

  Widget table;

  @override
  void initState() {
    super.initState();
    getDataTable();
  }

  void getDataTable() async {
    int nomor = 1;

    tableListWidget.add(
      TableRow(
        children: [
          TableCell(
            child: Center(
              child: Text('No'),
            ),
          ),
          TableCell(
            child: Center(
              child: Text('Task Name'),
            ),
          ),
          TableCell(
            child: Center(
              child: Text('Count Click'),
            ),
          ),
          TableCell(
            child: Center(
              child: Text('Action Name'),
            ),
          ),
          TableCell(
            child: Center(
              child: Text('Time'),
            ),
          ),
          TableCell(
            child: Center(
              child: Text('Tag'),
            ),
          ),
        ],
      ),
    );

    recordList = await recordCon.getRecord();
    print(recordList.toString());
    recordList.forEach((val) {
      TableRow tableRow = TableRow(
        children: [
          TableCell(
            child: Center(
              child: Text(nomor.toString()),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
          TableCell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(val['task_name']),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
          TableCell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(val['count_click']),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
          TableCell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(val['action_name']),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
          TableCell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(val['time']),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
          TableCell(
            child: Center(
              child: Padding(
                padding: EdgeInsets.all(5),
                child: Text(val['tag']),
              ),
            ),
            verticalAlignment: TableCellVerticalAlignment.top,
          ),
        ],
      );

      tableListWidget.add(tableRow);
      nomor++;
      setState(() {
        tableListWidget2 = tableListWidget;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Data Responden"),
        ),
        body: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              RaisedButton(
                child: Text('Reset'),
                onPressed: (){
                  recordCon.resetRecord();
                },
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Table(
                  columnWidths: {
                    0: FractionColumnWidth(0.1),
                    1: FractionColumnWidth(0.15),
                    2: FractionColumnWidth(0.15),
                    3: FractionColumnWidth(0.35),
                    4: FractionColumnWidth(0.15),
                    5: FractionColumnWidth(0.1),
                  },
                  border: TableBorder.all(
                      color: Colors.black26, width: 1, style: BorderStyle.solid),
                  children: tableListWidget2,
                ),
              ),
            ],
          )
        ),
      ),
    );
  }
}
