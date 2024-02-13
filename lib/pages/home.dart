import 'dart:math';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int scores =0;
  final Map<String, bool> score = {};
  final Map<String, Color> choices = {
    '🍎': Colors.red,  //emoji พวกนี้เป็นรหัสแอสกี้ เข้าemojipedia ค้นหาแล้วจะได้รหัสมา
    '🥒': Colors.green,
    '🔵': Colors.blue,
    '🍍': Colors.yellow,
    '🍊': Colors.orange,
    '🍇': Colors.purple,
    '🥥': Colors.brown,
  };
  int index = 0;
  
  final play = AudioPlayer();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('scores = $scores'),
        ),
        body: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: choices.keys.map((element) {
                return Expanded(
                  child: Draggable<String>(
                    data: element,
                    child: Movable(element),
                    feedback: Movable(element),
                    childWhenDragging: Movable('🐰'),//กระต่ายคือรหัสแอสกี้
                  ),
                );
              }).toList(),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: choices.keys.map((element) {
                return buildTarget(element);
              }).toList()
                ..shuffle(Random(index)),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
            child: Icon(Icons.refresh),
            onPressed: () {
              setState(() {
                score.clear();
                scores=0;
                index++;
              });
            }));
  }

  Widget buildTarget(emoji) {
    return DragTarget<String>(
      builder: (context, incoming, rejects) {
        if (score[emoji] == true) {  //ถ้า emoji ถูกต้องจะขึ้น Congratulations
          return Container(
            color: Colors.white,
            child: Text('Congratulations'),
            alignment: Alignment.center,
            height: 80,
            width: 200,
          );
        } else {
          return Container(
            color: choices[emoji],
            height: 80,
            width: 200,
          );
        }
      },
      onWillAccept: (data) => data == emoji,
      onAccept: (data) {
        setState(() {
          score[emoji] = true;
          play.play(AssetSource('clap.mp3'));
          scores++;
        });
      },
      onLeave: (data) {},
    );
  }
}

class Movable extends StatelessWidget {
  final String emoji;
  Movable(this.emoji);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: Container(
        alignment: Alignment.center,
        height: 150, //ความสูงเมื่อลากemojiต่างๆ รูปมันจะเต็มรูป
        padding: EdgeInsets.all(15),
        child: Text(
          
          emoji,
          style: TextStyle(color: Colors.black, fontSize: 60),
        ),
      ),
    );
  }
  
 
  
}