//import 'dart:html';
import 'dart:core';

import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pickleball Game",
      theme: ThemeData.dark(),
      home: Scaffold(
        appBar: AppBar(
          title: Center(child:Text("Game Score")),
        ),
        body: HomeWidget(),
      ),
    );
  }
}

class HomeWidget extends StatefulWidget{

  @override
  _HomeWidgetState createState() => new _HomeWidgetState();
}

class Player{
  String name;
  bool serve;
  Player(String name, bool serve){
    this.name = name;
    this.serve = serve;
  }

  String getName(){
    return name;
  }

  bool isServe(){
    return serve;
  }

  void setServe(bool b){
    serve = b;
  }
}

class Team{

  Player a;
  Player b;
  int score=0;
  static int SERVE;

  Team(Player A, Player B){
    this.a = A;
    this.b = B;
  }

  List getPlayers(){
    return [a,b];
  }

  void setScoreToZero(){
    score =0;
  }
  bool isTeamServing(){
    if(a.isServe() || b.isServe()){
      return true;
    } else return false;
  }
  int getScore(){
    return score;
  }
  void incrementScore(){
    print("score before increment: $score");
    ++score;
    print("score after increment: $score");
  }
  bool isFirstServe(){
    return a.isServe();
  }
  void switchServe(){
    // switching serve. If a.isServe to true, set it to false and vice versa.
    // same for b.
    a.setServe((!a.isServe()));
    b.setServe((!b.isServe()));
  }
//  void setServeToValue(int i){
//    serve = i;
//  }
//  int getServeValue(){
//    return serve;
//  }
  void setTeamServingFlag(bool bl){
    if (bl){
      a.setServe(true);
      b.setServe(false);
    } else{
      a.setServe(false);
      b.setServe(false);
    }
  }
}

class _HomeWidgetState extends State<HomeWidget> {

