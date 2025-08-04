import 'package:flutter/material.dart';
import 'checkLoggedIn.dart';
import '../packagesToTransfer/login_log.dart';
import 'dart:math';
import '../home/functinos.dart';


class Register extends StatefulWidget{
  const Register({super.key});
  @override
  State<Register> createState() => _Register();
}
class _Register extends State<Register> with TickerProviderStateMixin{
  bool passenable = true;
  LogingLog logingLog = LogingLog();
  final TextEditingController name = TextEditingController();
  final TextEditingController mail = TextEditingController();
  final TextEditingController password = TextEditingController();
  int _textLength = 0;
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Color.fromARGB(255, 0, 71, 65),
      child: SafeArea(
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 0, 101, 93),
              title: const Text(
                'register',
                style: TextStyle(
                  fontSize: 25,
                ),
            ),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                const SizedBox(height: 100,),
                const Text(
                  'Name',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        )
                    ),
                    child:Padding(
                      padding: EdgeInsets.only(left: 20, right: 50, top: 5),
                      child: TextFormField(
                        controller: name,
                        onChanged: (text) { setState(() {_textLength = text.length; }); },
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: const Icon(
                              Icons.accessibility_new,
                              color: Colors.black,
                          ),
                          errorText: _textLength > 12 ? '名稱請勿超過12位!' : null,
                          errorStyle: const TextStyle(color: Colors.pink),
                          hintText: '請輸入名稱',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Mail',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                        border: Border.all(width: 1),
                        borderRadius: const BorderRadius.all(
                          Radius.circular(30),
                        )
                    ),
                    child:Padding(
                      padding: const EdgeInsets.only(left: 20, right: 50, top: 5),
                      child: TextField(
                        controller: mail,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.mail,
                            color: Colors.black,
                          ),
                          hintText: '請輸入信箱',
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 30,),
                const Text(
                  'Password',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10,),
                Padding(
                  padding: const EdgeInsets.only(left: 50, right: 50),
                  child: Container(
                    width: double.infinity,
                    height: 60,
                    decoration: BoxDecoration(
                      border: Border.all(width: 1),
                      borderRadius: const BorderRadius.all(
                        Radius.circular(30),
                      )
                    ),
                    child:Padding(
                      padding: EdgeInsets.only(left: 20, right: 50, top: 5),
                      child: TextField(
                        obscureText: passenable,
                        controller: password,
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          prefixIcon: Icon(
                            Icons.lock,
                            color: Colors.black,
                          ),
                          hintText: '請輸入密碼',
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
                                icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password)
                            )
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 50,),
                Padding(
                  padding: const EdgeInsets.only(left: 100, right: 100),
                  child: ElevatedButton(
                    onPressed: () async {
                      logingLog.name = name.text;
                      logingLog.mail = mail.text;
                      logingLog.password = password.text;
                      logingLog.loggedin = true;
                      if (logingLog.check() != true){
                        var snackBar = SnackBar(
                          content: const Text('有表格未填!'),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Already have an account?',
                            onPressed: () {
                              logingLog.loggedin = false;
                              Navigator.pop(context, logingLog);
                            },
                          ),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                      else if(await checkExist(name: logingLog.name)){
                        var snackBar = SnackBar(
                          content: const Text('帳號已經存在!'),
                          // content: Text(tryy()),
                          action: SnackBarAction(
                            textColor: Colors.white,
                            label: 'Forget password?',
                            onPressed: () {Navigator.pop(context, logingLog);},
                          ),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else if(checkNotValid(string: name.text) || checkNotValid(string: mail.text, forMail: true) || checkNotValid(string: password.text)){
                        var snackBar = SnackBar(
                          content: const Text('含有非法字符!'),
                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                          behavior: SnackBarBehavior.floating,
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }else{
                        print('---------registering-----------');
                        uploadPpl(name: name.text, mail: mail.text, password: password.text);
                        Navigator.pop(context, logingLog);
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromARGB(255, 0, 101, 93),
                      padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30.0)
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Color.fromRGBO(0,0, 0, 0),
                      ),
                      child: const Center(
                        child: Text(
                          'confirm',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          )
        ),
      ),
    );
  }
}
