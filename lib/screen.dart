import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simplecalcflutter/home_page.dart';

import 'main.dart';

class Screen extends StatefulWidget{
  const Screen({super.key});

  @override
  State<Screen> createState() => _NewState();
}

class _NewState extends State<Screen>{
  String textview = '';
  void query() async {
    final allRows = await dbHelper.queryAllRows();
    for (final row in allRows) {
      print(row['sums']);
      // debugPrint(row.toString());
    }
  }
  void _takeDataFromDB() async {
    setState(() {

    });
    // print(counter);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('new page'),
        ),
        body: Center(
          child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const MyTable(),
                      ElevatedButton(onPressed:
                        _takeDataFromDB,
                        child: const Text('Take All Data')),
                    ],
                  ),
        ),
    );
  }
}

class MyTable extends StatefulWidget {
  const MyTable({super.key});


  @override
  State<MyTable> createState() => _MyTableState();
}

class _MyTableState extends State<MyTable> {

  late final List<Map<String, dynamic>> allRows;

  void query() async {
    allRows = await dbHelper.queryAllRows();
    debugPrint('query all rows:');
    for (final row in allRows) {
      print(row['sums']);
      // debugPrint(row.toString());
    }
    _tableData = allRows;

    setState(() {

    });
  }
  List<Map<String, dynamic>> _tableData = [];

  @override
  void initState() {
    query();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Table(
      border: TableBorder.all(),
      defaultVerticalAlignment: TableCellVerticalAlignment.middle,
      children: [
        TableRow(
          children: ['ID','Sums']
              .map((header) => TableCell(
              child: Center(child: Text(header)),
              )).toList(),
        ),
        ..._tableData.map((rowData){
          return TableRow(
            children: ['_id','sums']
                .map((field) => TableCell(
                  child: Center(
                      child: Text('${rowData[field]}')),
                  )).toList(),
                );
        })
      ],
    );
  }
}
