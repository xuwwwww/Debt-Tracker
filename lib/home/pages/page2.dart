import 'package:flutter/material.dart';
import '../inRoom.dart';
import '../../firestore/firestore.dart';
import '../room/addRoom.dart';
import '../room/joinRoom.dart';
import 'dart:convert';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import '../event.dart';
import '../functinos.dart';


class MyRoom extends StatefulWidget {
  String name, pwd;
  MyRoom({Key? key, required this.name, required this.pwd}) : super(key: key);

  @override
  State<MyRoom> createState() => _MyRoomState();
}

class _MyRoomState extends State<MyRoom> {
  var fb = Fb();
  var roomList = [];
  List roomListToEvent = [];

  Future<void> refresh()async {
    print('run refresh in my room / room');
    await fb.getPplRoom(ppl: widget.name, keyOrName: 3).then((value){
      roomList = value;

    });
    setState(() {
      print('finish refresh in my room / room');
    });
  }


  @override
  void initState() {
    super.initState();
    refresh();
  }
  @override
  Widget build(BuildContext context) {
    return LoaderOverlay(
      useDefaultLoading: false,
      overlayWidget: Center(
          child: SpinKitChasingDots(
            color: Colors.white,
            size: 50,
          )
      ),
      child: Center(
        child: Scaffold(
          body: Stack(
            children: [
              Positioned(
                bottom:0,
                left: 80,
                child: Text(
                  '操作後要下拉以更新 (我弄不好自動更新抱歉...)',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 12,
                  ),
                ),
              ),
              RefreshIndicator(
                color: Color.fromARGB(255, 1, 149, 135),
                backgroundColor: Colors.white,
                strokeWidth: 4.0,
                onRefresh: () async {
                  print('pulled down');
                  await refresh();
                  print('finish pulled down');
                },
                child: roomList.length == 0
                ?
                Center(
                  child: ListView(
                    padding: const EdgeInsets.only(top: 250),
                    children: [
                      Text(
                      '你目前沒有加入任何事件  :D',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 71, 65),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      ),
                    ],
                  ),
                )
                :
                Center(
                  child: ListView.builder(
                    itemCount: roomList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
                        child: Card(
                          color: index % 2 == 0 ? Color.fromARGB(219, 33, 152, 126)
                              : Colors.white,
                          shape: RoundedRectangleBorder(
                            side: BorderSide(
                              color:  index % 2 == 0 ? Color.fromARGB(225, 0, 43, 38) : Color.fromARGB(125, 1, 149, 135),
                            ),
                            borderRadius: BorderRadius.circular(15.0),
                          ),
                          child: ListTile(
                            leading: Icon(Icons.house),
                            title: Text('事件:  ${roomList[index][0]}'),
                            subtitle: Text('鑰匙:  ${roomList[index][1]}'),
                            onTap: () async {
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => InRoom(room: roomList[index][1], name: widget.name, roomN: roomList[index][0],))
                              );
                              print('jumped from in');
                              await refresh();
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(219, 33, 152, 126),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FloatingActionButton.extended(
                  heroTag: 'join',
                  splashColor: Color.fromARGB(219, 33, 152, 126),
                  elevation: 10,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  icon: Icon(Icons.add),
                  label: Text('   加入事件   '),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => JoinRoom(room: roomList, name: widget.name,))
                    );
                    await fb.getPplRoom(ppl: widget.name, keyOrName: 3).then((value){
                      roomList = value;
                    });
                    print('jumped from join');
                    await refresh();
                  },
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.03),
              Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(219, 33, 152, 126),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: FloatingActionButton.extended(
                  heroTag: 'join2',
                  splashColor: Color.fromARGB(219, 33, 152, 126),
                  elevation: 10,
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.black,
                  icon: Icon(Icons.add_home),
                  label: Text('   創立事件   '),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRoom(room: roomList, name: widget.name, eventName: '', eventKey: '',))
                    );
                    print('jumped from create');
                    await refresh();
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
