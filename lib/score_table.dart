import 'package:flutter/material.dart';
import 'set.dart';

class ScoreTable extends StatefulWidget{
  ScoreTable({this.previousSets, this.t1Score, this.t2Score, this.numberOfSets});
  final int t1Score;
  final int t2Score;
  final int numberOfSets;
  final List<Set> previousSets;

  @override
  _ScoreTableState createState() => _ScoreTableState();
}

class _ScoreTableState extends State<ScoreTable> {
  DataTable scoreTable;

  List<DataColumn> dataColumns;

  List<DataCell> dataCell1;

  List<DataCell> dataCell2;

  List<DataRow> dataRows;

  DataTable buildTable(){
    setState(() {
      dataColumns = [
        DataColumn(label: Text("Team", style: TextStyle(fontSize: 10))),];
        //DataColumn(label: Text("Set 1", style: TextStyle(fontSize: 10)))];

      dataCell1 = [
        DataCell(Text("Team A", style: TextStyle(fontSize: 10))),
        //DataCell(Text("${widget.t1Score}", style: TextStyle(fontSize: 10))),
      ];

      dataCell2 = [
        DataCell(Text("Team B", style: TextStyle(fontSize: 10))),
        //DataCell(Text("${widget.t2Score}", style: TextStyle(fontSize: 10))),
      ];

      dataRows = [DataRow(cells: dataCell1,),
        DataRow(cells: dataCell2,)];

      int currentSet = widget.previousSets.length + 1;

      for(int i=1; i<=widget.numberOfSets; i++){

        dataColumns.add(DataColumn(
            label: Text("Set $i", style: TextStyle(fontSize: 10))));

        if (widget.previousSets.length >= i){

          Set set = widget.previousSets[i-1];

          // Set rows
          dataCell1.add(DataCell(
              Text("${set.getT1FinalScore()}", style: TextStyle(fontSize: 10))));
          dataCell2.add(DataCell(
              Text("${set.getT2FinalScore()}", style: TextStyle(fontSize: 10))));

        } else if(i-1 == widget.previousSets.length){

          // Set rows
          dataCell1.add(DataCell(
              Text("${widget.t1Score}", style: TextStyle(fontSize: 10))));
          dataCell2.add(DataCell(
              Text("${widget.t2Score}", style: TextStyle(fontSize: 10))));
        } else{

          dataCell1.add(DataCell(
              Text("0", style: TextStyle(fontSize: 10))));
          dataCell2.add(DataCell(
              Text("0", style: TextStyle(fontSize: 10))));
        }



      }

//      if (widget.numberOfSets == 2) {
//        // Set columns
//        dataColumns.add(DataColumn(
//            label: Text("Set 2", style: TextStyle(fontSize: 15))));
//
//        // Set rows
//        dataCell1.add(DataCell(
//            Text("${widget.t1Score}", style: TextStyle(fontSize: 15))));
//        dataCell2.add(DataCell(
//            Text("${widget.t2Score}", style: TextStyle(fontSize: 15))));
//      }

      scoreTable = DataTable(columnSpacing: 40.0,
        columns: dataColumns,
        rows: dataRows,
      );

    });
    return scoreTable;
    }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
      DataTable table = buildTable();
      return table;

//        DataTable(
//
//        columns: dataColumns,
//
//        rows: [
//          DataRow(cells: [
//            DataCell(Text("Team A", style: TextStyle(fontSize: 15),)),
//            DataCell(Text("$t1Score", style: TextStyle(fontSize: 15)))]),
//          DataRow(cells: [
//            DataCell(Text("Team B", style: TextStyle(fontSize: 15))),
//            DataCell(Text("$t2Score", style: TextStyle(fontSize: 15)))]),
//        ],
//      );

    }
}