  String _scoreDisplay ;
  Player p1;
  Player p2;
  Player p3;
  Player p4;
  Team t1;
  Team t2;
  bool gameStart;
  _HomeWidgetState(){


    p1 = new Player('player1', true);
    p2 = new Player('player2', false);
    p3 = new Player('player3', false);
    p4 = new Player('player2', false);

    t1 = new Team(p1, p2);
    t2 = new Team(p3, p4);
    Team.SERVE=0;

    print("object t1: $t1");
  }
  void _setup(){


    setState(() {
      t1.setScoreToZero();
      t2.setScoreToZero();
      Team.SERVE=2;
      p1.setServe(false);
      p2.setServe(false);
      p3.setServe(true);
      p4.setServe(false);
      gameStart=true;
      _scoreDisplay = "${t1.getScore()} * - "+"${t2.getScore()} - "+"(${Team.SERVE})";
    });
  }
  void _incrementScore(Team t){

//    print("object is :$t");
//    print("is team serving : ${t.isTeamServing()}");
    setState(() {

        if (t.isTeamServing()) {
          t.incrementScore();

          //switch position of team members
        } else {
          if (Team.SERVE == 1) {
            Team.SERVE = 2;
          } else {
            Team.SERVE = 1;
          }
          if (t == t2) {
            if (t1.isFirstServe()) {
              if (gameStart){
                t1.setTeamServingFlag(false);
                t2.setTeamServingFlag(true);
                gameStart = false;
              } else {
                t1.switchServe();
                //Team.SERVE = 2;
              }
            } else {
              t1.setTeamServingFlag(false);
              t2.setTeamServingFlag(true);
            }
          } else {
            if (t2.isFirstServe()) {
              if (gameStart){
                t1.setTeamServingFlag(true);
                t2.setTeamServingFlag(false);
                gameStart = false;
              } else {
                t2.switchServe();
              }
            } else {
              t2.setTeamServingFlag(false);
              t1.setTeamServingFlag(true);
            }
          }
        }

        if (t1.isTeamServing()){
          _scoreDisplay = "${t1.getScore()} * - "+"${t2.getScore()} - "+"(${Team.SERVE})";
        } else{
          _scoreDisplay = "${t2.getScore()} * - "+"${t1.getScore()} - "+"(${Team.SERVE})";
        }
        
        if (t1.getScore()==11 || t2.getScore()==11){
          print("game ends");
          //gameEnds();
          // Disable all buttons except new Game.
        }
      }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
            child:Text("Score",
              style: TextStyle(fontSize: 30, color: Colors.white70)
//              style: Theme.of(context)
//                  .textTheme
//                  .headline4
//                  .copyWith(color: Colors.white70)
              ),
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(10),

        ),
        Container(
          child:Text("$_scoreDisplay",
              style: TextStyle(fontSize: 30, color: Colors.white70)
//              style: Theme.of(context)
//                  .textTheme
//                  .headline4
//                  .copyWith(color: Colors.white70)
          ),
          margin: const EdgeInsets.only(bottom: 10),
          alignment: Alignment.bottomCenter,
          //padding: EdgeInsets.all(10),

        ),
//        Container(
//
//          margin: const EdgeInsets.only(bottom:10.0),
//          alignment: Alignment.topCenter,
//          //padding: EdgeInsets.all(75),
//          child:Row(
//              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//              mainAxisSize: MainAxisSize.min,
//              children:<Widget>[
//                  Flexible(
//                    flex:10,
//                    fit: FlexFit.loose,
//                    child:
//                      Text("Team B - ",
//                          style: TextStyle(fontSize: 15, color: Colors.white70),
////                          style: Theme.of(context)
////                              .textTheme
////                              .headline6
////                              .copyWith(color: Colors.blue)
//                        ),
//                  ),
//                  Flexible(
//                    flex: 10,
//                    fit: FlexFit.loose,
//                    child:
//                      Text("${t2.getScore()}",
//                            style: Theme.of(context)
//                                .textTheme
//                                .headline6
//                                .copyWith(color: Colors.blue)
//                        ),
//                    ),
//                  Spacer(flex:10),
//                  Flexible(
//                    flex: 10,
//                    child:Text("Team A - ",
//                      style: Theme.of(context)
//                          .textTheme
//                          .headline6
//                          .copyWith(color: Colors.blue)
//                      )
//                  ),
//                  Flexible(
//                    flex: 10,
//                    child:Text("${t1.getScore()}",
//                      style: Theme.of(context)
//                          .textTheme
//                          .headline6
//                          .copyWith(color: Colors.blue)
//                    )
//                  ),
//              ]
//          ),
//
//        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: Colors.orangeAccent,
          ),
          alignment: Alignment.bottomLeft,
          padding: EdgeInsets.all(40),
          margin: EdgeInsets.all(20),
          child: Center(
                child:Stack(
                  children:<Widget>[
                    CustomPaint( //                       <-- CustomPaint widget
                      size: Size(300, 200),
                      painter: RectPainter(),
                    ),
                    CustomPaint(
                      painter: HlinePainter(Offset(0,100),Offset(120,100)),
                    ),
                    CustomPaint(
                      painter: HlinePainter(Offset(180,100),Offset(300,100)),
                    ),
                    CustomPaint(
                      painter: VlinePainter(),
                    ),
                    Positioned(
                        right: 180,
                        child:Dash(
                            direction: Axis.vertical,
                            length: 200,
                            dashLength: 10,
                            dashThickness: 3,
                            dashColor: Colors.white)
                    ),
                    Positioned(
                      right: 120,
                      child:Dash(
                          direction: Axis.vertical,
                          length: 200,
                          dashLength: 10,
                          dashThickness: 3,
                          dashColor: Colors.white)
                    ),


                    Positioned(
                        right: 20,
                        top: 20,
                        child: Visibility(
                          child:Icon(
                            Icons.blur_circular,
                            color: Colors.white,
                            size:30,
                            semanticLabel: "text",
                          ),
                          visible: p1.isServe(),
                        ),
                      ),

                    Visibility(
                      child: Positioned(
                        right: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.blur_circular,
                          color: Colors.white,
                          size:30,
                        ),
                      ),
                      visible: p2.isServe(),
                    ),
                    Visibility(
                      child: Positioned(
                        left: 20,
                        bottom: 20,
                        child: Icon(
                          Icons.blur_circular,
                          color: Colors.white,
                          size:30,
                        ),
                      ),
                      visible: p3.isServe(),
                    ),
                    Visibility(
                      child: Positioned(
                      left: 20,
                      top: 20,
                      child: Icon(
                        Icons.blur_circular,
                        color: Colors.white,
                        size:30,
                      ),
                    ),
                      visible: p4.isServe(),
                    ),
                  ]
              )
          ),


    ),
      Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget> [
            RaisedButton.icon(
                label:Text('Score Team B',style: TextStyle(fontSize: 15, color: Colors.black)),
                color: Colors.orange,
                icon: Icon(Icons.add),
                onPressed: (){
                  _incrementScore(t2);
                  },
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  //color:Colors.orange,
                  textColor: Colors.black,
                  ),
            RaisedButton.icon(
                  label:Text('Score Team A',style: TextStyle(fontSize: 15, color: Colors.black)),
                  color: Colors.orange,
                  icon: Icon(Icons.add),
                  onPressed: (){
                  _incrementScore(t1);
                  },
                  shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  textColor: Colors.black,
            ),
          ]
        )
      ),
      Container(
        child: RaisedButton.icon(
          label:Text('Start',style: TextStyle(fontSize: 15, color: Colors.black)),
          color: Colors.orange,
          icon: Icon(Icons.play_arrow),
          onPressed: _setup,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0))),
          //color:Colors.orange,
          textColor: Colors.black,
        ),
      ),
      Container(
          child:DataTable(

            columns: [
              DataColumn(label: Text("Team",style: TextStyle(fontSize: 15))),
              DataColumn(label: Text("Set 1",style: TextStyle(fontSize: 15))),
//              DataColumn(label: Text("Set 2")),
//              DataColumn(label: Text("Set 3")),
            ],
            rows: [
              DataRow(cells: [
                DataCell(Text("Team A",style: TextStyle(fontSize: 15),)),
                DataCell(Text("${t1.getScore()}",style: TextStyle(fontSize: 15)))]),
              DataRow(cells: [
                DataCell(Text("Team B",style: TextStyle(fontSize: 15))),
                DataCell(Text("${t2.getScore()}",style: TextStyle(fontSize: 15)))]),
            ],
          )
      )
    ]
    );
  }
}

