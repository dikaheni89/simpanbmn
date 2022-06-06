// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, unused_import, non_constant_identifier_names, unused_local_variable, avoid_print, unnecessary_null_comparison

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/model/Tugasmodel.dart';
import 'package:http/http.dart' as http;
import 'package:sistemsimpanbmn/screen/Profilscreen.dart';
import 'package:sistemsimpanbmn/screen/form/Cekgedung.dart';
import 'package:sistemsimpanbmn/screen/form/Cekperalatan.dart';
import 'package:sistemsimpanbmn/screen/form/Cektanah.dart';

class Homescreen extends StatefulWidget {
  Homescreen({Key? key}) : super(key: key);

  @override
  State<Homescreen> createState() => _HomescreenState();
}

class _HomescreenState extends State<Homescreen> {
  bool? login;
  String idusers = "";
  late DateTime backbuttonpressedTime;

  Future cekData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      idusers = prefs.getString('_id')!;
    });
  }

  Future getPeralatan(String idusers) async {
    try {
      var Url = 'https://simpanbmnatrbpn.id/api/gettugas?iduser=' + idusers;
      final response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Tugasmodel> peralatanlist =
            it.map((e) => Tugasmodel.fromJson(e)).toList();
        return peralatanlist;
      }
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  void initState() {
    super.initState();
    cekData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: onWillPop,
        child: Stack(
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
                      Text(
                        "Simpan-BMN",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                  actions: [
                    IconButton(
                      icon: Icon(
                        Icons.person_outline,
                        color: Colors.white,
                        size: 20,
                      ),
                      onPressed: () {
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => ProfilScreen(),
                            ),
                            (route) => false);
                      },
                    )
                  ],
                ),
                Container(
                  child: Expanded(
                      child: FutureBuilder(
                          future: getPeralatan(idusers),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (!snapshot.hasData) {
                              return Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return ListView.builder(
                                itemCount: snapshot.data.length,
                                itemBuilder: (BuildContext context, int index) {
                                  return Column(
                                    children: [
                                      Container(
                                          height: 100,
                                          margin: EdgeInsets.symmetric(
                                              horizontal: 20, vertical: 10),
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  color: Colors.black
                                                      .withOpacity(0.03),
                                                  offset: Offset(0, 9),
                                                  blurRadius: 20,
                                                  spreadRadius: 1),
                                            ],
                                          ),
                                          child: Row(
                                            children: [
                                              GestureDetector(
                                                onTap: () {
                                                  if (snapshot
                                                          .data[index].tipe ==
                                                      "peralatan") {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Cekperalatan(
                                                                  idmoni: snapshot
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                                  idinvents: snapshot
                                                                      .data[
                                                                          index]
                                                                      .idinvent),
                                                            ),
                                                            (route) => false);
                                                  } else if (snapshot
                                                          .data[index].tipe ==
                                                      "gedung") {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) => Cekgedung(
                                                                  idmoni: snapshot
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                                  idinvents: snapshot
                                                                      .data[
                                                                          index]
                                                                      .idinvent),
                                                            ),
                                                            (route) => false);
                                                  } else {
                                                    Navigator
                                                        .pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder:
                                                                  (context) =>
                                                                      Cektanah(idmoni: snapshot
                                                                      .data[
                                                                          index]
                                                                      .id,
                                                                  idinvents: snapshot
                                                                      .data[
                                                                          index]
                                                                      .idinvent),
                                                            ),
                                                            (route) => false);
                                                  }
                                                },
                                                child: Container(
                                                  margin: EdgeInsets.symmetric(
                                                      horizontal: 20),
                                                  height: 25,
                                                  width: 25,
                                                  decoration: BoxDecoration(
                                                      color: Colors.white,
                                                      shape: BoxShape.circle,
                                                      border: Border.all(
                                                          color: Colors
                                                              .indigo.shade900,
                                                          width: 4)),
                                                ),
                                              ),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    snapshot.data[index].merk
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 15),
                                                  ),
                                                  Text(
                                                    snapshot.data[index].tanggal
                                                        .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                  ),
                                                  SizedBox(
                                                    height: 5,
                                                  ),
                                                  Text(
                                                    'Kategori Cek: ' +
                                                        snapshot
                                                            .data[index].tipe
                                                            .toString(),
                                                    style: TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 13),
                                                  )
                                                ],
                                              ),
                                              Expanded(
                                                child: Container(),
                                              ),
                                              Container(
                                                height: 50,
                                                width: 5,
                                                color: Colors.indigo.shade900,
                                              ),
                                            ],
                                          )),
                                    ],
                                  );
                                },
                              );
                            }
                          })),
                ),
              ],
            ),
          ],
        ),
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
