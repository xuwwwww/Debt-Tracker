import 'package:fire0205/home/event/addEvent.dart';
import 'package:flutter/material.dart';
import '../../firestore/firestore.dart';
import 'package:loader_overlay/loader_overlay.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'inEvent.dart';
import 'event/joinEvent.dart';

class MyEvent extends StatefulWidget {
  String name, pwd;

  MyEvent({Key? key, required this.name, required this.pwd}) : super(key: key);

  @override
  State<MyEvent> createState() => _MyEvent();
}

class _MyEvent extends State<MyEvent> {
  var fb = Fb();
  var eventList = [];

  Future<void> refresh()async {
    print('refreshing in my event');
    await fb.getPplEvent(ppl: widget.name, keyOrName: 3).then((value){
      eventList = value;
    });
    setState(() {print('finish refreshing in my event');});
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
                await refresh();
              },
              child: eventList.length == 0?
              Center(
                child: ListView(
                  padding: const EdgeInsets.only(top: 250),
                  children: [
                    Text(
                      '你目前沒有加入任何房間  :D',
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
                  itemCount: eventList.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.only(left: 15, right: 15, top: 2),
                      child: Card(
                        color: index % 2 == 0 ? Color.fromARGB(219, 33, 152, 126)
                            : Colors.white,
                        shape: RoundedRectangleBorder(
                          side: BorderSide(
                            color:  index % 2 == 0 ? Color.fromARGB(225, 0, 43, 38) : Color.fromARGB(
                                125, 0, 25, 24),
                            width: 2,
                          ),
                          borderRadius: BorderRadius.circular(15.0),
                        ),
                        child: ListTile(
                          leading: Icon(Icons.event_note_outlined),
                          title: Text('房間:  ${eventList[index][0]}'),
                          subtitle: Text('鑰匙:  ${eventList[index][1].toString().substring(1)}'),
                          onTap: () async {
                            await Navigator.push(
                                context,
                                MaterialPageRoute(builder: (context) => InEvent(eventKey: eventList[index][1].toString().substring(1), pplName: widget.name, eventName: eventList[index][0],))
                            );
                            print('finish from clicked event');
                            refresh();
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
                label: Text('   加入房間   '),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => JoinEvent(room: eventList, name: widget.name,))
                  );
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
                label: Text('   創立房間   '),
                onPressed: () async {
                  await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddEvent(room: eventList, name: widget.name,))
                  );
                  print('jumped from create');
                  refresh();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
