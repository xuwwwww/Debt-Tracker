import 'package:fire0205/firestore/firestore.dart';
import 'package:flutter/material.dart';
import 'loginAndRegister/login_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'loginAndRegister/register.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'firebase_options.dart';
import 'dart:io';
Future main() async {
  String version = '0.18';
  bool connected = false;
  // final _flutterLocalNotificationsPlugin   = FlutterLocalNotificationsPlugin();
  //
  // Future<void> setup() async {
  //   const androidSetting = AndroidInitializationSettings('@mipmap/ic_launcher');
  //   const initSettings = InitializationSettings(android: androidSetting,);
  //   await _flutterLocalNotificationsPlugin .initialize(initSettings);
  // }
  //
  // WidgetsFlutterBinding.ensureInitialized();
  // await localNotificationService.setup();
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await Firebase.initializeApp(options:DefaultFirebaseOptions.currentPlatform,);
  }catch (e) {
    print('ERRORRRRRRRRRRR'+e.toString());
  }
  try {
    final result = await InternetAddress.lookup('example.com');
    if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
      // print('connected');
      connected = true;
    }
  } catch (_) {
  }
  bool haveNewVersion = true;
  bool shouldUpdate = false;
  String note = '';
  var docRef = await FirebaseFirestore.instance.collection('RoomInfo').doc('necessaryData');
  var docc = await docRef.get();
  var data = docc.data() as Map<String, dynamic>;
  haveNewVersion = !(data['version'] == version);
  if(haveNewVersion){
    shouldUpdate = data['needUpdate'];
    if(!shouldUpdate){
      shouldUpdate = (double.parse(data['version']) - double.parse(version) > 0.1);
    }
  }
  note = data['note'];
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Login Screen ",
      home: LoginScreen(haveNewVersion: haveNewVersion, shouldUpdate: shouldUpdate, note: note, version: version, newVersion: data['version'], connected: connected,),
    ),
  );
}


class NotificationService {
  static final NotificationService _notificationService =
  NotificationService._internal();

  factory NotificationService() {
    return _notificationService;
  }

  NotificationService._internal();

}