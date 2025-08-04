import 'package:fire0205/home/functinos.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import '../firestore/firestore.dart';
import 'functinos.dart';
import 'dart:convert';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'inRoom.dart';
import 'event/addRoomToEvent.dart';
import 'inRoom.dart';
import 'room/addRoom.dart';

class InEvent extends StatefulWidget {
  String pplName, eventKey, eventName;
  InEvent({Key? key, required this.eventKey, required this.eventName, required this.pplName}) : super(key: key);
  @override
  State<InEvent> createState() => _InEvent();
}

class _InEvent extends State<InEvent> with TickerProviderStateMixin{
  var fb = Fb();
  List pplList = [];
  List roomList = [];
  List roomListSplited = [];
  Future<void> refresh() async {
    print('refresh in event home');
    await fb.getEventPpl(eventKey: '<'+widget.eventKey).then((value){
      pplList = value;
      // print('pplList : ${pplList}');
    });
    fb.getEventRoom(eventKey: widget.eventKey).then((value){
      roomList = value;
      roomListSplited.clear();
      roomList.forEach((element) {
        roomListSplited.add(element.toString().split('/'));
      });
      // print("roomListSplited : ${roomListSplited}");
      
      setState(() {
        print('finish refresh in event home');
      });
    });
  }

  List<Tab> myTabs = [
    Tab(
      child: Text(
        '房間',
      ),
    ),
    Tab(
      child: Text(
        '人類們',
      ),
    ),
  ];
  late TabController _tabController;

  @override
  void initState() {
    refresh();
    _tabController = TabController(
      vsync: this,
      length: myTabs.length,
      initialIndex: 0,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 50,
            )
        ),
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: Color.fromARGB(255, 0, 101, 93),
            title: Text(
              '房間名稱 : ${widget.eventName}    鑰匙 : ${widget.eventKey}',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 15,
              ),
            ),
            toolbarHeight: MediaQuery.of(context).size.height * 0.08,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(25),
                  bottomLeft: Radius.circular(25)),
            ),
            actions: <Widget>[
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await refresh();
                },
              ),
              PopupMenuButton(
                elevation: 10,
                padding: EdgeInsets.only(right: 15),
                color: Color.fromARGB(255, 0, 101, 93),
                shape: RoundedRectangleBorder(
                  side: BorderSide(
                    color: Colors.black,
                    width: 4,
                  ),
                  borderRadius: BorderRadius.circular(10)
                ),
                itemBuilder: (context)=> [
                  PopupMenuItem<int>(
                    value: 0,
                    child:  Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.5, color: Colors.white),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon( // <-- Icon
                            Icons.exit_to_app,
                            size: 24.0,
                          ),
                          Expanded(
                            child: Text(
                              '退出房間',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(1),
                                // fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 1,
                    child:  Container(
                      height: 70,
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          bottom: BorderSide(width: 2.5, color: Colors.white),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon( // <-- Icon
                            Icons.exit_to_app,
                            size: 24.0,
                          ),
                          Expanded(
                            child: Text(
                              '把我在的事件加入這房間',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white.withOpacity(1),
                                // fontSize: 12,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  PopupMenuItem<int>(
                    value: 2,
                    child:  Container(
                      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                      decoration: BoxDecoration(
                        border: Border(
                          top: BorderSide(width: 2.5, color: Colors.white),
                        ),
                      ),
                      child: Row(
                        // mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon( // <-- Icon
                            Icons.settings,
                            size: 24.0,
                          ),
                          Expanded(
                            child: Text(
                              '改名',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
                onSelected:(value) async {
                  if(value == 0){
                    print("pressed quit event button");
                    bool ifBack = false;
                    ifBack = await showDialog(
                      context: context,
                      builder: (_) => QuitEvent(),
                    );
                    if(ifBack){
                      // print('event name : ${widget.roomN} event key ${key} people : ${widget.name}');
                      await fquitEvent(ename: widget.eventName, ekey: widget.eventKey, ppl: widget.pplName);
                      Navigator.pop(context);
                    }
                  }else if(value == 1){
                    print("pressed add rooms which I am already in to event");

                  }else if(value == 2){
                    print("pressed change name ");
                  }

                }
              ),
            ],
            bottom: TabBar(
              labelStyle: TextStyle(fontSize: 15.0),
              labelColor: Colors.black,
              unselectedLabelColor: Colors.white,
              indicatorColor: Colors.black,
              indicator: BoxDecoration(
                border: Border.all(
                  color: Color.fromARGB(255, 0, 35, 34),
                  width: 2,
                ),
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(30.0),
                  topLeft: Radius.circular(30.0),
                  bottomLeft: Radius.circular(55.0),
                  bottomRight: Radius.circular(55.0),
                ),
                color: Colors.white,
              ),
              controller: _tabController,
              tabs: myTabs,
            ),
          ),
          body: TabBarView(
            controller: _tabController,
            children: [
              EventRoom(eventKey: widget.eventKey, eventName: widget.eventName, pplName: widget.pplName, passRoomList: roomListSplited,),
              EventPpl(eventKey: widget.eventKey, eventName: widget.eventName, pplName: widget.pplName,),
            ],
          ),

        ),
      ),
    );
  }

  @deprecated
  Look4Ppl(BuildContext context) {
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.6, // Change as per your requirement
        width:  MediaQuery.of(context).size.width *0.6, // Change as per your requirement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height:  MediaQuery.of(context).size.height *0.52,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 0, 101, 93),
                    width: 3.0,
                  ),
                  top: BorderSide(
                    color: Color.fromARGB(255, 0, 101, 93),
                    width: 3.0,
                  ),
                ),
              ),
              child:  Center(
                child: ListView.builder(
                  itemCount: pplList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromARGB(125, 1, 149, 135),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            '${(pplList[index] != widget.pplName)?pplList[index] : '${pplList[index]} (我)'}',
                            textAlign: TextAlign.center,
                          ),
                          // subtitle: Text('${listItems[index].price}'),
                          onTap: () async {
                            String show = '他在以下這些房間之中';
                            if(pplList[index] == widget.pplName){
                              show = '我在以下這些房間之中';
                            }
                            thatPplInRoom(context, pplList[index], show);
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color.fromARGB(255, 0, 101, 93),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 10,
                ),
                child: const Text('返回'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
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
                )
            ),
            title: Text(
                "房間的人類們",
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

  @deprecated
  thatPplInRoom(BuildContext context, String pname, String show) async {
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
                  " ",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 41, 37),
                  )
              ),
            ),
            SizedBox(height: 20,),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Color.fromARGB(255, 0, 101, 93),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                elevation: 10,
              ),
              child: const Text('返回'),
              onPressed: () {
                Navigator.of(context).pop();
              },
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
                show,
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


