// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/auth/Loginscreen.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';
import 'dart:async';

class Splashscreen extends StatefulWidget {
  const Splashscreen({Key? key}) : super(key: key);

  @override
  State<Splashscreen> createState() => _SplashscreenState();
}

class _SplashscreenState extends State<Splashscreen> {
  bool? login;
  String? level;
  String? idusers;
  DateTime? backbuttonpressedTime;

  Future ceklogin() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      level = prefs.getString('is_level');
      idusers = prefs.getString('_id');
    });
  }

  @override
  void initState() {
    super.initState();
    ceklogin();
    Timer(const Duration(seconds: 3), () {
      if (login == false) {
        Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => Loginscreen()));
      }else{
        Navigator.of(context)
          .pushReplacement(MaterialPageRoute(builder: (_) => BottomScreen()));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo[900],
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              "assets/images/logo.png",
              width: 200.0,
              height: 100.0,
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              "Simpan-BMN Kantah Pandeglang",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 15,
            ),
            Text(
              "Versi 1.0 realease",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: 50,
            ),
            CircularProgressIndicator(
              valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
