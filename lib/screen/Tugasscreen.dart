// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, avoid_unnecessary_containers, unnecessary_this, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/model/Historymodel.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';
import 'package:sistemsimpanbmn/screen/Detailasset.dart';

class TugasScreen extends StatefulWidget {
  TugasScreen({Key? key}) : super(key: key);

  @override
  State<TugasScreen> createState() => _TugasScreenState();
}

class _TugasScreenState extends State<TugasScreen> {
  bool? login;
  String idusers = "";

  Future cekData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      idusers = prefs.getString('_id')!;
    });
  }

  Future getHistory(String idusers) async {
    try {
      var Url = 'https://simpanbmnatrbpn.id/api/gethistory?iduser=' + idusers;
      final response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Historymodel> peralatanlist =
            it.map((e) => Historymodel.fromJson(e)).toList();
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
                "Sistem Simpan-BNM",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
        ),
        body: Container(
          padding: EdgeInsets.fromLTRB(10, 10, 10, 0),
          height: 220,
          width: double.maxFinite,
          child: FutureBuilder(
              future: getHistory(idusers),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Card(
                        child: ListTile(
                          onTap: (){
                            Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Detailasset(idmoni: snapshot.data[index].id)), (route) => false);
                          },
                          title: Text(snapshot.data[index].merk),
                          subtitle: Text(snapshot.data[index].trx_status, style: TextStyle(color: Colors.lightGreen),),
                          trailing: Icon(Icons.keyboard_arrow_right),
                        ),
                      );
                    },
                  );
                }
              }),
        ),
      ),
    );
  }

  Future<bool> onWillPop() async {
    return (await Navigator.pushAndRemoveUntil(
            this.context,
            MaterialPageRoute(
              builder: (context) => BottomScreen(),
            ),
            (route) => false)) ??
        false;
  }
}