class QuitEvent extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuitEvent();
}

class _QuitEvent extends State<QuitEvent> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 350));
    scaleAnimation =  CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3,
                color: Color.fromARGB(255, 0, 101, 93),
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: IntrinsicHeight(
              child: Container(
                width: 300,
                height: 150,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text("真的要退出房間ㄇ?"),
                    ),
                    IntrinsicHeight(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color.fromARGB(255, 0, 101, 93),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            child: const Text('取消'),
                            onPressed: () {
                              Navigator.of(context).pop(false);
                            },
                          ),
                          SizedBox(width: 30,),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color.fromARGB(255, 0, 101, 93),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                            ),
                            child: const Text('嘿對'),
                            onPressed: () {
                              Navigator.of(context).pop(true);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}


class EventPpl extends StatefulWidget {
  String pplName, eventKey, eventName;
  EventPpl({Key? key, required this.eventKey, required this.eventName, required this.pplName}) : super(key: key);
  @override
  State<EventPpl> createState() => _EventPpl();
}

class _EventPpl extends State<EventPpl>{
  List pplList = [];
  dynamic peopleRoomList = [];

  Map totPplRoomsList = {};


  Future<void> refresh() async {
    print('refresh in event people');
    await fb.getEventPpl(eventKey: '<'+widget.eventKey).then((value) async{
      pplList = value;
      // print('pplList getting from event people : ${pplList}');
      // print("getting people's room in event people");
      List reventRoom = await fb.getEventRoom(eventKey: widget.eventKey);
      List<List> eventRoom = [];
      for(String i in reventRoom){
        eventRoom.add([i.split('/')[0], i.split('/')[1]]);
      }
      // setState(() {print('got people from event people');});//先刷新有哪些之後再更新有哪些房間 .!我房間的順序跟人一樣\
      for(var element in value) {
        await fb.getPplRoom(ppl: element, keyOrName: 2).then((val){//value is room name list
          var valu = val.split('.');
          dynamic value = [];
          for(var i in valu){
            value.add([i.split('/')[0], i.split('/')[1]]);
          }
          print('getting people ${element}, got : ${value}');
          print(eventRoom);
          List tem = [];
          for(List i in value){
            for(List j in eventRoom){
              if(i[1] == j[1]){
               tem.add(i);
              }
            }
          }
          if(tem.length != 0){
            print('tem : ${tem}');
            peopleRoomList.add(tem);
          }
        });
      };
      print('gfsdlgf');
      print(peopleRoomList);
      for(int i  = 0; i < value.length ; i++){
        totPplRoomsList[pplList[i]] = peopleRoomList[i];
      }
      // print('map : ${totPplRoomsList}');

      setState(() {
        print('got every room from people and starting to refresh');
      });

    });
    // context.loaderOverlay.show();

  }

