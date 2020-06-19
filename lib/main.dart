//import 'dart:html';
import 'dart:collection';
import 'dart:core';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dash/flutter_dash.dart';
import 'score_table.dart';
import 'set.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Pickleball Game",
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => SetupWidget(),
        //'/game': (context) => HomeWidget(),
      },
    );
  }
}

class SetupWidget extends StatefulWidget{

  @override
  _SetupWidgetState createState() => new _SetupWidgetState();
}

enum ServingSide { left, right }

class _SetupWidgetState extends State<SetupWidget> {
  int pointsPerGame = 11;
  int gamePerMatch = 1;
  //String servingTeam;
  ServingSide servingTeam = ServingSide.left;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
//        title: Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          children: [
//            Image.asset(
//              'images/logo1.jpg',
//              fit:BoxFit.fill,
//              height: 32,
//              width: 50,
//            ),
//
//          ],
//
//        ),
        title: Center(child:Text("Game Setup")),
            ),
        //backgroundColor: Colors.black,
        body:Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Spacer(),
                Container(
                  child: Text("Points Per Game "),
                ),
                Container(
                  margin: EdgeInsets.all(10) ,
                  decoration: new BoxDecoration(

                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(
                        color: Colors.grey,
                          width: 1.0
                        ),
                      //color: Colors.white
                ),

                  child: Slider(
                    value: pointsPerGame.toDouble(),
                    min: 11.0,
                    max: 21.0,
                    divisions: 5,
                    label: '$pointsPerGame',
                    //label: 'Game Sets',
                    onChanged: (double newSetPerMatch){
                      setState(() {
                        pointsPerGame = newSetPerMatch.round();
                      });
                    },
                  ),
                ),
                Spacer(),
                Container(
                  child: Text("Number Of Games in Match "),
                ),
                Container(
                  margin: EdgeInsets.all(10) ,
                  decoration: new BoxDecoration(

                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.grey,
                        width: 1.0
                    ),
                    //color: Colors.white
                  ),

                  child: Slider(
                    value: gamePerMatch.toDouble(),
                    min: 1.0,
                    max: 5.0,
                    divisions: 4,
                    label: '$gamePerMatch',
                    //label: 'Game Sets',
                    onChanged: (double newMatchPerGame){
                      setState(() {
                        gamePerMatch = newMatchPerGame.round();
                      });
                    },
                  ),
                ),
                Spacer(),
                Container(
                  child: Text("Serving Side"),
                ),

                Container(
                  margin: EdgeInsets.all(10) ,
                  decoration: new BoxDecoration(

                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    border: Border.all(
                        color: Colors.grey,
                        width: 1.0
                    ),
                    //color: Colors.white
                  ),
                  child:Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Radio(
                          value: ServingSide.left,
                          activeColor: Colors.blue,
                          groupValue: servingTeam,
                          onChanged: (ServingSide value) {
                            setState(() { servingTeam = value; });
                          },
                        ),
                      Text("Left Team"),
                      Spacer(),
                      Text("Right Team"),
                      Radio(
                          value: ServingSide.right,
                          activeColor: Colors.blue,
                          autofocus: true,
                          groupValue: servingTeam,
                          onChanged: (ServingSide value) {
                            setState(() { servingTeam = value; });
                          },
                        ),
                      ],
                    ),
                  ),
                Spacer(),
                RaisedButton(
                  child: Text('Done',
                      style: TextStyle(fontSize: 20, color: Colors.white,),

                      ),
                  //label:Text('Done',style: TextStyle(fontSize: 15, color: Colors.black)),
                  color: Colors.blueAccent[400],
                  splashColor: Colors.white,
                  //icon: Icon(Icons.add),
                  onPressed: (){
//                    Navigator.pushNamed(
//                        context,
//                        '/game',
//                      );
//                    Navigator.push(
//                        context,
//                        MaterialPageRoute(
//                            builder: (context) => HomeWidget(),
//                            settings: RouteSettings(
//                                arguments: matchPerGame),
//                        ),
//
//                        //arguments: matchPerGame,
//                      );

                    Navigator.of(context).push(
                        new MaterialPageRoute(
                            builder: (context) {
                            return new HomeWidget(pointsPerGame, gamePerMatch, servingTeam);
                      },
                    )
                  );
                  },
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(10.0))),
                  //color:Colors.orange,
                  textColor: Colors.black,
                ),
                Spacer(),
              ],
            )
    );
  }
}

