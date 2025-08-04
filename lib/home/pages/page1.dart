import 'package:flutter/material.dart';
import '../functinos.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class HomePage extends StatefulWidget {
  String name;
  HomePage({Key? key, required this.name}) : super(key: key);
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

  bool buttonPressed = false;
  double heightRate = 0.4;
  dynamic settled = {};


  Future<void> refresh({bool firstTime = false, bool ref = false})async {
    print('refresh');
    if(!firstTime){
      if(settled.length != 0){
        String forOldSettle = '';
        settled.forEach((k,v){
          if(forOldSettle != ''){
            forOldSettle = forOldSettle + '?' + k.toString() + ';' + v.toString();
          }else{
            forOldSettle = k.toString() + ';' + v.toString();
          }
        });
        fb.update(col: 'RoomInfo', doc: 'people', sub: widget.name, subsub: 'settled', value: forOldSettle.toString());
      }
      if(settled.length == 0){
        fb.update(col: 'RoomInfo', doc: 'people', sub: widget.name, subsub: 'settled', value: '');
        buttonPressed = false;
        setState(() {
          heightRate = 0.4;
          context.loaderOverlay.hide();
        });
      }else{
        buttonPressed = true;
        setState(() {
          heightRate = 0.01;
          context.loaderOverlay.hide();
        });
      }


    }else{
      await fb.gett(col: 'RoomInfo', doc: 'people', sub: widget.name, showMap: true).then((t){
        String t2 = t['settled'].replaceAll(' ', '');
        if(t2 != ''){
          settled = {};
          List n = t2.split('?');
          n.forEach((n2) {
            List n3 = n2.split(';');
            settled[n3[0]] = n3[1];
          });
        }
      });
      if(settled.length == 0){
        buttonPressed = false;
        setState(() {
          heightRate = 0.4;
          context.loaderOverlay.hide();
        });
      }else{
        buttonPressed = true;
        setState(() {
          heightRate = 0.01;
          context.loaderOverlay.hide();
        });
      }

    }

  }

  @override
  void initState() {
    refresh(firstTime: true);
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
              child: Column(
                children: [
                  SizedBox(height: MediaQuery.of(context).size.height * heightRate,),
                  Column(
                    children: [
                      Center(
                        child: Center(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: !buttonPressed?Color.fromARGB(255, 0, 101, 93):Colors.blueGrey,
                              foregroundColor: !buttonPressed?Colors.white:Colors.black,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                              elevation: 10,
                            ),
                            onPressed: () async {
                              context.loaderOverlay.show();
                              settled = await fTotSettle(pname: widget.name);
                              print(settled);
                              refresh(firstTime: false, ref: true);

                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 55, vertical: 5),
                              child: Text(!buttonPressed?'結算所有事件':'刷新', style: TextStyle(fontSize: 30),),
                            )
                          ),
                        ),
                      ),
                      SizedBox(height: 20,),
                      Visibility(
                        visible: buttonPressed,
                        child: Center(
                          child: Container(
                            height: MediaQuery.of(context).size.height *0.7,
                            child: ListView.builder(
                              itemCount: settled == null?0:settled.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                  child: Card(
                                    color: settled.keys.elementAt(index).contains('/')?
                                    settled.keys.elementAt(index).contains('!')?
                                    Colors.redAccent
                                        :
                                    Color.fromARGB(0, 124, 5, 575)
                                        :
                                      (double.parse(settled.values.elementAt(index).toString())) > 0?
                                      Colors.greenAccent
                                          :
                                      Colors.redAccent
                                    ,
                                    shape: RoundedRectangleBorder(
                                      side: BorderSide(
                                        color:  Color.fromARGB(225, 0, 43, 38),
                                      ),
                                      borderRadius: BorderRadius.circular(15.0),
                                    ),
                                    child: ListTile(
                                      leading: Icon(Icons.house),
                                      title: Text(
                                        settled.keys.elementAt(index).contains('!')?
                                          '事件: ${settled.keys.elementAt(index).split('/')[0].toString().substring(1)} 還差: ${double.parse(settled.values.elementAt(index).toString())*-1} 沒付齊'
                                          :
                                        settled.keys.elementAt(index).contains('/')?
                                          '事件: ${settled.keys.elementAt(index).split('/')[0]} 要還我: ${settled.values.elementAt(index)}'
                                          :
                                          double.parse(settled.values.elementAt(index).toString()) > 0?
                                            '人 :${settled.keys.elementAt(index)} 要還我: ${settled.values.elementAt(index)}'
                                              :
                                            '我要還 :${settled.keys.elementAt(index)} : ${(double.parse(settled.values.elementAt(index).toString())*-1).toString()}'
                                      ),
                                      subtitle: settled.keys.elementAt(index).contains('/')?
                                        Text(
                                          '鑰匙 ${(settled.keys.elementAt(index).split('/'))[1]}'
                                        ):
                                        null,
                                      onTap: () async {
                                      },
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}