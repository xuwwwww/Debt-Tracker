import 'dart:ffi';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'dart:convert';


class Fb {
  static const defaultJson = '{}';
  Future<dynamic> gett({required String col, required String doc, String? sub, bool showMap = false}) async {
    // print('---------GET-----------');
    var docRef = FirebaseFirestore.instance.collection(col).doc(doc);
    DocumentSnapshot docc = await docRef.get();
    var data = docc.data() as Map<String, dynamic>;
    if (data == null){
      print('NO SUCH DATA IN ${col} => ${doc}');
      //doc or col doesn't exists
      return null;
    }else if(sub != null){//there's a specific sub
      // print('DATA RUNNING FROM GET : ${data[sub]}');
      Map subMap = jsonDecode(data[sub] ?? defaultJson);
      if (!showMap){
        return subMap.keys.toList();//all subsubs' keys
      }else{
        return subMap;//all subsubs as json format
      }
    }else{//sub not specified
      // print('DATA RUNNING FROM GET : ${data}');
      if(!showMap){
        return data.keys.toList();
      }else{
        return data;
      }
    }
  }
  Future<dynamic> post({required String col, required String doc, required String sub, required String string}) async{
    // print('---------POST-----------');
    var docRef = FirebaseFirestore.instance.collection(col).doc(doc);
    var docc = await docRef.get();
    var data = docc.data() as Map<String, dynamic>;
    // print('DATA : ${data.runtimeType}');
    if (data == null || data.length == 0){
      // print('---------NOT DOC INSIDE-----------');
      docRef.set( {'${sub}' : '${string}'} );
    }else {
      // print('---------EXIST DOC INSIDE-----------');
      // docRef.set({sub : string}, SetOptions(merge: true));
      if (data[sub] == null){
        // print('---------IM NOT INSIDE-----------');
        data[sub] = string;
        docRef.set(data);
        return 1;
      }else{//there's a specific sub
        // print('already exists!');
        return null;
      }
    }

  }
  Future<dynamic> update({required String col, required String doc, required String sub, required String subsub, required String value}) async{
    // print('---------UPDATE-----------');
    var docRef = FirebaseFirestore.instance.collection(col).doc(doc);
    var docc = await docRef.get();
    var data = docc.data() as Map<String, dynamic>;
    if (data[sub] == null){
      print("doesn't exist, cannot update");
      return null;
    }else{//there's a specific sub
      Map subMap = jsonDecode(data[sub]);
      subMap[subsub] = value;//if need to store as a list, seperate by . (dot)
      data[sub] = subMap.toString().replaceAll(' ', '').replaceAll('{', '{"').replaceAll(':', '":"').replaceAll(',', '","').replaceAll('}', '"}');
      // print('');
      // print('NEWSUBMAP ${data}');
      docRef.set(data);
      return null;
    }
  }
  Future<dynamic> deletee({required String col, String doc = '', String sub = '', String subsub = '', String subsubsub = ''}) async {
    // print('DELETE');
    if(doc == ''){//delete collection  基本上會跑這裡就是要刪除房間啦
      // print('DELETE COLLECTION');
      await gett(col: col, doc: 'init', sub: 'ppl', showMap: true).then((value){
        if(value['ppl'] == ''){
          print('no one is in that room');
        }else{//delete every documents in collection
          List<String> pplArr = value['ppl'].split(".");
          for(String ppls in pplArr){
            deletee(col: col, doc: ppls);
          };
          deletee(col: col, doc: 'init');
        }
      });
    }else{
      if(sub == ''){//delete document
        // print('DELETE DOCUMENT');
        FirebaseFirestore.instance.collection(col).doc(doc).delete().then((doc){
          // print("Document deleted");
        },onError: (e) => print("Error deleting document $e"),
      );
    }else{
      if(subsub == ''){//delete sub
        // print('DELETE SUB');
        FirebaseFirestore.instance.collection(col).doc(doc).update({sub: FieldValue.delete()});
      }else{//delete subsub(json in string)
        if(subsubsub == ''){//delete subsub
          // print('DELETE SUBSUB');
          gett(col: col, doc: doc, sub: sub, showMap: true).then((value){
            value[subsub] = '';
            print(value);
            update(col: col, doc: doc, sub: sub, subsub: subsub, value: value[subsub]);
          });
        }else{//delete subsubsub (包含.的那個)
          // print('DELETE SUBSUBSUB');
          gett(col: col, doc: doc, sub: sub, showMap: true).then((value){
            List<String> subsubList = value[subsub].split(".");
            subsubList.removeWhere( (item) => item == subsubsub );
            String newSubsubsub = '';
            if(subsubList.length == 0){
              newSubsubsub = '';
            }else{
              subsubList.forEach((element) {
                if (newSubsubsub == ''){
                  newSubsubsub = element.toString();
                }else{
                  newSubsubsub = newSubsubsub + '.' + element.toString();
                }
              });
            }
            print(newSubsubsub);
            update(col: col, doc: doc, sub: sub, subsub: subsub, value: newSubsubsub);
          });
        }
      }
      }
    }
  }
  Future<dynamic> getPplRoom({required String ppl, required int keyOrName}) async {
    var t = await gett(col: 'RoomInfo', doc: 'people', sub: ppl, showMap: true);
    if(t['inRoom'] == ''){
      return [];
    }else{
      List<String> roomArr = t['inRoom'].split(".");
      dynamic forReturn = [];
      for(String temp in roomArr){
        if(keyOrName == 1){//name == 1
          var t = temp.split('/');
          forReturn.add(t[0]);
        }else if(keyOrName == 0){//key == 0
          var t = temp.split('/');
          forReturn.add(t[1]);
        }else if(keyOrName == 2){//both == 2
          return t['inRoom'];
        }else if(keyOrName == 3){//both by list == 3,也就是list 中list 的概念 (第一個element是名子，第二個才是key)
          var t = temp.split('/');
          forReturn.add([t[0], t[1]]);
        }
      }
      return forReturn;
    }
  }
  dynamic getRoomPpl({required String roomKey}) async {
    var t = await gett(col: roomKey, doc: 'init', sub: 'ppl', showMap: true);
    if(t['ppl'] == ''){
      return [];
    }else{
      List<String> pplArr = t['ppl'].split(".");
      return pplArr;
    }
  }
  dynamic getEventPpl({required String eventKey}) async {
    var t = await gett(col: eventKey, doc: 'init', sub: 'ppl', showMap: true);
    if(t['ppl'] == ''){
      return [];
    }else{
      List<String> pplArr = t['ppl'].split(".");
      return pplArr;
    }
  }
  dynamic getEventRoom({required String eventKey}) async {
    var t = await gett(col: '<'+eventKey, doc: 'init', sub: 'rooms', showMap: true);
    if(t['rooms'] == ''){
      return [];
    }else{
      List<String> roomArr = t['rooms'].split(".");
      return roomArr;
    }
  }
  dynamic getPplEvent({required String ppl, required int keyOrName}) async {
    var t = await gett(col: 'RoomInfo', doc: 'people', sub: ppl, showMap: true);
    if(t['event'] == ''){
      return [];
    }else{
      List<String> eventArr = t['event'].split(".");
      dynamic forReturn = [];
      for(String temp in eventArr){
        if(keyOrName == 1){//name == 1
          var t = temp.split('/');
          forReturn.add(t[0]);
        }else if(keyOrName == 0){//key == 0
          var t = temp.split('/');
          forReturn.add(t[1]);
        }else if(keyOrName == 2){//both == 2
          return t['inRoom'];
        }else if(keyOrName == 3){//both with list == 3, first with name then key
          var t = temp.split('/');
          forReturn.add([t[0], t[1]]);
        }
      }
      return forReturn;
    }
  }
  dynamic getRoomEvent({required String roomKey}) async {
    var t = await gett(col: roomKey, doc: 'init', sub: 'event', showMap: true);
    if(t['event'] == ''){
      return '';
    }else{
      return t;
    }
  }
}