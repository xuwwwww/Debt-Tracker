import '../firestore/firestore.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:async/async.dart';
import 'dart:convert';

var fb = Fb();

Future<void> fcreateRoom({String name = '',String keyy = '', String ppll = ''}) async{
  print('RUN CREATE ROOM');
  String strk = '{\"name\":\"${name}\"}';
  fb.post(col: 'RoomInfo', doc: 'Rooms', sub: keyy, string: strk);
  FirebaseFirestore.instance.collection(keyy).doc(ppll).set({'infact': '{\"infact\":\"0\"}'},SetOptions(merge: true));
  FirebaseFirestore.instance.collection(keyy).doc(ppll).set({'paid': '{\"paid\":\"0\"}'},SetOptions(merge: true));
  FirebaseFirestore.instance.collection(keyy).doc('init').set({'ppl': '{\"ppl\":\"${ppll}\"}'},SetOptions(merge: true));
  FirebaseFirestore.instance.collection(keyy).doc('init').set({'event': '{\"event\":\"\"}'},SetOptions(merge: true));
  fb.gett(col: 'RoomInfo', doc: 'people', sub: ppll, showMap: true).then((value){
    String room = value['inRoom'].toString().replaceAll(' ', '');
    if(room != ''){
      room = room+'.'+name+'/'+keyy;
    }else{
      room = name+'/'+keyy;
    }
    // print('UPDATING ${room}');
    fb.update(col: 'RoomInfo', doc: 'people', sub: ppll, subsub: 'inRoom', value: room);
    return ;
  });
}
Future<void> fjoinRoom({required String keyy, required String ppll}) async{
  print('RUN JOIN ROOM');
  var r4name = await fb.gett(col: 'RoomInfo', doc: 'Rooms', sub: keyy, showMap: true);
  String name = r4name['name'];
  await fb.gett(col: 'RoomInfo', doc: 'people', sub: ppll, showMap: true).then((value){
    String room = value['inRoom'].toString().replaceAll(' ', '');
    if(room != ''){
      room = room+'.'+name+'/'+keyy;
    }else{
      room = name+'/'+keyy;
    }
    // print('UPDATING ${room}');
    fb.update(col: 'RoomInfo', doc: 'people', sub: ppll, subsub: 'inRoom', value: room);
  });
  await FirebaseFirestore.instance.collection(keyy).doc(ppll).set({'infact': '{\"infact\":\"0\"}'},SetOptions(merge: true)).then((value){
    FirebaseFirestore.instance.collection(keyy).doc(ppll).set({'paid': '{\"paid\":\"0\"}'},SetOptions(merge: true));
  });
  fb.gett(col: keyy, doc: 'init', sub: 'ppl', showMap: true).then((value) async {
    String ppls = value['ppl'].toString().replaceAll(' ', '');
    if(ppls != ''){
      ppls = ppls+'.'+ppll;
    }else{
      ppls = ppll;
    }
    // print('UPDATING ${ppls}');
    await fb.update(col: keyy, doc: 'init', sub: 'ppl', subsub: 'ppl', value: ppls);
    return null;
  });
}
Future<void> fquitRoom({String name = '',String keyy = '', String ppll = ''}) async{
  print('RUN QUIT ROOM');
  fb.deletee(col: 'RoomInfo', doc: 'people', sub: ppll, subsub: 'inRoom', subsubsub: name+'/'+keyy);
  fb.deletee(col: keyy, doc: ppll);
  fb.deletee(col: keyy, doc: 'init', sub: 'ppl', subsub: 'ppl', subsubsub: ppll);
}
Future<dynamic> fsettle({String rkey = '',String pname = '', bool totSettle = false, String roomName = ''}) async{
  // print('RUN SETTLE');
  double paid = 0, actualltNeed = 0, people = 0;
  String stillRemain = '';
  Map dict = {}, checkDict = {}, me = {};
  List ppls = await fb.getRoomPpl(roomKey: rkey);
  if(ppls != '沒人'){
    for(String ppl in ppls){
      var chechpplexist = await fb.gett(col: rkey, doc: ppl, sub: 'paid', showMap: true);
      var chechpplexist2 = await fb.gett(col: rkey, doc: ppl, sub: 'infact', showMap: true);
      if(chechpplexist != null && chechpplexist2 != null){
        double p = double.parse(chechpplexist['paid'].toString());
        double i = double.parse(chechpplexist2['infact'].toString());
        paid += p;
        actualltNeed += i;
        dict[ppl] = p - i;
        checkDict[ppl] = -1;
        people += 1;
      }
    }
    double remain = paid - actualltNeed;
    // print('');
    // print('dict: ${dict}');
    // print('checkDict: ${checkDict}');
    // print('stillRemain: ${stillRemain}');
    // print('me: ${me}');
    // print('remain: ${remain}');

    if(remain < 0){
      print('錢未付齊');
      return (!totSettle)?remain:{'!${roomName}': remain};
    }
    dict.keys.forEach((ppl) {
      if(remain >= 0){
        if(dict[ppl] >= 0 && (remain - dict[ppl]) >= 0){
          if(ppl == pname){
            me['tot'] = dict[ppl];
          }
          remain -= dict[ppl];
          checkDict[ppl] = 1;
          dict[ppl] = 0;
        }else if(dict[ppl] < 0){
          checkDict[ppl] = 2;
        }else if((remain - dict[ppl]) < 0){
          checkDict[ppl] = 3;
        }
      }
    });
    // print('');
    // print('dict: ${dict}');
    // print('checkDict: ${checkDict}');
    // print('stillRemain: ${stillRemain}');
    // print('me: ${me}');
    // print('remain: ${remain}');
    dict.keys.forEach((ppl) {
     if(checkDict[ppl] == 3){
       if(ppl == pname){
         if(remain == 0){
           me.remove('tot');
         }else{
           me['tot'] = remain;
         }

       }
       dict[ppl] -= remain;
       remain = 0;
       stillRemain = ppl;
     }
    });
    // print('');
    // print('dict: ${dict}');
    // print('checkDict: ${checkDict}');
    // print('stillRemain: ${stillRemain}');
    // print('me: ${me}');
    // print('remain: ${remain}');
    dict.keys.forEach((ppl) {
     if(dict[ppl] < 0){
       if(ppl == pname){
         me[stillRemain] = dict[ppl];
       }
       if(pname == stillRemain){
         me[ppl] = dict[ppl] * -1;
       }
     }
    });
    // print('');
    // print('dict: ${dict}');
    // print('checkDict: ${checkDict}');
    // print('stillRemain: ${stillRemain}');
    // print('me: ${me}');
    // print('remain: ${remain}');
    return me;

  }else{
    return null;
  }
}
Future<dynamic> fTotSettle({required String pname, List? events = null}) async {//list is for keys//event = name+key
  Map totPplSettle = {};
  Map fin = {};
  if(events == null){
    print('RUN TOTAL SETTLE WITHOUT ROOMS');
    var keyss = await fb.getPplRoom(ppl: pname, keyOrName: 3);
    for(List key in keyss){
      var settles = await fsettle(rkey: key[1], pname: pname, totSettle: true, roomName: '${key[0]}/${key[1]}');
      for(int i = 0; i < settles.length; i++){
        var keys = settles.keys.elementAt(i);
        var value = settles.values.elementAt(i);
        if(keys == 'tot'){
          totPplSettle[key[0]+'/'+key[1]] = value;
        }else{
          if(totPplSettle[keys] == null){
            totPplSettle[keys] =  value;
          }else{
            totPplSettle[keys] += value;
          }
        };
      }
    }
    return totPplSettle;
  }else{
    print('RUN TOTAL SETTLE WITH EVENT');
    List keyss = await fb.getEventRoom(eventKey: events[1].toString().substring(1));
    List temp = [];
    keyss.forEach((element) {
      temp.add([element.split('/')[0], element.split('/')[1]]);
    });
    for(List key in temp){
      print('getting settle');
      var settles = await fsettle(rkey: key[1], pname: pname, totSettle: true, roomName: key[0]);
      print('got settlements : ${settles}');
      for(int i = 0; i < settles.length; i++){
        var keys = settles.keys.elementAt(i);
        var value = settles.values.elementAt(i);
        if(keys == 'tot'){
          totPplSettle[key[0]+'/'+key[1]] = value;
        }else{
          if(totPplSettle[keys] == null){
            totPplSettle[keys] =  value;
          }else{
            totPplSettle[keys] += value;
          }
        };
      }
    }
    // print(totPplSettle);
    return totPplSettle;
  }
  // print('finish');
}
Future<void> fcreateEvent({required String ename, required ekey , required String ppl , List? rkeys}) async {
  print('RUN CREATE EVENT');
  String rooms = '';
  rkeys?.forEach((v) {
    (rooms == '')?rooms = v: rooms += '/'+v;
  });
  fb.post(col: 'RoomInfo', doc: 'events', sub: '<'+ekey, string: '{\"ename\":\"${ename}\"}');
  FirebaseFirestore.instance.collection('<'+ekey).doc('init').set({'rooms': '{\"rooms\":\"${rooms}\"}'},SetOptions(merge: true)).then((value){
    FirebaseFirestore.instance.collection('<'+ekey).doc('init').set({'ppl': '{\"ppl\":\"${ppl}\"}'},SetOptions(merge: true));
  });
  fb.gett(col: 'RoomInfo', doc: 'people', sub: ppl, showMap: true).then((value){
    String event = value['event'].toString().replaceAll(' ', '');
    if(event != ''){
      event += '.'+ename+'/<'+ekey;
    }else{
      event = ename+'/<'+ekey;
    }
    fb.update(col: 'RoomInfo', doc: 'people', sub: ppl, subsub: 'event', value: event);
    return ;
  });
}
Future<dynamic> fjoinEvent({required ekey , required String ppl , List? rkeys}) async {//list is for keys
  print('RUN JOIN EVENT');
  var e4name = await fb.gett(col: 'RoomInfo', doc: 'events', sub: '<'+ekey, showMap: true);
  String ename = e4name['ename'];
  await fb.gett(col: 'RoomInfo', doc: 'people', sub: ppl, showMap: true).then((value){
    String event = value['event'].toString().replaceAll(' ', '');
    if(event != ''){
      event += '.'+ename+'/<'+ekey;
    }else{
      event = ename+'/<'+ekey;
    }
    fb.update(col: 'RoomInfo', doc: 'people', sub: ppl, subsub: 'event', value: event);
  });
  fb.gett(col: '<'+ekey, doc: 'init', sub: 'ppl', showMap: true).then((value){
    String ppls = value['ppl'].toString().replaceAll(' ', '');
    if(ppls != ''){
      ppls = ppls+'.'+ppl;
    }else{
      ppls = ppl;
    }
    fb.update(col: '<'+ekey, doc: 'init', sub: 'ppl', subsub: 'ppl', value: ppls);
  });
}
Future<dynamic> fquitEvent({required String ename, required String ekey, required String ppl}) async {//list is for keys
  ekey = '<'+ekey;
  print('RUN PEOPLE QUIT EVENT, people:${ppl}/ quiting event ${ename} key : ${ekey}');

  await fb.deletee(col: 'RoomInfo', doc: 'people', sub: ppl, subsub: 'event', subsubsub: ename+'/'+ekey);
  await fb.deletee(col: ekey, doc: 'init', sub: 'ppl', subsub: 'ppl', subsubsub: ppl);
}
Future<void> fJoinRoomToEvent({required String ename, required ekey , required String ppl , required List<List> rooms}) async {
  print('RUN JOIN ROOM TO EVENT');
  String roomString = '';//rooms = name/key.name2/key2..，但是傳進來時是[[name,key]]的形式
  var roomStringRaw = await fb.gett(col: '<'+ekey.toString(), doc: 'init', sub: 'rooms', showMap: true);
  roomString = roomStringRaw['rooms'].toString();
  for(var v in rooms){
    var roomEvent = await fb.getRoomEvent(roomKey: v[1].toString());
    print(roomEvent);
    if(roomEvent == ''){
      print("nothing in room's event");
      fb.update(col: v[1], doc: 'init', sub: 'event', subsub: 'event', value: ename+'/<'+ekey);
      (roomString == '')?roomString = v[0].toString()+'/'+v[1].toString(): roomString += '.'+v[0].toString()+'/'+v[1].toString();
    }else{
      print('error !! ${v} 房間只能存在於一個事件中  already exists ${roomEvent}');
    }
  };
  if(roomString != ''){
    print('rooms in event need to join ${roomString}');
    fb.update(col: '<'+ekey, doc: 'init', sub: 'rooms', subsub: 'rooms', value: roomString);
  }
}
Future<void> fRoomQuitEvent({required String ename, required String ekey, required String rname, required String rkey}) async {//list is for keys
  print('RUN ROOM QUIT EVENT');
  fb.deletee(col: '<'+ekey, doc: 'init', sub: 'rooms', subsub: 'rooms', subsubsub: rname+'/'+rkey);
  fb.deletee(col: rkey, doc: 'init', sub: 'event', subsub: 'event');
}
bool checkNotValid({required String string, bool forMail = false}){
  List inValid;
  if(forMail){
    inValid =  ['{', '}', '(', ')', '[', ']',];
  }else{
    inValid =  ['/', '\"', ',', ':', ' ', '.', 'name', 'pwd', 'mail', 'inRoom', '\\', 'settled', '{', '}', '(', ')', '[', ']', '+', '-', '*', '|', '||', '\$', '%', 'friend', 'event', '<'];
  }
  bool q = false;
  inValid.forEach((element) {
    if(string.contains(element)){
      q = true;
    };
  });
  return q;
}

