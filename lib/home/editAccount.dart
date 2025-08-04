import 'package:flutter/material.dart';
import '../firestore/firestore.dart';
import '../loginAndRegister/checkLoggedIn.dart';
import 'functinos.dart';

class edit extends StatefulWidget {
  edit({Key? key, required this.name, required this.pwd}) : super(key: key);
  String name, pwd;

  @override
  State<edit> createState() => _edit();
}

class _edit extends State<edit> {
  var fb = Fb();
  final TextEditingController newmail =TextEditingController();
  final TextEditingController oldpwd =TextEditingController();
  final TextEditingController newpwd =TextEditingController();

  bool passenable = true;
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromARGB(255, 0, 73, 63),
          title: Text('Edit Account'),
        ),
        body: Center(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Center(
                  child: Text(
                    '更改信箱',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 101, 93),
                      fontSize: 30,
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
                    controller: newmail,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
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
                        hintText: '信箱',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 30,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Color.fromARGB(255, 0, 73, 63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10
                  ),
                  onPressed: () async {
                    // if(checkNotValid(string: newmail.text) && )
                    if(newmail.text == ''){
                      var snackBar = SnackBar(
                        duration: Duration(seconds: 3),
                        content: const Text('信箱不得為空!'),
                        backgroundColor: Color.fromARGB(255, 0, 101, 93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else if(newmail.text == widget.name){
                      var snackBar = SnackBar(
                        duration: Duration(seconds: 3),
                        content: const Text('信箱不得跟原本一樣!'),
                        backgroundColor: Color.fromARGB(255, 0, 101, 93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else if(await checkExist(name: newmail.text)){
                      var snackBar = SnackBar(
                        duration: Duration(seconds: 3),
                        content: const Text('信箱已存在!'),
                        backgroundColor: Color.fromARGB(255, 0, 101, 93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }else{
                      await fb.update(col: 'RoomInfo', doc: 'people', sub: widget.name, subsub: 'mail', value: newmail.text);
                      Navigator.pop(context);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('保存', style: TextStyle(fontSize: 30),),
                  )
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 12,),
                Center(
                  child: Text(
                    '更改密碼',
                    style: TextStyle(
                      color: Color.fromARGB(255, 0, 101, 93),
                      fontSize: 30,
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
                    controller: oldpwd,
                    obscureText: passenable,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: '舊密碼',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        suffix: IconButton(
                            onPressed: (){
                              setState(() { //refresh UI
                                if(passenable){
                                  passenable = false;
                                }else{
                                  passenable = true;
                                }
                              }
                              );
                            },
                            icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password, color: Colors.black,)
                        )
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20,),
                Container(
                  height: 50,
                  padding: EdgeInsets.symmetric(horizontal: 50),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white,
                  ),
                  child: TextField(
                    controller: newpwd,
                    obscureText: passenable,
                    style: TextStyle(color: Colors.black),
                    decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                          borderSide: BorderSide(
                              color: Colors.grey,
                              width: 2.0
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        prefixIcon: const Icon(
                          Icons.lock,
                          color: Colors.black,
                        ),
                        hintText: '新密碼',
                        hintStyle: const TextStyle(
                          color: Colors.black,
                        ),
                        suffix: IconButton(
                            onPressed: (){
                              setState(() { //refresh UI
                                if(passenable){
                                  passenable = false;
                                }else{
                                  passenable = true;
                                }
                              }
                              );
                            },
                            icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password, color: Colors.black,)
                        )
                    ),
                  ),
                ),
                SizedBox(height: MediaQuery.of(context).size.height / 20,),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 255, 255, 255),
                      foregroundColor: Color.fromARGB(255, 0, 73, 63),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                      elevation: 10
                  ),
                  onPressed: () async {
                    print(oldpwd.text);
                    print(newpwd.text);
                    if(!checkNotValid(string: oldpwd.text) && !checkNotValid(string: newpwd.text)){
                      if(oldpwd.text != widget.pwd){
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: const Text('舊密碼錯誤!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if(oldpwd.text == '' || newpwd.text == ''){
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: const Text('密碼不得為空!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if (oldpwd.text == newpwd.text){
                        var snackBar = SnackBar(
                          duration: Duration(seconds: 3),
                          content: const Text('密碼不得相同!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                        await fb.update(col: 'RoomInfo', doc: 'people', sub: widget.name, subsub: 'pwd', value: newpwd.text);
                        Navigator.pop(context);
                      }
                    }else{
                      var snackBar = SnackBar(
                        duration: Duration(seconds: 3),
                        content: const Text('含有非法字符!!'),
                        backgroundColor: Color.fromARGB(255, 0, 101, 93),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                        behavior: SnackBarBehavior.floating,
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 50),
                    child: Text('保存', style: TextStyle(fontSize: 30),),
                  )
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}