import 'package:fire0205/home/functinos.dart';
import 'package:flutter/material.dart';
import '../firestore/firestore.dart';
import 'functinos.dart';
import 'dart:convert';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class InRoom extends StatefulWidget {
  String name, room, roomN;
  InRoom({Key? key, required this.room, required this.roomN, required this.name}) : super(key: key);
  @override
  State<InRoom> createState() => _InRoom();
}

class _InRoom extends State<InRoom> {
  final TextEditingController infact =TextEditingController();
  final TextEditingController paid =TextEditingController();
  var fb = Fb();
  String key = '';
  String nowintval = '0', nowpaival = '0';
  List pplList = ['沒人在這個房間~'];
  String inEvent = '', finString = '';

  Future<void> refresh() async {
    context.loaderOverlay.show();
    await fb.gett(col: key, doc: 'init', sub: 'event', showMap: true).then((value){
      print(value);
      String ori = value['event'];
      finString = '${ori.split('/')[0]}  鑰匙: ${ori.split('<')[1]}';
      print('final sring : ${finString}');
    });


    fb.getRoomPpl(roomKey: widget.room).then((value){
      pplList = value;
      context.loaderOverlay.hide();
    });

    setState(() { });
  }

  @override
  void initState() {
    // print("inroom ${widget.room}");

    context.loaderOverlay.show();
    key = widget.room;
    super.initState();
    fb.gett(col: widget.room, doc: widget.name, showMap: true).then((value) {
      Map intmap = jsonDecode(value["infact"]);
      Map paimap = jsonDecode(value["paid"]);
      nowintval = intmap["infact"];
      nowpaival = paimap["paid"];
      setState(() {context.loaderOverlay.hide();});
    });
    refresh();
  }

