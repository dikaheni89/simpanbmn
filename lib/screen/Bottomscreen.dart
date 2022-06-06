// ignore_for_file: file_names, non_constant_identifier_names, unnecessary_null_comparison, prefer_const_constructors, avoid_print

import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/screen/Homescreen.dart';
import 'package:sistemsimpanbmn/screen/Profilscreen.dart';
import 'package:sistemsimpanbmn/screen/Tugasscreen.dart';

class BottomScreen extends StatefulWidget {
  const BottomScreen({Key? key}) : super(key: key);

  @override
  _BottomScreenState createState() => _BottomScreenState();
}

class _BottomScreenState extends State<BottomScreen> {
  final GlobalKey _NavKey = GlobalKey();
  int _currentIndex = 0;
  late DateTime backbuttonpressedTime;
  bool? login;
  String idusers = "";

  Future cekData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      idusers = prefs.getString('_id')!;
    });
  }

  @override
  void initState() {
    super.initState();
    cekData();
    print(login);
  }

  final List<Widget> _children = [
    Homescreen(),
    TugasScreen(),
    ProfilScreen(),
  ];

  void onTappedBar(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(onWillPop: onWillPop, child: _children[_currentIndex]),
      bottomNavigationBar: CurvedNavigationBar(
        backgroundColor: Colors.transparent,
        key: _NavKey,
        height: 50.0,
        items: [
          Icon((_currentIndex == 0) ? Icons.home_outlined : Icons.home,
              color: Colors.white),
          Icon(
              (_currentIndex == 1)
                  ? Icons.add_task_outlined
                  : Icons.add_task_rounded,
              color: Colors.white),
          Icon((_currentIndex == 2) ? Icons.history_outlined : Icons.person_add,
              color: Colors.white),
          // Icon((_currentIndex == 4) ? Icons.person : Icons.person_outline, color: Colors.white),
        ],
        buttonBackgroundColor: Colors.indigo[900],
        onTap: onTappedBar,
        animationCurve: Curves.fastLinearToSlowEaseIn,
        color: Colors.indigo.shade900,
      ),
    );
  }

  Future<bool> onWillPop() async {
    DateTime currentTime = DateTime.now();

    //bifbackbuttonhasnotbeenpreedOrToasthasbeenclosed
    //Statement 1 Or statement2
    bool backButton = backbuttonpressedTime == null ||
        currentTime.difference(backbuttonpressedTime) > Duration(seconds: 3);

    if (backButton) {
      backbuttonpressedTime = currentTime;
      Fluttertoast.showToast(
          msg: "Klik Dua Kali Untuk Keluar Aplikasi",
          backgroundColor: Colors.black,
          textColor: Colors.white);
      return false;
    }
    return true;
  }
}