class HomeWidget extends StatefulWidget{
  final int matchPerGame;
  final ServingSide servingTeam;
  int pointsPerGame;
  HomeWidget(this.pointsPerGame, this.matchPerGame, this.servingTeam);

//  int getMatchPerGame(){
//    return matchPerGame;
//  }

  @override
  _HomeWidgetState createState() => new _HomeWidgetState(matchPerGame, servingTeam);
}

class _HomeWidgetState extends State<HomeWidget> {

  String _scoreDisplay = "" ;
  Player p1;
  Player p2;
  Player p3;
  Player p4;
  Team t1;
  Team t2;
  bool gameStart;
  int count = 1;

  //StackItem stackItem ;
  ListQueue<Map> gameStateQueue;
  bool emptyQueueFlag=true;
  int mpg;
  ServingSide servingTeam;
  bool matchEnds = false;
  List<Set> previousSetsScores=[];
  bool scoreTeamBButtonVisibility = false;
  bool scoreTeamAButtonVisibility = false;
  String startButtonLabel = 'Start';

  _HomeWidgetState(matchPerGame, servingTeam){

    mpg = matchPerGame;
    this.servingTeam = servingTeam;
    if (this.servingTeam == ServingSide.right){
      p1 = new Player('player1', true);
      p3 = new Player('player3', false);
    } else{
      p1 = new Player('player1', false);
      p3 = new Player('player3', true);
    }

    p2 = new Player('player2', false);
    p4 = new Player('player2', false);

    t1 = new Team(p1, p2);
    t2 = new Team(p3, p4);
    Team.SERVE=0;

//    print("object t1: $t1");
//    print('match per game: $mpg');
//    print('serving Team: $servingTeam');
    gameStateQueue = new Queue<Map>();
  }

  // Method gets called when Start/Restart button is pressed and also when a game ends.
  void _setup(){

    //count = 1;

    setState(() {
      //mpg = widget.matchPerGame;
      print('count is: $count');
      t1.setScoreToZero();
      t2.setScoreToZero();
      Team.SERVE=2;
//      if (this.servingTeam == ServingSide.right) {
//        p1.setServe(true);
//      } else p3.setServe(true);
//
//      p2.setServe(false);
//      p4.setServe(false);

      gameStart=true;
      _scoreDisplay = "${t1.getScore()} * - "+"${t2.getScore()} - "+"(${Team.SERVE})";
      gameStateQueue.clear();
      emptyQueueFlag = true;
      scoreTeamBButtonVisibility = true;
      scoreTeamAButtonVisibility = true;
      if (!matchEnds) {
        previousSetsScores = [];
      }

      if(startButtonLabel == 'Start') {
        startButtonLabel = 'Restart';
      } else startButtonLabel = 'Start';

    });
  }

  // This gets called when match ends.
  void _endState(){
//    count=1;
    setState(() {
      scoreTeamBButtonVisibility = false;
      scoreTeamAButtonVisibility = false;

      if(startButtonLabel == 'Start') {
        startButtonLabel = 'Restart';
      } else startButtonLabel = 'Start';

    });
  }

