import 'package:flutter/material.dart';
import '../../firestore/firestore.dart';
import '../functinos.dart';
import 'dart:convert';

class JoinRoom extends StatefulWidget {
  String name;
  var room;
  JoinRoom({Key? key, required this.room, required this.name}) : super(key: key);
  @override
  State<JoinRoom> createState() => _JoinRoom();
}

class _JoinRoom extends State<JoinRoom> {
  final TextEditingController key =TextEditingController();
  var fb = Fb();
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 101, 93),
          title: Text(
            '已經在 ${widget.room.length} 個事件中',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height / 12,),
                Center(
                  child: Text(
                    '加入事件',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 101, 93),
                      fontSize: 45,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Center(
                  child: Text(
                    '事件鑰匙',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 101, 93),
                      fontSize: 25,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 20,),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: key,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(
                            color: Colors.grey,
                            width: 2.0
                        ),
                        borderRadius: BorderRadius.circular(30),
                      ),
                      prefixIcon: const Icon(
                        Icons.drive_file_rename_outline,
                        color: Colors.black,
                      ),
                      hintText: 'key',
                      hintStyle: const TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),

                SizedBox(height: MediaQuery.of(context).size.height / 15,),
                Hero(
                  tag: 'join',
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10
                    ),
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                      child: Text('加入!', style: TextStyle(fontSize: 30),),
                    ),
                    onPressed: () async {
                      key.text = key.text.replaceAll(' ', '');
                      if(!checkNotValid(string: key.text)){
                        if(key.text == ''){
                          var snackBar = SnackBar(
                            duration: Duration(seconds: 3),
                            content: const Text('需要鑰匙才能加入~'),
                            backgroundColor: Color.fromARGB(255, 0, 101, 93),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{ //typed name
                          fb.gett(col: 'RoomInfo', doc: 'Rooms').then((value) async {
                            if(value.contains(key.text)){//doesnt exist such name online
                              List rooms = await fb.getPplRoom(ppl: widget.name, keyOrName: 0);
                              if(!rooms.contains(key.text)){//im not in that room yet
                                
                                doubleCheckJoinRoom(context, roomKey: key.text);



                              }else{
                                var snackBar = SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: const Text('窩已經在那個事件裡了!'),
                                  backgroundColor: Color.fromARGB(255, 0, 101, 93),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }else{
                              var snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: const Text('找不到這個事件鑰匙 :D'),
                                backgroundColor: Color.fromARGB(255, 0, 101, 93),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
                          });
                        }
                      }else{
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: const Text('含有非法字符!!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }


  doubleCheckJoinRoom(BuildContext context,{required String roomKey}) async {
    var temp = await fb.gett(col: 'RoomInfo', doc: 'Rooms', sub: roomKey, showMap: true);
    String roomName = temp['name'];
    
    var temp2 = await fb.gett(col: roomKey, doc: 'init', sub: 'event', showMap: true);
    String event = temp2['event'].toString().replaceAll(' ', '');
    print('event from pop up: ${event}');
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.18, // Change as per your requirement
        width:  MediaQuery.of(context).size.width *0.6, // Change as per your requirement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Center(
              child: Text(
                  (event == '')?"":"會連同房間 \n(名稱:${event.split('/')[0]}   鑰匙: ${event.split('<')[1]})\n一起加入!",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 41, 37),
                  )
              ),
            ),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10,
                    ),
                    child: Text('返回'),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    },
                  ),
                ),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10,
                    ),
                    child: Text('確認'),
                    onPressed: () {
                        print('join room');
                        fjoinRoom(keyy: key.text, ppll: widget.name).then((value){
                          Navigator.pop(context);
                        });
                        if(event != ''){
                          print('join event');
                          fb.getEventPpl(eventKey: event.split('/')[1]).then((eventPpl){
                            print('eventPpl : ${eventPpl}');
                            if(!eventPpl.contains(widget.name)){
                              print('join eve');
                              fjoinEvent(ekey: event.split('<')[1], ppl: widget.name);
                            }
                          });
                        }
                      Navigator.of(context).pop(true);
                    },
                  ),
                ),
              ],
            ),

          ],
        ),
      );
    }
    // Show the dialog
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder (
              borderRadius: BorderRadius.circular(32.0),
              side: BorderSide(
                width: 3,
                color: Color.fromARGB(255, 0, 101, 93),
              ),
            ),
            title: Text(
                "確定加入事件: ${roomName}?",
                textAlign: TextAlign.center,
                maxLines: 1,
                style: TextStyle(
                  fontSize: 15,
                  color: Color.fromARGB(255, 0, 101, 93),
                )
            ),
            content: setupAlertDialoadContainer(),
          );
        }
    );
  }

}