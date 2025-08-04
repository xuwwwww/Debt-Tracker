import 'package:flutter/material.dart';
import 'functinos.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class EventSettle extends StatefulWidget {
  String pplName;
  EventSettle({Key? key, required this.pplName}) : super(key: key);
  @override
  State<EventSettle> createState() => _EventSettle();
}

class _EventSettle extends State<EventSettle> {

  dynamic settled = {};
  List eventList = [];

  Future<void> refresh()async {
    print('refresh in tot event ');
    eventList = await fb.getPplEvent(ppl: widget.pplName, keyOrName: 3);
    setState(() {});
  }

  @override
  void initState() {
    refresh().then((value) => super.initState());
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
                  Container(
                    alignment: Alignment.center,
                    height: MediaQuery.of(context).size.height*0.1,
                    child: Text(
                      '點擊該房間來結算裡面的事件',
                      style: TextStyle(
                        color: Color.fromARGB(255, 0, 71, 65),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height,
                    child: ListView.builder(
                      itemCount: eventList.length,
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
                              title: Text('房間名稱 : ${eventList[index][0]}'),
                              subtitle: Text('鑰匙 : ${eventList[index][1].toString().substring(1)}'),
                              onTap: () async {
                                print('pressed settle this ${eventList[index]}');
                                await showDialog(
                                  context: context,
                                  builder: (_) => SettleEventPop(eventName: eventList[index][0], eventKey: eventList[index][1], pplName: widget.pplName,),
                                );
                                setState(() {});
                              },
                            ),
                          ),
                        );
                      },
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
}


class SettleEventPop extends StatefulWidget {
  SettleEventPop({Key? key, required this.eventName, required this.eventKey, required this.pplName}) : super(key: key);
  String eventName, eventKey, pplName;
  @override
  // State<StatefulWidget> createState() => _QuitEventPop();
  State<SettleEventPop> createState() => _SettleEventPop();
}

class _SettleEventPop extends State<SettleEventPop> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  late Animation<double> scaleAnimation;

  dynamic settled = {};
  bool finishSettled = false;

  Future<void> refresh()async {
    print('refresh in pop up');
    settled = await fTotSettle(pname: widget.pplName, events: [widget.eventName, widget.eventKey]);
    print("finsih getting this event's settlement");
    print(settled);
    setState(() {finishSettled = true;});

  }


  @override
  void initState() {
    refresh();
    super.initState();
    controller =  AnimationController(vsync: this, duration: Duration(milliseconds: 400));
    scaleAnimation =  CurvedAnimation(parent: controller, curve: Curves.fastLinearToSlowEaseIn);

    controller.addListener(() {
      setState(() {});
    });

    controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Center(
        child: Material(
          color: Colors.transparent,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: LoaderOverlay(
              useDefaultLoading: false,
              overlayWidget: Center(
                  child: SpinKitChasingDots(
                    color: Colors.white,
                    size: 50,
                  )
              ),
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
                    width: MediaQuery.of(context).size.width*0.9,
                    height: MediaQuery.of(context).size.height*0.8,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 10),
                          child: Text(
                            "房間: ${widget.eventName}",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 17,
                            ),
                          ),
                        ),
                        Expanded(
                          child: Container(
                            margin: EdgeInsets.only(top: 20, bottom: 20),
                            alignment: Alignment.topCenter,
                            width: double.infinity,
                            child: (settled.length != 0)?ListView.builder(
                              itemCount: settled == null?0:settled.length,
                              itemBuilder: (context, index) {
                                return Padding(
                                  padding: const EdgeInsets.only(left: 15, right: 15, top: 5),
                                  child: Card(
                                    color: settled.keys.elementAt(index).contains('/')?Color.fromARGB(0, 124, 5, 575):
                                    (double.parse(settled.values.elementAt(index).toString())) > 0?
                                    Colors.greenAccent
                                    :
                                    Colors.redAccent,
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
                                        '事件: ${settled.keys.elementAt(index).substring(1)} 還差: ${(double.parse(settled.values.elementAt(index).toString())*-1).toString()} 沒付齊!'
                                          :
                                      settled.keys.elementAt(index).contains('/')?
                                        '事件: ${settled.keys.elementAt(index).split('/')[0]} 要還我: ${settled.values.elementAt(index)}'
                                          :
                                      (double.parse(settled.values.elementAt(index).toString())) > 0?
                                        '人 :${settled.keys.elementAt(index)} 要還我: ${settled.values.elementAt(index)}'
                                          :
                                        '我要還: ${settled.keys.elementAt(index)} : ${(double.parse(settled.values.elementAt(index).toString())*-1).toString()}'
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
                            )
                            :
                            Center(
                              child: Text(
                                (!finishSettled)?"......LOADING......":"這個房間中沒有事件!",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 30,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(bottom: 15),
                          width: MediaQuery.of(context).size.width*0.75,
                          height: MediaQuery.of(context).size.height*0.07,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Color.fromARGB(255, 0, 101, 93),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                                side: BorderSide(
                                  width: 2,
                                  color: Colors.grey,
                                )
                              ),
                              elevation: 10
                            ),
                            child: Text('返回'),
                            onPressed: () async {
                              Navigator.of(context).pop();
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
