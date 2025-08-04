import 'package:flutter/material.dart';
import '../../firestore/firestore.dart';
import '../functinos.dart';
import 'dart:convert';

class AddRoom extends StatefulWidget {
  String name;
  var room;
  String eventName, eventKey;
  AddRoom({Key? key, required this.room, required this.name, required this.eventName, required this.eventKey}) : super(key: key);
  @override
  State<AddRoom> createState() => _AddRoom();
}

class _AddRoom extends State<AddRoom> {
  final TextEditingController rname =TextEditingController();
  final TextEditingController key =TextEditingController();
  var fb = Fb();
  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 0, 101, 93),
        title: Text(
          (widget.eventKey == '')?'已經在 ${widget.room.length} 個事件中':'正在房間: ${widget.eventName}中創立事件',
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
                  '創立事件',
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
                  '事件名稱',
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
                  controller: rname,
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
                    hintText: '隨便你取~~',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 12,),
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
              SizedBox(height: 15,),
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
                      Icons.lock,
                      color: Colors.black,
                    ),
                    hintText: '每個鑰匙不會重複~',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height / 15,),
              Hero(
                tag: 'join1',
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10
                  ),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                    child: Text('創立!', style: TextStyle(fontSize: 30),),
                  ),
                  onPressed: () async {
                    rname.text = rname.text.replaceAll(' ', '');
                    key.text = key.text.replaceAll(' ', '');
                    if(!checkNotValid(string: rname.text) && !checkNotValid(string: key.text)){//valid
                      if(rname.text == '' || key.text == ''){
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: const Text('事件或鑰匙要個有名子!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{ //typed name
                        List inRoomNames = await fb.getPplRoom(ppl: widget.name, keyOrName: 0);//getting key
                        fb.gett(col: 'RoomInfo', doc: 'Rooms').then((value) async {
                          if(!value.contains(key.text)){//doesnt exist such name online
                            if(!inRoomNames.contains(key.text)){//im not in that room yet (with room key)
                              fcreateRoom(name : rname.text, keyy: key.text, ppll: widget.name).then((value) async {

                                if(widget.eventKey != ''){
                                  await fJoinRoomToEvent(ename: widget.eventName, ekey: widget.eventKey, ppl: widget.name, rooms: [[rname.text, key.text]]);
                                }

                                Navigator.pop(context);
                              });


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
                              content: const Text('看來有人比你早註冊這個鑰匙 QQ'),
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
                        content: const Text('含有非法字符!'),
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
    );
  }
}