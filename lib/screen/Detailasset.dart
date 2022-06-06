// ignore_for_file: file_names, prefer_const_constructors_in_immutables, prefer_const_constructors, prefer_const_literals_to_create_immutables, import_of_legacy_library_into_null_safe, non_constant_identifier_names, avoid_print, unnecessary_this

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_ticket_widget/flutter_ticket_widget.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sistemsimpanbmn/model/Detailmodel.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';

class Detailasset extends StatefulWidget {
  Detailasset({Key? key, required this.idmoni}) : super(key: key);

  final String idmoni;

  @override
  State<Detailasset> createState() => _DetailassetState();
}

class _DetailassetState extends State<Detailasset> {
  bool? login;
  String? idusers;

  Future cekData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      login = prefs.getBool('login') ?? false;
      idusers = prefs.getString('_id');
    });
  }

  Future getDetailid() async {
    try {
      var Url =
          'https://simpanbmnatrbpn.id/api/getdetail?id=' + widget.idmoni;
      final response = await http.get(Uri.parse(Url));
      if (response.statusCode == 200) {
        Iterable it = jsonDecode(response.body);
        List<Detailmodel> detaillist =
            it.map((e) => Detailmodel.fromJson(e)).toList();
        return detaillist;
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
      backgroundColor: Colors.grey[300],
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
              "Sistem Simpan-BMN",
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
      body: WillPopScope(
        onWillPop: (() => onWillPop()),
        child: Center(
          child: FutureBuilder(
              future: getDetailid(),
              builder: (BuildContext context, AsyncSnapshot snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      return Padding(
                        padding: const EdgeInsets.only(top: 60.0),
                        child: FlutterTicketWidget(
                          width: 350.0,
                          height: 500.0,
                          isCornerRounded: true,
                          child: Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Container(
                                        width: 120.0,
                                        height: 25.0,
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                          border: Border.all(
                                              width: 1.0, color: Colors.green),
                                        ),
                                        child: Center(
                                          child: Text(
                                            snapshot.data[index].trx_status,
                                            style: TextStyle(color: Colors.green),
                                          ),
                                        ),
                                      ),
                                      Row(
                                        children: <Widget>[
                                          Text(
                                            snapshot.data[index].tipe,
                                            style: TextStyle(
                                                color: Colors.black,
                                                fontWeight: FontWeight.bold),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 8.0),
                                            child: Icon(
                                              Icons.check_circle,
                                              color: Colors.indigo[900],
                                            ),
                                          ),
                                        ],
                                      )
                                    ],
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 20.0),
                                    child: Text(
                                      snapshot.data[index].merk,
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(top: 25.0),
                                    child: Column(
                                      children: <Widget>[
                                        ticketDetailsWidget('Petugas Cek', snapshot.data[index].full_name,
                                            'Tanggal Cek', snapshot.data[index].tanggal),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0, right: 40.0),
                                          child: ticketDetailsWidget('Lokasi/Ruangan',
                                              snapshot.data[index].ruangan, 'kondisi', snapshot.data[index].kondisi),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 12.0, right: 40.0),
                                          child: ticketDetailsWidget(
                                              'Penanggung Jawab', snapshot.data[index].penanggungjawab, 'Kode Asset', snapshot.data[index].kode),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 10.0, left: 75.0, right: 75.0),
                                    child: Text(
                                      'detail asset',
                                      style: TextStyle(
                                        color: Colors.black,
                                      ),
                                    ),
                                  ),
                                ]),
                          ),
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

  Widget ticketDetailsWidget(String firstTitle, String firstDesc,
      String secondTitle, String secondDesc) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(left: 12.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                firstTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  firstDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(right: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                secondTitle,
                style: TextStyle(
                  color: Colors.grey,
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 4.0),
                child: Text(
                  secondDesc,
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              )
            ],
          ),
        )
      ],
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
