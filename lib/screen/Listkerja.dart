// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers

import 'package:flutter/material.dart';

class Listkerja extends StatefulWidget {
  Listkerja({Key? key}) : super(key: key);

  @override
  State<Listkerja> createState() => _ListkerjaState();
}

class _ListkerjaState extends State<Listkerja> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppBar(
                  backgroundColor: Colors.indigo[900],
                  elevation: 0,
                  title: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.only(right: 12.0),
                        child: Image.asset(
                          "assets/images/logo.png",
                          width: 40,
                          height: 40,
                        ),
                      ),
                      Text("Sistem Simpan-BNM", style: TextStyle(
                        fontSize: 20
                      ),),
                    ],
                  ),
                ),
              Container(
                child: Text("Halaman List Kerja"),
              )
            ],
          ),
        ],
      ),
    );
  }
}