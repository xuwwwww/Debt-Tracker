import 'package:flutter/material.dart';
import '../../firestore/firestore.dart';
import '../editAccount.dart';
import 'dart:convert';




class AccountPage extends StatefulWidget {
  AccountPage({Key? key, required this.name, required this.pwd}) : super(key: key);
  String name, pwd;
  @override
  State<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  var fb = Fb();
  static const defaultJson = '{}';
  String? mail;

  void editfunc(BuildContext context, String name, String pwd) async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => edit(name: name, pwd: pwd,)
      ),
    );
    fb.gett(col: 'RoomInfo', doc: 'people', sub: widget.name, showMap: true).then((value){
      mail = value['mail'];
      setState(() {});
    });
  }
  @override
  void initState() {
    super.initState();
    fb.gett(col: 'RoomInfo', doc: 'people', sub: widget.name, showMap: true).then((value){
      mail = value['mail'];
      setState(() {});
    });
  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Column(
          children: [
            SizedBox(height: 120,),
            Center(
              child: Text(
                'log in as',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text(
                widget.name,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (60-widget.name.length*2).toDouble(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 25,),
            Center(
              child: Text(
                'mail',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 10,),
            Center(
              child: Text(
                (mail.toString() != 'null' ? mail.toString() : ''),
                style: TextStyle(
                  color: Colors.black,
                  fontSize: (30).toDouble(),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            SizedBox(height: 5,),
            SizedBox(height: 70,),
            Hero(
              tag: 'join',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Color.fromARGB(255, 0, 73, 63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 10
                ),
                onPressed: () {
                  editfunc(context, widget.name, widget.pwd);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  child: Text('編輯帳號', style: TextStyle(fontSize: 30),),
                ),
              ),
            ),
            SizedBox(height: 80,),
            Hero(
              tag: 'join1',
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromARGB(255, 255, 255, 255),
                    foregroundColor: Color.fromARGB(255, 0, 73, 63),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                    elevation: 10
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60),
                  child: Text('登出', style: TextStyle(fontSize: 30),),
                ),
              ),
            ),
          ],
        )
      )
    );
  }
}