class RectPainter extends CustomPainter { //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    //                                           <-- Insert your painting code here.
    final left = 0.0;
    final top = 0.0;
    final right = 300.0;
    final bottom = 200.0;
    final rect = Rect.fromLTRB(left, top, right, bottom);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawRect(rect, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class HlinePainter extends CustomPainter {
  //         <-- CustomPainter class
  Offset p1;
  Offset p2;

  HlinePainter(Offset p1, Offset p2){
    this.p1 = p1;
    this.p2 = p2;
  }
  @override
  void paint(Canvas canvas, Size size) {
    //                                           <-- Insert your painting code here.
  //  final p1 = Offset(0,100);
  //  final p2 = Offset(300,100);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(p1,p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class VlinePainter extends CustomPainter {
  //         <-- CustomPainter class
  @override
  void paint(Canvas canvas, Size size) {
    //                                           <-- Insert your painting code here.
    final p1 = Offset(150,0);
    final p2 = Offset(150,200);
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawLine(p1,p2, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}

class ServeBallPainter extends CustomPainter {
  //         <-- CustomPainter class
  Offset center;

  ServeBallPainter(Offset center){
    this.center = center;
  }

  @override
  void paint(Canvas canvas, Size size) {
    //                                           <-- Insert your painting code here.
    //final c = Offset(225,50);
    final radius = 15.0;
    final paint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4;
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(CustomPainter old) {
    return false;
  }
}