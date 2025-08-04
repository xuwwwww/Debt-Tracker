import '../firestore/firestore.dart';
import 'dart:convert';

var fb = Fb();

Future<bool> checkLoggedIn({String name = '', String password = ''}) async{
  var ppl = await fb.gett(col: 'RoomInfo', doc: 'people', showMap: true);
  // fb.update(col: 'RoomInfo', doc: 'people', sub: 'def', subsub: 'mail', value: 'gfgf');
  // var tt = await fb.getPplRoom(ppl: name.toString());
  if (ppl.containsKey(name)){
    Map pplpwd = jsonDecode(ppl[name]);
    // fb.post(col: 'RoomInfo', doc: 'people', sub: 'my', string: 'dick');
    return (pplpwd['pwd']  == password);
  }
  return false;
}
Future<bool> checkExist({String name = ''}) async{
  var ppl = await fb.gett(col: 'RoomInfo', doc: 'people', showMap: true);
  return ppl.containsKey(name);
}
Future<void> uploadPpl({String name = '',String mail = '', String password = ''}) async{
  String str = '{\"name\":\"${name}\",\"mail\":\"${mail}\",\"pwd\":\"${password}\",\"inRoom\":\"\",\"event\":\"\",\"settled\":\"\"}';
  var ppl = await fb.post(col: 'RoomInfo', doc: 'people', sub: name, string: str);
}