  @override
  void initState() {
    super.initState();
    refresh();
  }
  
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 50,
            )
        ),
        child: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.01,),
                  Center(
                    child: Text(
                      '顯示人類們',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 101, 93),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height*0.76,
                            // color: Colors.red,
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            child: ListView.builder(
                              itemCount: totPplRoomsList.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                                  child: Card(
                                    color: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color: Color.fromARGB(125, 1, 149, 135),
                                        width: 2,
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListTile(
                                      title: Text(
                                        // '${(pplList[index] != widget.pplName)?'人類: ${pplList[index]} 在房間: ': '${pplList[index]} (我) 在房間: ${peopleRoomList[index]}'}',
                                        '${(totPplRoomsList.keys.elementAt(index).toString() != widget.pplName)?
                                        '人類: ${totPplRoomsList.keys.elementAt(index).toString()} 在事件: ${totPplRoomsList.values.elementAt(index)}':
                                        '${totPplRoomsList.keys.elementAt(index).toString()} (我) 在事件: ${totPplRoomsList.values.elementAt(index)}'}',
                                        // textAlign: TextAlign.center,
                                      ),
                                      onTap: () async {
                                          print('pressed people to quit he/her');
                                          await showDialog(
                                            context: context,
                                            builder: (_) => KickPplOutOfTheRoom(pplName: totPplRoomsList.keys.elementAt(index).toString(), eventKey: widget.eventKey, eventName: widget.eventName,),
                                          );
                                          print('back to event people');
                                      }
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
 //deprecated
  @deprecated
  lookForPplInEventShowRoom(BuildContext context) {
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.6,
        width:  MediaQuery.of(context).size.width *0.6,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height:  MediaQuery.of(context).size.height *0.52,
              decoration: BoxDecoration(
                border: Border(
                  bottom: BorderSide(
                    color: Color.fromARGB(255, 0, 101, 93),
                    width: 3.0,
                  ),
                  top: BorderSide(
                    color: Color.fromARGB(255, 0, 101, 93),
                    width: 3.0,
                  ),
                ),
              ),
              child:  Center(
                child: ListView.builder(
                  itemCount: pplList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 0, right: 0, top: 5),
                      child: Card(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color: Color.fromARGB(125, 1, 149, 135),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          title: Text(
                            'show which room this people is in',
                            textAlign: TextAlign.center,
                          ),
                          // subtitle: Text('${listItems[index].price}'),
                          onTap: () async {

                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
            Container(
              child:  ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Color.fromARGB(255, 0, 101, 93),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  elevation: 10,
                ),
                child: const Text('返回'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            )
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
                )
            ),
            title: Text(
                "房間的人類們",
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

class EventRoom extends StatefulWidget {
  String pplName, eventKey, eventName;
  var passRoomList;
  EventRoom({Key? key, required this.eventKey, required this.eventName, required this.pplName, required this.passRoomList}) : super(key: key);
  @override
  State<EventRoom> createState() => _EventRoom();
}

class _EventRoom extends State<EventRoom>{
  List roomList = [];
  List roomListSplited = [];
  Future<void> refresh() async {
    print('refresh in event : room');
    // context.loaderOverlay.show();
    fb.getEventRoom(eventKey: widget.eventKey).then((value){
      roomList = value;
      roomListSplited.clear();
      context.loaderOverlay.hide();
      roomList.forEach((element) {
        roomListSplited.add(element.toString().split('/'));
      });
      roomList = roomListSplited;

      setState(() {
        context.loaderOverlay.hide();
        print('finish refresh in event : room');
      });
    });
  }

  @override
  void initState() {
    roomList = widget.passRoomList;
    // print('roomList in room page : ${roomList}');
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LoaderOverlay(
        useDefaultLoading: false,
        overlayWidget: Center(
            child: SpinKitChasingDots(
              color: Colors.white,
              size: 50,
            )
        ),
        child: Scaffold(
          body: Container(
            child: SingleChildScrollView(
              child: Container(
                color: Colors.white,
                height: MediaQuery.of(context).size.height * 0.838,
                child: RefreshIndicator(
                  color: Color.fromARGB(255, 1, 149, 135),
                  backgroundColor: Colors.white,
                  strokeWidth: 4.0,
                  onRefresh: () async {
                    print('pulled down');
                    await refresh();
                    print('finish pulled down');
                  },
                  child: Stack(
                    children: [
                      Positioned(
                        top: 10,
                        left: 0,
                        right: 0,
                        child: Center(
                          child: Text(
                            '顯示所有房間',
                            style: TextStyle(
                              color: Color.fromARGB(255, 0, 101, 93),
                              fontSize: 30,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom:10,
                        left: 80,
                        child: Text(
                          '操作後要下拉以更新 (我弄不好自動更新抱歉...)',
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      roomList.length == 0?
                      Column(
                        children: [
                          SizedBox(height: MediaQuery.of(context).size.height*0.3,),
                          Center(
                            child: Text(
                              '這個房間中沒有任何事件20  :D',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                color: Color.fromARGB(255, 0, 71, 65),
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      )
                          :
                      Positioned(
                        top: 70,
                        left: 0,
                        right: 0,
                        child: Container(
                          height:  MediaQuery.of(context).size.height * 0.72,
                          color: Colors.white,
                          child: ListView.builder(
                            itemCount: roomList.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
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
                                    title: Text('事件: ${roomList[index][0]}'),
                                    subtitle: Text('鑰匙 : ${roomList[index][1]}'),
                                    onTap: () async {
                                      print('pop up quit room from event page');
                                      bool ifBack = false;
                                      bool containsMe = false;
                                      List temp = await fb.getRoomPpl(roomKey: roomList[index][1]);
                                      if(temp.contains(widget.pplName)){
                                        containsMe = true;
                                      }
                                      ifBack = await showDialog(
                                        context: context,
                                        builder: (_) => QuitEventPop(roomName: roomList[index][0], roomKey: roomList[index][1], pplName: widget.pplName, containsMe: containsMe),
                                      );
                                      if(ifBack){
                                        print('ifBack : ${ifBack}');
                                        await fRoomQuitEvent(ename: widget.eventName, ekey: widget.eventKey, rname: roomList[index][0], rkey: roomList[index][1]);
                                        await refresh();
                                      }
                                        // Navigator.push(
                                        //     context,
                                        //     MaterialPageRoute(builder: (context) => quitThisRoom(context, widget.eventKey))
                                        // );
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
                ),
              ),
            ),
          ),
          floatingActionButton: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                height: 60,
                width: 130,
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
                  icon: Icon(Icons.add),
                  label: Text(
                    '創立事件',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRoom(room: [], name: widget.pplName, eventKey: widget.eventKey, eventName: widget.eventName,))
                    );
                    // await fb.getEventRoom(eventKey: widget.eventKey).then((value){
                    //   roomList = value;
                    // });
                    await refresh();
                  },
                ),
              ),
              SizedBox(height: 40,),
              Container(
                height: 50,
                width: 180,
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
                  label: Text(
                    '把事件加入這房間中',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AddRoomToEvent(eventKey: widget.eventKey, eventName:  widget.eventName, pplName: widget.pplName, alreadyInRoomList: roomList,))
                    );
                    // await fb.getEventRoom(eventKey: widget.eventKey).then((value){
                    //   roomList = value;
                    // });
                    await refresh();
                  },
                ),
              ),
              SizedBox(height: 30,),
            ],
          ),
        ),
      ),
    );
  }
}

class QuitEventPop extends StatefulWidget {
  QuitEventPop({Key? key, required this.roomName, required this.roomKey, required this.pplName, required this.containsMe}) : super(key: key);
  String roomName, roomKey, pplName;
  bool containsMe;
  @override
  // State<StatefulWidget> createState() => _QuitEventPop();
  State<QuitEventPop> createState() => _QuitEventPop();
}

class _QuitEventPop extends State<QuitEventPop> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =  CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3,
                color: Color.fromARGB(255, 0, 101, 93),
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: Container(
              width: MediaQuery.of(context).size.width*0.85,
              height: (!widget.containsMe)?MediaQuery.of(context).size.height*0.2:MediaQuery.of(context).size.height*0.15,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "房間: ${widget.roomName}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  ),
                  (!widget.containsMe)?Padding(
                    padding: const EdgeInsets.only(top: 20),
                    child: Text(
                      "我目前還不再這個房間 !",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 17,
                      ),
                    ),
                  )
                  :
                  Container()
                  ,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      SizedBox(width: 10,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 253, 97, 49),
                          foregroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text(
                          '把房間退出這個事件',
                          style: TextStyle(
                            color: Colors.black,
                          ),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop(true);
                        },
                      ),
                      SizedBox(width: 10,),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: (widget.containsMe)?Colors.white:Color.fromARGB(255, 0, 101, 93),
                          foregroundColor: (widget.containsMe)?Color.fromARGB(255, 0, 101, 93):Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        ),
                        child: Text((widget.containsMe)?'進入事件':'加入事件'),
                        onPressed: () async {
                          if(!widget.containsMe){
                            await fjoinRoom(keyy: widget.roomKey, ppll: widget.pplName).then((value) async {
                              print('加入了');
                              await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => InRoom(room: widget.roomKey, name: widget.pplName, roomN: widget.roomName,))
                              );
                            });
                          }else{
                            print('no 加入了');
                            await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InRoom(room: widget.roomKey, name: widget.pplName, roomN: widget.roomName,))
                            );
                          }
                          Navigator.of(context).pop(false);
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class KickPplOutOfTheRoom extends StatefulWidget {
  KickPplOutOfTheRoom({Key? key,required this.pplName, required this.eventKey, required this.eventName,}) : super(key: key);
  String pplName, eventKey, eventName;//我這裡要接受到我需要退出的事件，所以在前面就要
  // 取的了，在拿到房間名時可以用name+key的形式去取得，顯示的時候用split但是這邊接收要接收全部
  //因為我要退出房間需要key


  @override
  // State<StatefulWidget> createState() => _QuitEventPop();
  State<KickPplOutOfTheRoom> createState() => _KickPplOutOfTheRoom();
}

class _KickPplOutOfTheRoom extends State<KickPplOutOfTheRoom> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  @override
  void initState() {
    print('in kick people ');
    super.initState();

    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 200));
    scaleAnimation =  CurvedAnimation(parent: controller, curve: Curves.ease);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: ScaleTransition(
          scale: scaleAnimation,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(
                width: 3,
                color: Color.fromARGB(255, 0, 101, 93),
              ),
              borderRadius: BorderRadius.all(Radius.circular(50)),
            ),
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width*0.65,
                height: MediaQuery.of(context).size.height*0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text(
                        "把: ${widget.pplName} 踢出這個房間",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ),
                    IntrinsicHeight(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 15,),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color.fromARGB(255, 0, 101, 93),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                '取消',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                          ),
                          SizedBox(width: 10,),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color.fromARGB(255, 255, 153, 118),
                                foregroundColor: Color.fromARGB(255, 0, 101, 93),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                              ),
                              child: Text(
                                '踢出',
                                style: TextStyle(
                                  color: Colors.black,
                                ),
                              ),
                              onPressed: () async {
                                await makeSureQuit(context);
                                // await fquitEvent(ename: widget.eventName, ekey: widget.eventKey, ppl: widget.pplName);
                              },
                            ),
                          ),
                          SizedBox(width: 15,),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  makeSureQuit(BuildContext context) {
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.15,
        width:  MediaQuery.of(context).size.width *0.05,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 5),
              child: Text(
                "確定要這樣?",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                ),
              ),
            ),
            SizedBox(width: 10,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(width: 15,),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      '取消',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ),
                SizedBox(width: 10,),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 153, 118),
                      foregroundColor: Color.fromARGB(255, 0, 101, 93),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
                    ),
                    child: Text(
                      '嘿對',
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                    onPressed: () async {

                    },
                  ),
                ),
                SizedBox(width: 15,),
              ],
            ),
          ],
        ),
      );
    }



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
                )
            ),
            content: setupAlertDialoadContainer(),
          );
        }
    );
  }
}

class ChosonRoom {
  final String name;
  final String key;
  ChosonRoom({required this.name, required this.key});
}