  bool savePressed = false;
  bool settlePressed = false;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 101, 93),
          title: Text(
            '事件 : ${widget.roomN}',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.exit_to_app),
              onPressed: () async {
                bool ifBack = false;
                ifBack = await showDialog(
                  context: context,
                  builder: (_) => QuitRoom(),
                );
                if(ifBack){
                  fquitRoom(name: widget.roomN, keyy: key, ppll: widget.name);
                  Navigator.pop(context);
                }
              },
            ),
            IconButton(
              icon: Icon(Icons.people_alt_outlined),
              onPressed: () {
                Look4Ppl(context);
                // fquitRoom(name: widget.room, keyy: key, ppll: widget.name);
              },
            ),
            IconButton(
              icon: Icon(Icons.settings),
              onPressed: () {
                setting(context);
              },
            ),
          ],
        ),
        body: LoaderOverlay(
          useDefaultLoading: false,
          overlayWidget: Center(
              child: SpinKitChasingDots(
                color: Colors.white,
                size: 50,
              )
          ),
          child: Container(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                  Center(
                    child: Text(
                      (finString != '')?'屬於房間 : ${finString}':'不屬於任何房間',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 101, 93),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height*0.04,),
                  Center(
                    child: Text(
                      'KEY : ${key}',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 101, 93),
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 20,),
                  Center(
                    child: Text(
                      '我應該付多少',
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
                      controller: infact,
                      keyboardType: TextInputType.number,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromARGB(219, 33, 152, 126),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                        prefixIcon: const Icon(
                          Icons.attach_money,
                          color: Colors.black,
                        ),
                        hintText: '目前為 : ${nowintval}',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 12,),
                  Center(
                    child: Text(
                      '我從錢包掏出了多少',
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
                      keyboardType: TextInputType.number,
                      controller: paid,
                      style: TextStyle(color: Colors.black),
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(15),
                          borderSide: BorderSide(
                            color: Color.fromARGB(219, 33, 152, 126),
                            width: 2.0,
                          ),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide(
                            color: Colors.black,
                            width: 3.0,
                          ),
                        ),
                          prefixIcon: const Icon(
                            Icons.attach_money,
                            color: Colors.black,
                          ),
                          hintText: '目前為 : ${nowpaival}',
                          hintStyle: const TextStyle(
                            color: Colors.black,
                          ),
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height / 20,),
                  Hero(
                    tag: 'join',
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: (savePressed == false)?Colors.white :Color.fromARGB(255, 0, 101, 93),
                          foregroundColor: (savePressed == false)?Color.fromARGB(255, 0, 101, 93):Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 10
                      ),
                      onPressed: () async {
                        context.loaderOverlay.show();
                        String inf = '', pai = '';
                        setState((){savePressed = true;});
                        if (infact.text.replaceAll(' ', '') != ''){
                          inf = infact.text;
                        }else{
                          inf = '-1';
                        }
                        if (paid.text.replaceAll(' ', '') != ''){
                          pai = paid.text;
                        }else{
                          pai = '-1';
                        }
                        if(inf != '-1'){
                          await fb.update(col: widget.room, doc: widget.name, sub: "infact", subsub: "infact", value: inf);
                        }
                        if(pai != '-1'){
                          await fb.update(col: widget.room, doc: widget.name, sub: "paid", subsub: "paid", value: pai);
                        }
                        await Future.delayed(const Duration(milliseconds: 250), (){});
                        setState((){
                          savePressed = false;
                          context.loaderOverlay.hide();
                        });
                        //
                        // Navigator.pop(context);
                      },
                      icon: Icon(Icons.save),
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                        child: Text('保存', style: TextStyle(fontSize: 30),),
                      )
                    ),
                  ),
                  SizedBox(height: 40,),
                  Hero(
                    tag: 'join2',
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: !settlePressed?Color.fromARGB(255, 0, 101, 93):Colors.white,
                          foregroundColor: !settlePressed?Colors.black:Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                          elevation: 10,
                      ),
                      onPressed: () async {
                        context.loaderOverlay.show();
                        setState((){settlePressed = true;});
                        var fin = await fsettle(rkey: widget.room, pname: widget.name);
                        print(fin);
                        if(fin.runtimeType == double){
                          var snackBar = SnackBar(
                            duration: Duration(seconds: 4),
                            content: Text(
                              '    錢不夠!!   還差 ${fin*-1} 元',
                              // textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                            ),
                            backgroundColor: Color.fromARGB(255, 0, 101, 93),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                            behavior: SnackBarBehavior.floating,
                            action: SnackBarAction(
                              label:'好啦好啦',
                              onPressed: () {
                                ScaffoldMessenger.of(context).hideCurrentSnackBar();
                              },
                              textColor: Colors.white,
                              disabledTextColor: Colors.grey,
                            ),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        }else{
                          settleM(context, fin);
                        }
                        setState((){
                          settlePressed = false;
                          context.loaderOverlay.hide();
                        });
                        // Navigator.pop(context);
                      },
                      icon: Icon(Icons.attach_money_outlined),
                      label: Container(
                        padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                        child: Text('結算', style: TextStyle(fontSize: 30),),
                      )
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
                            '${(pplList[index] != widget.name)?pplList[index] : '${pplList[index]} (我)'}',
                            textAlign: TextAlign.center,
                          ),
                          // subtitle: Text('${listItems[index].price}'),
                          onTap: () async {
                            if(pplList[index] != widget.name){
                              thatPpl(context, pplList[index]);
                            }else{
                              var snackBar = SnackBar(
                                duration: Duration(seconds: 3),
                                content: const Text(
                                  '這是你!!',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                                ),
                                backgroundColor: Color.fromARGB(255, 0, 101, 93),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                behavior: SnackBarBehavior.floating,
                              );
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            }
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
                "事件的人類們",
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

  settleM(BuildContext context, var finlist) {
    List printList = [];
    if(finlist.length == 0){
      printList.add('你付的錢剛剛好~');
    }else{
      finlist.keys.forEach((ppl) {
        if(ppl == 'tot'){
          if(finlist[ppl] == 0){
            printList.add('你付的錢剛剛好~');
          }else{
            printList.add('這次找的錢要還我 : \n${finlist[ppl]} 元');
          }

        }else{
          if(finlist[ppl] > 0){
            printList.add('這個人=> ${ppl} 要還我 : \n${finlist[ppl]} 元');
          }else if(finlist[ppl] < 0){
            printList.add('我要還這個人=> ${ppl} : \n${double.parse(finlist[ppl].toString())*-1} 元');
          }else{
            printList.add('你付的錢剛剛好~');
          }
        }
      });
    }
    
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.3, // Change as per your requirement
        width:  MediaQuery.of(context).size.width *0.7, // Change as per your requirement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              height:  MediaQuery.of(context).size.height *0.22,
              // width: MediaQuery.of(context).size.width *0.68,
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
                  itemCount: printList.length,
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
                          leading: Icon(Icons.attach_money),
                          title: Text('${printList[index]}'),
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
                "算錢了~",
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

  thatPpl(BuildContext context, String pname) async {
    dynamic pp = await fb.gett(col: widget.room, doc: pname, sub: 'paid', showMap: true);
    dynamic pi = await fb.gett(col: widget.room, doc: pname, sub: 'infact', showMap: true);
    pp = pp['paid'];
    pi = pi['infact'];
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
                  "他付了: ${pp} 元",
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  style: TextStyle(
                    fontSize: 15,
                    color: Color.fromARGB(255, 0, 41, 37),
                  )
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                  "他應該要付: ${pi} 元",
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
                "${pname}  的錢錢概況",
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

  setting(BuildContext context) {
    final TextEditingController newRoomName =TextEditingController();
    Widget setupAlertDialoadContainer() {
      return Container(
        height:  MediaQuery.of(context).size.height *0.2, // Change as per your requirement
        width:  MediaQuery.of(context).size.width *0.8, // Change as per your requirement
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Container(
              child: Container(
                height: 50,
                padding: EdgeInsets.symmetric(horizontal: 50),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.white,
                ),
                child: TextField(
                  controller: newRoomName,
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
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
                    hintText: '改名',
                    hintStyle: const TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              child:  Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: MediaQuery.of(context).size.width *0.32,
                    child: ElevatedButton(
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
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width *0.32,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Color.fromARGB(255, 0, 101, 93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                        elevation: 10,
                      ),
                      child: const Text('確認'),
                      onPressed: () async {
                        List vv = [];
                        String upString = '';
                        newRoomName.text = newRoomName.text.replaceAll(' ', '');
                        if(!checkNotValid(string: newRoomName.text)){
                          if(newRoomName.text != ''){
                            fb.update(col: 'RoomInfo', doc: 'Rooms', sub: widget.room, subsub: 'name', value: newRoomName.text);

                            var roomPpl = await fb.getRoomPpl(roomKey: widget.room);

                            for(String name in roomPpl){
                              vv = [];
                              upString = '';
                              await fb.getPplRoom(ppl: name, keyOrName: 2).then((element){
                                vv = element.split('.');
                                String rx = '';
                                for(var x in vv){
                                  if(x == (widget.roomN+'/'+widget.room)){
                                    rx = x;
                                  }
                                }
                                vv.remove(rx);
                                // vv.removeWhere((item) => item== (widget.roomN+'/'+widget.room).toString());
                                vv.add(newRoomName.text+'/'+widget.room);
                              });
                              for(String a in vv){
                                if(upString == ''){
                                  upString = a;
                                }else{
                                  upString += '.'+a;
                                }
                              }
                              // print('upString = ${upString} ppl :${name}');
                              fb.update(col: 'RoomInfo', doc: 'people', sub: name, subsub: 'inRoom', value: upString);
                            }
                            // Navigator.of(context).pop();
                          }else{
                            var snackBar = SnackBar(
                              duration: Duration(seconds: 4),
                              content: Text(
                                '不是說要改名ㄇ怎麼沒輸入~',
                                // textAlign: TextAlign.center,
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                              ),
                              backgroundColor: Color.fromARGB(255, 0, 101, 93),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                              behavior: SnackBarBehavior.floating,
                            );
                            ScaffoldMessenger.of(context).showSnackBar(snackBar);
                          }
                        }else{
                          var snackBar = SnackBar(
                            duration: Duration(seconds: 4),
                            content: Text(
                              '含有非法字符!!',
                              // textAlign: TextAlign.center,
                              style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),
                            ),
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
                "更改事件資訊",
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


class QuitRoom extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _QuitRoom();
}

class _QuitRoom extends State<QuitRoom> with SingleTickerProviderStateMixin {

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
            child: IntrinsicHeight(
              child: Container(
                width: MediaQuery.of(context).size.width*0.85,
                height: MediaQuery.of(context).size.height*0.2,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 50),
                      child: Text("真的要退出事件ㄇ?"),
                    ),
                    IntrinsicHeight(
                      child:  Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(width: 30,),
                          Expanded(
                            child: ElevatedButton(
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
                          ),
                          SizedBox(width: 30,),
                          Expanded(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Color.fromARGB(255, 0, 101, 93),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              ),
                              child: const Text('確認'),
                              onPressed: () {
                                Navigator.of(context).pop(true);
                              },
                            ),
                          ),
                          SizedBox(width: 30,),
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
