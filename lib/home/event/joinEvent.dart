import 'package:flutter/material.dart';
import '../../firestore/firestore.dart';
import '../functinos.dart';
import 'dart:convert';

class JoinEvent extends StatefulWidget {
  String name;
  var room;
  JoinEvent({Key? key, required this.room, required this.name}) : super(key: key);
  @override
  State<JoinEvent> createState() => _JoinEvent();
}

class _JoinEvent extends State<JoinEvent> {
  final TextEditingController ekey =TextEditingController();
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
            '已經在 ${widget.room.length} 個房間中',
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
                    '加入房間',
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
                    '房間鑰匙',
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
                    controller: ekey,
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
                      ekey.text = ekey.text.replaceAll(' ', '');
                      if(!checkNotValid(string: ekey.text)){
                        if(ekey.text == ''){
                          var snackBar = SnackBar(
                            duration: Duration(seconds: 3),
                            content: const Text('需要鑰匙才能加入~'),
                            backgroundColor: Color.fromARGB(255, 0, 101, 93),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            behavior: SnackBarBehavior.floating,
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{ //typed name
                          fb.gett(col: 'RoomInfo', doc: 'events').then((value) async {
                            if(value.contains('<'+ekey.text)){//doesnt exist such name online
                              List events = await fb.getPplEvent(ppl: widget.name, keyOrName: 0);
                              if(!events.contains('<'+ekey.text)){//im not in that event yet
                                fjoinEvent(ekey: ekey.text, ppl: widget.name,).then((value){
                                  Navigator.pop(context);
                                });
                              }else{
                                var snackBar = SnackBar(
                                  duration: Duration(seconds: 3),
                                  content: const Text('窩已經在那個房間裡了!'),
                                  backgroundColor: Color.fromARGB(255, 0, 101, 93),
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                  behavior: SnackBarBehavior.floating,
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                              }
                            }else{
                              var snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: const Text('找不到這個房間鑰匙 :D'),
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
}