  Player getCurrentServingPlayer(){
    if(p1.isServe()){
      return p1;
    } else{
      if(p2.isServe()){
        return p2;
      }else {
        if(p3.isServe()){
          return p3;
        } else return p4;
      }
    }
  }
  void _incrementScore(Team t){

//    print("object is :$t");
//    print("is team serving : ${t.isTeamServing()}");
    setState(() {

          scoreTeamAButtonVisibility = true;
          scoreTeamBButtonVisibility = true;


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

          // Logic to include undo functionality
          Map gameState = {'t1Score': t1.getScore(),
                      't2Score': t2.getScore(),
                      'serve': Team.SERVE,
                      'currentServingPlayer':getCurrentServingPlayer()};

          gameStateQueue.addLast(gameState);
          emptyQueueFlag = false;
//          print("Queue Length:${gameStateQueue.length}");
//          print("Queue:$gameStateQueue");
//          print("Last player: ${gameStateQueue.last['currentServingPlayer']}");
          // Stack push
          // Dictionary: t1_score: , t2_score:, Team.SERVE:, getCurrentServingPlayer():
          if (gameState['currentServingPlayer']==p1 || gameState['currentServingPlayer']==p2 ){
            _scoreDisplay = "${gameState['t1Score']} * - "+"${gameState['t2Score']} - "+"(${gameState['serve']})";
          } else{
            _scoreDisplay = "${gameState['t2Score']} * - "+"${gameState['t1Score']} - "+"(${gameState['serve']})";
          }

          int endPoint = widget.pointsPerGame;
          if(t1.getScore()==(widget.pointsPerGame -1) && t2.getScore()==(widget.pointsPerGame -1) ){
            endPoint = widget.pointsPerGame + 1;
          }

          if (t1.getScore()== endPoint || t2.getScore()== endPoint){
            // Display game over message and score

            print("Match ends");
            // score reset
            // service reset
            // set previous set score
            matchEnds = true;

            Set previousSet = Set(count);
            previousSet.setFinalScore(t1.getScore(), t2.getScore());


            //previousSetsScores = [];
            previousSetsScores.add(previousSet);
            //Set currentSet = Set(count+1);
            //gameEnds();
            _setup();
            //widget.pointsPerGame = points;
            // Disable all buttons except new Game.
            if(count==mpg){
              print('Game ends!');
              //startButtonLabel = 'Start';
              gameStart = false;
              //_setup();
              count = 0;
              _endState();
            }
            count++;

          }

          print("Set List Length:${previousSetsScores.length}");

        //
        }

    );

  }

