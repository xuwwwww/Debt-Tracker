import 'package:flutter/material.dart';
import 'pages/page1.dart';
import 'pages/page2.dart';
import 'pages/page3.dart';
import 'functinos.dart';
import '../firestore/firestore.dart';
import 'dart:math';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';
import 'event.dart';
import 'settleEvent.dart';



class Home extends StatefulWidget {
  String name, pwd;
  Home({Key? key, required this.name, required this.pwd}) : super(key: key);


  @override
  State<Home> createState() => _Home();
}

class _Home extends State<Home> with TickerProviderStateMixin {
  int _currentIndex = 0; //預設值
  List _pages() => [
    TabBarView(
      controller: _tabController,
      children: [
        MyEvent(name: widget.name, pwd: widget.pwd),
        MyRoom(name: widget.name.toString(), pwd: widget.pwd.toString(),),
      ],
    ),
    TabBarView(
      controller: _tabController,
      children: [
        EventSettle(pplName: widget.name.toString()),
        HomePage(name: widget.name.toString(),),
      ],
    ),

    AccountPage(name: widget.name.toString(), pwd: widget.pwd.toString(),)]
  ;

  void _onItemClick(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  static const TextStyle optionStyle =
  TextStyle(fontSize: 30, fontWeight: FontWeight.w600);

  List<Tab> myTabs = [
    Tab(
      child: Text(
        '房間',
      ),
    ),
    Tab(
      child: Text(
        '事件',
      ),
    ),
  ];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
        vsync: this,
        length: myTabs.length,
        initialIndex: 0,
    );
  }




  @override
  Widget build(BuildContext context) {
    final List pages = _pages();
    return Container(
      color: Color.fromARGB(255, 0, 71, 65),
      child: SafeArea(
        child: Center(
          child: Scaffold(
            appBar: (_currentIndex == 0 || _currentIndex == 1)?
            AppBar(
              shape: ContinuousRectangleBorder(
                // side: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(70),
                  bottomLeft: Radius.circular(70),
                ),
              ),
              elevation: 4,
              centerTitle: true,
              backgroundColor: Color.fromARGB(255, 0, 101, 93),
              automaticallyImplyLeading: false,
              title: Text(
                '正在以 : ${widget.name} 登入',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20.0,
                  // height: 3,
                ),
              ),
              shadowColor : Color.fromARGB(255, 0, 101, 93),
              bottom: TabBar(
                labelStyle: TextStyle(fontSize: 15.0),
                labelColor: Colors.black,
                unselectedLabelColor: Colors.white,
                indicatorColor: Colors.black,
                indicator: BoxDecoration(
                  border: Border.all(
                    color: Color.fromARGB(255, 0, 35, 34),
                    width: 2,
                  ),
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(30.0),
                    topLeft: Radius.circular(30.0),
                    bottomLeft: Radius.circular(55.0),
                    bottomRight: Radius.circular(55.0),
                  ),
                  color: Colors.white,
                ),
                controller: _tabController,
                tabs: myTabs,
              ),
            )
            :
            null,

            body: pages[_currentIndex],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    blurRadius: 20,
                    color: Colors.black.withOpacity(.1),
                  )
                ],
              ),
              child: SafeArea(
                child: Container(
                  decoration: BoxDecoration(
                      // border: Border.all(
                      //   color: Colors.red[500],
                      // ),
                    color: Color.fromARGB(255, 0, 101, 93),
                    borderRadius: BorderRadius.only(
                      topRight: Radius.circular(30.0),
                      topLeft: Radius.circular(30.0),
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 30, right: 30, bottom: 8, top: 5),
                    child: GNav(
                      backgroundColor: Color.fromARGB(255, 0, 101, 93),
                      rippleColor: Colors.grey[300]!,
                      hoverColor: Colors.grey[100]!,
                      gap: 8,
                      activeColor: Colors.black,
                      iconSize: 24,
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                      duration: Duration(milliseconds: 400),
                      tabBackgroundColor: Color.fromARGB(255, 255, 255, 255),
                      color: Colors.black,
                      tabs: [
                        GButton(
                          icon: Icons.home_filled,
                          text: '事件&房間',
                        ),
                        GButton(
                          icon: Icons.attach_money,
                          text: '結算',
                        ),
                        GButton(
                          icon: Icons.account_circle,
                          text: '個人資料',
                        ),
                      ],
                      selectedIndex: _currentIndex,
                      onTabChange: (index) {
                        _onItemClick(index);
                      },
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
