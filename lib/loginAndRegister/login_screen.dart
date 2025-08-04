import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../home/home.dart';
import '../packagesToTransfer/login_log.dart';
import 'checkLoggedIn.dart';
import 'register.dart';
import 'package:url_launcher/url_launcher.dart';


class LoginScreen extends StatefulWidget {
  LoginScreen({Key? key, required this.haveNewVersion, required this.shouldUpdate, required this.note,required this.version, required this.newVersion, required this.connected}) : super(key: key);
  String version, newVersion;
  bool haveNewVersion = true;
  bool shouldUpdate = false;
  bool connected = false;
  String note = '';
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  LogingLog result = LogingLog();

  void registerB(BuildContext context) async {
    result = await Navigator.push(
      context,
        MaterialPageRoute(builder: (context) => Register()
      ),
    );
    if(result.runtimeType != Null) {
      // result.printval();
      if(result.loggedin){
        Navigator.push(context,
            MaterialPageRoute(
                builder: (context) => Home(name : result.name, pwd : result.password)
            )
        );
      }
    }

  }

  final TextEditingController logname =TextEditingController();
  final TextEditingController logpassword =TextEditingController();

  void initState() {
    print('connected : '+ widget.connected.toString());
    super.initState();
  }
  bool passenable = true;
  int _textLength = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        (widget.connected)?Container(
          color: Color.fromARGB(255, 0, 71, 65),
          child: SafeArea(
            child: Stack(
              children: [
                Scaffold(
                  backgroundColor: Colors.white,
                  body: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height / 4,
                        child: Image.asset(
                          'lib/images/logo2.png',
                          fit: BoxFit.fitWidth,
                        ),
                      ),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 0, 101, 93),
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(50),
                              topRight: Radius.circular(50),
                            ),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(30.0),
                            child: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Name',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: TextFormField(
                                      controller: logname,
                                      onChanged: (text) { setState(() {_textLength = text.length; }); },
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: const Icon(
                                          Icons.accessibility_new,
                                          color: Colors.black,
                                        ),
                                        errorText: _textLength > 12 ? '名稱請勿超過12位!' : null,
                                        errorStyle: const TextStyle(color: Colors.pink),
                                        hintText: 'Name',
                                        hintStyle: const TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  const Text(
                                    'Password',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,

                                    ),
                                  ),
                                  const SizedBox(height: 15),
                                  Container(
                                    height: 50,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(30),
                                      color: Colors.white,
                                    ),
                                    child: TextField(
                                      controller: logpassword,
                                      obscureText: passenable,
                                      style: TextStyle(color: Colors.black),
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        prefixIcon: const Icon(
                                          Icons.lock,
                                          color: Colors.black,
                                        ),
                                        hintText: 'Password',
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
                                          icon: Icon(passenable == true?Icons.remove_red_eye:Icons.password)
                                        )
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 70),
                                  GestureDetector(
                                    onTap: () async {
                                      if (await checkLoggedIn(name:logname.text, password: logpassword.text)){
                                        Navigator.push(context,
                                            MaterialPageRoute(
                                                builder: (context) => Home(name : logname.text, pwd : logpassword.text)
                                            )
                                        );
                                      }
                                      else{
                                        var snackBar = SnackBar(
                                          duration: Duration(seconds: 3),
                                          content: const Text('請確認帳號或密碼正確!'),
                                          action: SnackBarAction(
                                            textColor: Colors.white,
                                            label: "Hasn't registered yet?",
                                            onPressed: () {
                                              registerB(context);
                                              // setState(() {});
                                              },
                                          ),
                                          backgroundColor: Color.fromARGB(255, 0, 101, 93),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10))),
                                          behavior: SnackBarBehavior.floating,
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                      }
                                    },
                                    child: Container(
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(30),
                                        color: Colors.white,
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            ' Log In',
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 30,
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 80),
                                  Center(
                                    child: Container(
                                      margin: const EdgeInsets.only(left: 100, right: 100),
                                      child : ElevatedButton(
                                        onPressed: () {
                                          registerB(context);
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.white,
                                          padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 20.0),
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(30.0)
                                          ),
                                          elevation: 20,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(30),
                                            color: Colors.white,
                                          ),
                                          child: const Center(
                                            child: Text(
                                              ' or sign up ',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 40,),
                                  Container(
                                    padding: EdgeInsets.symmetric(horizontal: 40),
                                    height: 50,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment: CrossAxisAlignment.stretch,
                                      children: [
                                        Container(
                                          height: 35,
                                          child : ElevatedButton(
                                            onPressed: () {
                                              _launchURL('https://instagram.com/xu_wwww?igshid=ZDdkNTZiNTM=');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0)
                                              ),
                                              elevation: 20,
                                            ),
                                            child: Text(
                                              '我的哀居 : \n出問題直接密給我好了，\n反正應該沒人理我  :D',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 11,
                                              ),
                                              textAlign: TextAlign.center
                                            ),
                                          ),
                                        ),
                                        Container(
                                          height: 35,
                                          child : ElevatedButton(
                                            onPressed: () {
                                              _launchURL('https://docs.google.com/document/d/11mniZVU88BTUudxAnqb6odOY1bylGnf14OnOxaK6_0s/edit?usp=sharing');
                                            },
                                            style: ElevatedButton.styleFrom(
                                              backgroundColor: Colors.white,
                                              padding: EdgeInsets.symmetric(horizontal: 10.0),
                                              shape: RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.circular(30.0)
                                              ),
                                              elevation: 20,
                                            ),
                                            child: Text(
                                              '使用說明',
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 20,
                                              ),
                                              textAlign: TextAlign.center
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Positioned(
                  bottom:0,
                  left: 50,
                  child: Text(
                    'ver: indev : ${widget.version}',
                    style: TextStyle(
                      decoration: TextDecoration.none,
                      fontStyle: FontStyle.normal,
                      color: Colors.black,
                      fontSize: 10,
                    ),
                  ),
                ),
              ],
            ),
          ),
        )
        :
        Center(
          child: Text(
            'Not connected',
            style: Theme.of(context).textTheme.headline4,
          ),
        ),
        if(widget.haveNewVersion || widget.shouldUpdate)Center(
          child: Container(
            height: MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.8),
            ),
            child: Stack(
              children: [
                Center(
                  child: IntrinsicHeight(
                    child: Container(
                      width: MediaQuery.of(context).size.width*0.8,
                      height: MediaQuery.of(context).size.height*0.5,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(
                          width: 3,
                          color: Color.fromARGB(255, 0, 101, 93),
                        ),
                        borderRadius: BorderRadius.all(Radius.circular(60)),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              widget.shouldUpdate?'必須更新':'有新版本了~~ \nindev:${widget.version} => indev:${widget.newVersion}',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                decoration: TextDecoration.none,
                                fontStyle: FontStyle.normal,
                                color: Colors.black,
                                fontSize: 15,
                                height: 2,
                              ),
                            ),
                            SizedBox(height: 10,),
                            Container(
                              decoration: BoxDecoration(
                                color: Colors.grey,
                                border: Border.all(
                                  width: 2,
                                  color: Colors.black,
                                ),
                                borderRadius: BorderRadius.all(Radius.circular(15)),
                              ),
                              width: MediaQuery.of(context).size.width*0.6,
                              child: Text(
                                '更新日誌:\n${widget.note}',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  decoration: TextDecoration.none,
                                  fontStyle: FontStyle.normal,
                                  color: Colors.black,
                                  fontSize: 15,
                                  height: 2,
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(255, 0, 101, 93),
                                      )
                                    ),
                                    child: const Text('更新'),
                                    onPressed: ((){
                                      _launchURL('https://drive.google.com/drive/folders/1waeBRaNvCOotio4PrmbGvlQbRbbSC3s6?usp=sharing');
                                    }),
                                  ),
                                ),
                                SizedBox(width: 10,),
                                Container(
                                  width: MediaQuery.of(context).size.width*0.3,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.grey,
                                      foregroundColor: Colors.black,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                                      side: const BorderSide(
                                        width: 2,
                                        color: Color.fromARGB(255, 0, 101, 93),
                                      )
                                    ),
                                    child: Text(widget.shouldUpdate?'退出':'繼續'),
                                    onPressed: () {
                                      if(widget.shouldUpdate){
                                        SystemNavigator.pop();
                                      }else{
                                        setState(() {
                                          widget.shouldUpdate = false;
                                          widget.haveNewVersion = false;
                                        });
                                      }

                                    },
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
  _launchURL(String url) async {
    print(url);
    final Uri uri = Uri.parse(url);
    try{
      launchUrl(uri);
    }catch(e){
      print(e);
    }
  }
}
