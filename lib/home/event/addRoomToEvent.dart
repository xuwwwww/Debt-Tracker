import 'package:flutter/material.dart';
import 'package:loader_overlay/loader_overlay.dart';
import '../../firestore/firestore.dart';
import '../functinos.dart';
import 'dart:convert';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:multi_select_flutter/multi_select_flutter.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'dart:io';
class ChosonRoom {
  final String name;
  final String key;
  ChosonRoom({required this.name, required this.key});
}


class AddRoomToEvent extends StatefulWidget {
  String pplName, eventKey, eventName;
  var alreadyInRoomList;
  AddRoomToEvent({Key? key, required this.eventKey, required this.eventName, required this.pplName, required this.alreadyInRoomList, }) : super(key: key);
  @override
  State<AddRoomToEvent> createState() => _AddRoomToEvent();
}

class _AddRoomToEvent extends State<AddRoomToEvent> {
  var fb = Fb();
  List alreadyInRoomListKey = [];
  String showExists = '';
  static List<ChosonRoom> _chosonRoom = [];
  var _items = _chosonRoom.map((chosenRoom) => MultiSelectItem<ChosonRoom>(chosenRoom, chosenRoom.name)).toList();
  List<dynamic> _selectedRoom = [];
  Future<void> refresh()async {
    print('run refresh');
    setState(() {
      print('finish refresh');
    });
  }



  @override
  void initState() {//我還要寫從getpplroom把房間抓過來並且顯示，重複的就不顯示
    context.loaderOverlay.show();
    print('in add rooms to event getting rooms (for check if im already in) ${widget.alreadyInRoomList.toString()}');
    widget.alreadyInRoomList.forEach((element){
      alreadyInRoomListKey.add(element[1]);
      showExists == ''?showExists = '事件: ${element[0]} / 鑰匙: ${element[1]}':showExists += '，事件: ${element[0]} / 鑰匙:${element[1]}';
    });
    if(_chosonRoom != null || _chosonRoom.length != 0){
      _chosonRoom.clear();
    }
    fb.getPplRoom(ppl: widget.pplName, keyOrName: 3).then((pplRooms) async {
      pplRooms.forEach((element){
        if(!alreadyInRoomListKey.contains(element[1])){
          print('add : ${element}');
          _chosonRoom.add(ChosonRoom(name: element[0], key: element[1]));
        }
      });
      print('selected room length : ${_chosonRoom.length}');
      if(_items != null){
        _items.clear();
      }
      _items = await _chosonRoom.map((chosenRoom) => MultiSelectItem<ChosonRoom>(chosenRoom, chosenRoom.name)).toList();
      context.loaderOverlay.hide();
      setState(() {});
      super.initState();
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(70.0),
          child: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 101, 93),
            title: Text(
              '房間: ${widget.eventName} / 鑰匙: ${widget.eventKey} ',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 20,
              ),
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
          ),
        ),
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                size: 50,
              )
          ),
          child: Column(
            children: [
              SizedBox(height: MediaQuery.of(context).size.height*0.1,),
              Container(
                alignment: Alignment.center,
                child: Text(
                  textAlign: TextAlign.center,
                  "以下這些事件已經在這房間中了 :\n${showExists}",
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 18,
                  ),
                )
              ),
              SizedBox(height: MediaQuery.of(context).size.height*0.01,),
              Container(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 40),
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          border: Border.all(
                            color: Color.fromARGB(255, 0, 101, 93),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: Column(
                          children: <Widget>[
                            MultiSelectBottomSheetField<dynamic>(
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    width: 2.0,
                                    color: Colors.black),
                                ),
                                color: Colors.transparent,
                              ),
                              selectedColor: Color.fromARGB(255, 0, 101, 93).withOpacity(0.5),
                              barrierColor: Colors.black.withOpacity(0.2),
                              initialChildSize: 0.5,
                              listType: MultiSelectListType.CHIP,
                              searchable: true,
                              // onSelectionChanged: ,
                              buttonText: Text(
                                "選擇要加入這個房間的事件(我在的)",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 17,
                                ),
                              ),
                              confirmText: Text(
                                "確認",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                ),
                              ),
                              cancelText: Text(
                                "取消",
                                style: TextStyle(
                                  fontSize: 17.0,
                                  color: Colors.black,
                                ),
                              ),
                              title: Text("事件"),
                              items: _items,
                              onConfirm: (values) {
                                _selectedRoom = values;
                                setState(() {});
                              },
                              chipDisplay: MultiSelectChipDisplay(
                                chipColor: Color.fromARGB(255, 0, 101, 93),
                                textStyle: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15.0,
                                    height: 1.2,
                                ),
                                icon: Icon(Icons.cancel_outlined, color: Colors.white,),
                                onTap: (value) {
                                  _selectedRoom.remove(value);
                                  setState(() {});
                                  return _selectedRoom;
                                },
                              ),
                            ),
                            _selectedRoom == null || _selectedRoom.isEmpty  ?
                            Container(
                              padding: EdgeInsets.all(10),
                              alignment: Alignment.center,
                              child: Text(
                                "選擇為空",
                                style: TextStyle(color: Colors.black54),
                              )
                            )
                            :
                            Container(
                              child:Column(
                                children: [
                                  SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                                  Container(
                                    width: MediaQuery.of(context).size.width*0.8,
                                    height: MediaQuery.of(context).size.height* 0.05,
                                    child: ElevatedButton.icon(
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.white,
                                        foregroundColor: Color.fromARGB(255, 0, 101, 93),
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(25),
                                          side: BorderSide(
                                          width: 1,
                                          color: Colors.grey
                                        )
                                      ),
                                      elevation: 10
                                      ),
                                      icon: Icon(Icons.save),
                                      label: Container(
                                        child: Text('保存', style: TextStyle(fontSize: 20),),
                                      ),
                                      onPressed: () async {
                                        context.loaderOverlay.show();
                                        print('add room to event');
                                        List<List<dynamic>> tempp = [];
                                        for(var element in _selectedRoom) {
                                          print('name : ${element.name}  key : ${element.key}');
                                          tempp.add([element.name.toString(), element.key.toString()]);
                                        };
                                        await fJoinRoomToEvent(ename: widget.eventName, ekey: widget.eventKey, ppl: widget.pplName, rooms: tempp);
                                        List allPpl = [];
                                        for(var ar in tempp){
                                          List ppl = await fb.getRoomPpl(roomKey: ar[1]);
                                          if(ppl.length != 0){
                                            ppl.forEach((element) {
                                              if(!allPpl.contains(element)){
                                                allPpl.add(element.toString());
                                              }
                                            });
                                          }else{
                                            print('error no people in this room');
                                          }
                                        };
                                        List eventPpl = await fb.getEventPpl(eventKey: widget.eventKey);
                                        List fin0 = [...allPpl, ...eventPpl];
                                        List fin1 = fin0.toSet().toList();
                                        String finstr = '';
                                        fin1.forEach((element) {
                                          finstr == ''?finstr = element:finstr += '.'+element;
                                        });
                                        print('allppl : ${fin1}');
                                        await fb.update(col: '<'+widget.eventKey, doc: 'init', sub: 'ppl', subsub: 'ppl', value: finstr);
                                        refresh();
                                        context.loaderOverlay.hide();
                                      },
                                    ),
                                  ),
                                  SizedBox(height: MediaQuery.of(context).size.height*0.02,),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}