  void _undoClick(){

    setState(() {
      Map el = gameStateQueue.removeLast();
      if (gameStateQueue.isEmpty) {
        emptyQueueFlag = true;
        //t1.setScore(0);
        //t2.setScore(0);
        //Team.SERVE = 2;

      } else {
          Map gameState = gameStateQueue.last;
          if (gameState['currentServingPlayer'] == p1 ||
              gameState['currentServingPlayer'] == p2) {
            _scoreDisplay =
                "${gameState['t1Score']} * - " + "${gameState['t2Score']} - " +
                    "(${gameState['serve']})";
          } else {
            _scoreDisplay =
                "${gameState['t2Score']} * - " + "${gameState['t1Score']} - " +
                    "(${gameState['serve']})";
          }
          t1.setScore((gameState['t1Score']));
          t2.setScore(gameState['t2Score']);
          Team.SERVE = gameState['serve'];
          gameState['currentServingPlayer'].setServe(true);
          if (gameState['currentServingPlayer'] != el['currentServingPlayer']) {
            el['currentServingPlayer'].setServe(false);
          }
      }
    }
    );

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
        title: Center(child:Text("Game Score")),
    ),
    body:Column(
      children: <Widget>[
        Container(
            width: 200,
            margin: const EdgeInsets.only(top: 20),
            alignment: Alignment.bottomCenter,
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
                color: Colors.grey,
              backgroundBlendMode: BlendMode.modulate,
              border: Border.all(color: Colors.black12,
                  width:3.0,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                offset: Offset(0,-2),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.16),
              )]
            ),
            child:Column(
              children: <Widget>[
                Text("Score",
                    style: TextStyle(fontSize: 30, color: Colors.white70)

                ),
                //Spacer(),
                Text("$_scoreDisplay",
                    style: TextStyle(fontSize: 30, color: Colors.white70)
                ),
              ],
            )



        ),

        Container(
          width:420,
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
        padding: EdgeInsets.all(5),
        margin: EdgeInsets.all(10),
        width: 420,
        //height: 150,
        decoration: BoxDecoration(
            color: Colors.grey,
            backgroundBlendMode: BlendMode.modulate,
            border: Border.all(color: Colors.black12,
              width:3.0,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [BoxShadow(
              offset: Offset(0,-2),
              blurRadius: 30,
              color: Colors.black.withOpacity(0.16),
            )]
        ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget> [
                  RaisedButton.icon(
                    label:Text('Score Team B',style: TextStyle(fontSize: 15, color: Colors.black)),
                    color: Colors.orange,

                    icon: Icon(Icons.add),
                    onPressed:scoreTeamBButtonVisibility? () => _incrementScore(t2):null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    //color:Colors.orange,
                    textColor: Colors.black,
                  ),
                  RaisedButton.icon(
                    label:Text('Score Team A',style: TextStyle(fontSize: 15, color: Colors.black)),
                    color: Colors.orange,
                    icon: Icon(Icons.add),
                    onPressed: scoreTeamBButtonVisibility? () => _incrementScore(t1):null,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0))),
                    textColor: Colors.black,
                  ),
            ],),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children:<Widget> [
                    RaisedButton.icon(
                      label:Text('     '+'$startButtonLabel'+'       ',style: TextStyle(fontSize: 15, color: Colors.black)),
                      color: Colors.orange,
                      splashColor: Colors.white,
                      icon: Icon(Icons.play_arrow),
                      onPressed: (){
                        matchEnds = false;
                        _setup();
                      },
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      //color:Colors.orange,
                      textColor: Colors.black,
                    ),
                    RaisedButton.icon(
                      label:Text('       '+'Undo'+'         ',style: TextStyle(fontSize: 15, color: Colors.black)),
                      color: Colors.orange,
                      icon: Icon(Icons.undo),
                      onPressed: emptyQueueFlag ? null:_undoClick,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(Radius.circular(10.0))),
                      //color:Colors.orange,
                      textColor: Colors.black,
                      //enabled: false,
                    ),
                  ]
              )
          ]
        )
      ),

      Container(
          alignment:Alignment.center,
          width: 410,
          padding: EdgeInsets.all(5),
          margin: EdgeInsets.all(5),
          decoration: BoxDecoration(
              color: Colors.grey,
              backgroundBlendMode: BlendMode.modulate,
              border: Border.all(color: Colors.black12,
                width:3.0,
              ),
              borderRadius: BorderRadius.circular(10),
              boxShadow: [BoxShadow(
                offset: Offset(0,-2),
                blurRadius: 30,
                color: Colors.black.withOpacity(0.16),
              )]
          ),
          //padding: EdgeInsets.all(10),
          child:ScoreTable(
            previousSets: previousSetsScores,
            t1Score: t1.getScore(),
            t2Score: t2.getScore(),
            numberOfSets: mpg,
          )
      )
    ]
    )
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

//class Set {
//  int t1FinalScore;
//  int t2FinalScore;
//  int setNumber;
//
//  // Constructor
//  Set(this.setNumber);
//
//  void setFinalScore(int t1Score, int t2Score){
//    t1FinalScore = t1Score;
//    t2FinalScore = t2Score;
//  }
//  int getT1FinalScore(){
//    return t1FinalScore;
//  }
//  int getT2FinalScore(){
//    return t2FinalScore;
//  }
//  int getSetNumber(){
//    return setNumber;
//  }
//}

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
  void setScore(int s){
    score = s;
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

class StackItem{

  //t1_score: , t2_score:, SERVE:, getCurrentServingPlayer():
  Team t1;
  Team t2;
  Player p1;
  Player p2;
  Player p3;
  Player p4;

  StackItem(t1, t2, p1, p2,p3,p4){
    this.t1=t1;
    this.t2=t2;
    this.p1=p1;
    this.p2=p2;
    this.p3=p3;
    this.p4=p4;
  }
  int getT1Score(){
    return t1.getScore();
  }
  int getT2Score(){
    return t2.getScore();
  }
  int getTeamServe(){
    return Team.SERVE;
  }

  Player getCurrentServingPlayer(){
    if(p1.isServe()){
      return p1;
    } else{
      if(p2.isServe()){
        return p2;
      }else {
        if(p3.isServe()){
          return p3;
        } else return p4;
      }
    }
  }

}