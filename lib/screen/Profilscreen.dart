// ignore_for_file: file_names, prefer_const_constructors_in_immutables, unused_local_variable, prefer_typing_uninitialized_variables, prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, prefer_if_null_operators, unnecessary_null_comparison

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/screen/EdiftProfilScreen.dart';
import 'package:sistemsimpanbmn/auth/Loginscreen.dart';
import 'package:sistemsimpanbmn/model/Profilmodel.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';

class ProfilScreen extends StatefulWidget {
  ProfilScreen({Key? key}) : super(key: key);

  @override
  State<ProfilScreen> createState() => _ProfilScreenState();
}

class _ProfilScreenState extends State<ProfilScreen> {
  bool? login;
  var idusers;
  Future<Profilmodel>? futureProfil;

  cekLogin() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      idusers = prefs.getString('_id') ?? "";
    });
    futureProfil = fetchProfil(idusers);
  }

  Future<Profilmodel> fetchProfil(String idusers) async {
    final response = await http
        .get(Uri.parse('https://simpanbmnatrbpn.id/api/getuserid?id=' + idusers));

    if (response.statusCode == 200) {
      return Profilmodel.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Failed to load album');
    }
  }

  @override
  void initState() {
    super.initState();
    cekLogin();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: (() => onWillPop()),
      child: Scaffold(
        appBar: AppBar(
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
              onPressed: () {},
            )
          ],
        ),
        body: ListView(
          shrinkWrap: true,
          children: [
            Column(
              children: <Widget>[
                Container(
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    // ignore: deprecated_member_use
                    overflow: Overflow.visible,
                    children: [
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Container(
                              height: 200.0,
                              decoration: BoxDecoration(
                                  image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(
                                          'https://simpanbmnatrbpn.id/uploads/bg.jpg'))),
                            ),
                          )
                        ],
                      ),
                      Positioned(
                        top: 100.0,
                        child: FutureBuilder<Profilmodel>(
                          future: futureProfil,
                          builder: (context, snapshot) {
                            if (snapshot.hasData) {
                              return Container(
                                height: 190.0,
                                width: 190.0,
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    image: DecorationImage(
                                      fit: BoxFit.cover,
                                      image: NetworkImage(snapshot.data!.photo),
                                    ),
                                    border: Border.all(
                                        color: Colors.white, width: 6.0)),
                              );
                            } else if (snapshot.hasError) {
                              return Text('${snapshot.error}');
                            }
                            return const CircularProgressIndicator();
                          },
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  alignment: Alignment.bottomCenter,
                  height: 130.0,
                  child: FutureBuilder<Profilmodel>(
                    future: futureProfil,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              snapshot.data!.full_name != null
                                  ? snapshot.data!.full_name
                                  : "",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 23.0),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            Icon(
                              Icons.check_circle,
                              color: Colors.indigo[900],
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(
                  height: 5.0,
                ),
                Container(
                    child: Text(
                  'Simpan-BMN Kantah Pandeglang',
                  style: TextStyle(fontSize: 14.0),
                )),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  child: FutureBuilder<Profilmodel>(
                    future: futureProfil,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.edit, color: Colors.black),
                                  onPressed: () {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              EditProfilScreen(
                                            idusers: idusers,
                                            alamat: snapshot.data!.alamat,
                                            photo: snapshot.data!.photo,
                                            full_name: snapshot.data!.full_name,
                                            email: snapshot.data!.email,
                                            phone: snapshot.data!.phone,
                                          ),
                                        ),
                                        (Route<dynamic> route) => false);
                                  },
                                ),
                                Text(
                                  'Edit Profil',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            ),
                            Column(
                              children: <Widget>[
                                IconButton(
                                  icon: Icon(Icons.replay_circle_filled,
                                      color: Colors.black),
                                  onPressed: () async {
                                    SharedPreferences prefs =
                                        await SharedPreferences.getInstance();
                                    prefs.setBool('login', false);
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => Loginscreen(),
                                        ),
                                        (Route<dynamic> route) => false);
                                  },
                                ),
                                Text(
                                  'Logout',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
                SizedBox(
                  height: 10.0,
                ),
                Container(
                  padding: EdgeInsets.only(left: 10.0, right: 10.0),
                  child: FutureBuilder<Profilmodel>(
                    future: futureProfil,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Column(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Icon(Icons.account_balance),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  snapshot.data!.alamat,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.phone),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  snapshot.data!.phone,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Row(
                              children: <Widget>[
                                Icon(Icons.email),
                                SizedBox(
                                  width: 5.0,
                                ),
                                Text(
                                  snapshot.data!.email,
                                  style: TextStyle(fontSize: 14.0),
                                ),
                                SizedBox(
                                  width: 5.0,
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 20.0,
                            ),
                            Row(
                              children: <Widget>[
                                Expanded(
                                  // ignore: deprecated_member_use
                                  child: RaisedButton(
                                    child: Text('Kembali Ke Beranda'),
                                    color: Colors.indigo[900],
                                    textColor: Colors.white,
                                    // ignore: unrelated_type_equality_checks
                                    onPressed: () =>
                                        Navigator.pushAndRemoveUntil(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) =>
                                                  BottomScreen(),
                                            ),
                                            (route) => false),
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(15)),
                                  ),
                                ),
                              ],
                            ),
                            Container(
                              height: 10.0,
                              child: Divider(
                                color: Colors.grey,
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Text('${snapshot.error}');
                      }
                      return const CircularProgressIndicator();
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    return (await Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) => BottomScreen(),
            ),
            (route) => false)) ??
        false;
  }
}
