// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables, unnecessary_this

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';
import 'package:sistemsimpanbmn/widgets/ShowToast.dart';

class Cekgedung extends StatefulWidget {
  Cekgedung({Key? key, required this.idmoni, required this.idinvents}) : super(key: key);
  final String idmoni;
  final String idinvents;

  @override
  State<Cekgedung> createState() => _CekgedungState();
}

class _CekgedungState extends State<Cekgedung> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController ket1 = TextEditingController();
  TextEditingController ket2 = TextEditingController();
  String? valueBersih1;
  String? valueBersih2;
  String? valueBaik1;
  String? valueBaik2;
  String? valueNyala1;
  String? valueNyala2;
  List listBersih1 = [];
  List listNyala1 = [];
  List listBaik1 = [];
  List listBaik2 = [];

  addData() async {
    var saveUrl = Uri.parse(
        "https://simpanbmnatrbpn.id/api/savegedung");
    var request = http.MultipartRequest("POST", saveUrl);
    request.fields['bersih1'] = valueBersih1!;
    request.fields['bersih2'] = valueBersih2!;
    request.fields['baik1'] = valueBaik1!;
    request.fields['baik2'] = valueBaik2!;
    request.fields['nyala1'] = valueNyala1!;
    request.fields['nyala2'] = valueNyala2!;
    request.fields['ket1'] = ket1.text;
    request.fields['ket2'] = ket2.text;
    request.fields['idmoni'] = widget.idmoni;
    request.fields['idinvent'] = widget.idinvents;
    var response = await request.send();

    if (response.statusCode == 200) {
      ShowToast().showToastSuccess('Berhasil Tersimpan');
      setState(() {
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(
              builder: (context) =>
                  BottomScreen(),
            ),
            (route) => false);
      });
    }else{
      ShowToast().showToastError('Data Gagal Disimpan');
    }
  }


  getBersih1() async {
    final response = await http.get(
        Uri.parse("https://simpanbmnatrbpn.id/api/getcombogedung"));
    if (response.statusCode == 200) {
      setState(() {
        listBersih1 = jsonDecode(response.body);
      });
    }
  }

  getNyala1() async {
    final response = await http.get(
        Uri.parse("https://simpanbmnatrbpn.id/api/getcombogedung1"));
    if (response.statusCode == 200) {
      setState(() {
        listNyala1 = jsonDecode(response.body);
      });
    }
  }

  getBaik1() async {
    final response = await http.get(
        Uri.parse("https://simpanbmnatrbpn.id/api/getcombogedung2"));
    if (response.statusCode == 200) {
      setState(() {
        listBaik1 = jsonDecode(response.body);
      });
    }
  }

  getBaik2() async {
    final response = await http.get(
        Uri.parse("https://simpanbmnatrbpn.id/api/getcombogedung3"));
    if (response.statusCode == 200) {
      setState(() {
        listBaik2 = jsonDecode(response.body);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getBersih1();
    getNyala1();
    getBaik1();
    getBaik2();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              "Simpan-BNM",
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
      body: WillPopScope(
        onWillPop: (() => onWillPop()),
        child: ListView(
          children: 
            [Container(
              padding: EdgeInsets.all(10.0),
              child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Lantai: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueBersih1,
                          onChanged: (newValue) {
                            setState(() {
                              valueBersih1 = newValue as String?;
                            });
                          },
                          validator: (list) => list == null
                              ? 'Pilihan Kondisi Lantai Tidak Boleh Kosong'
                              : null,
                          items: listBersih1.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: ket1,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Keterangan Tidak Boleh Kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Keterangan Lantai',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Tembok: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueBersih2,
                          onChanged: (newValue) {
                            setState(() {
                              valueBersih2 = newValue as String?;
                            });
                          },
                          validator: (valueBersih2) => valueBersih2 == null
                              ? 'Pilihan Kondisi Tembok Tidak Boleh Kosong'
                              : null,
                          items: listBersih1.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    TextFormField(
                      controller: ket2,
                      validator: (String? value) {
                        if (value!.isEmpty) {
                          return 'Keterangan Tidak Boleh Kosong';
                        }
                        return null;
                      },
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'Keterangan Tembok',
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Kelistrikan: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueNyala1,
                          onChanged: (newValue) {
                            setState(() {
                              valueNyala1 = newValue as String?;
                            });
                          },
                          validator: (valueNyala1) => valueNyala1 == null
                              ? 'Pilihan Kondisi Kelistrikan Tidak Boleh Kosong'
                              : null,
                          items: listNyala1.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Lampu: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueNyala2,
                          onChanged: (newValue) {
                            setState(() {
                              valueNyala2 = newValue as String?;
                            });
                          },
                          validator: (valueNyala2) => valueNyala2 == null
                              ? 'Pilihan Kondisi Lampu Tidak Boleh Kosong'
                              : null,
                          items: listNyala1.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Atap: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueBaik1,
                          onChanged: (newValue) {
                            setState(() {
                              valueBaik1 = newValue as String?;
                            });
                          },
                          validator: (valueBaik1) => valueBaik1 == null
                              ? 'Pilihan Kondisi Atap Tidak Boleh Kosong'
                              : null,
                          items: listBaik1.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    InputDecorator(
                      decoration: InputDecoration(
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.circular(10.0)),
                          contentPadding: EdgeInsets.all(3)),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButtonFormField(
                          hint: Text('Pilih Kondisi Jendela: '),
                          icon: Icon(Icons.arrow_drop_down),
                          iconSize: 36,
                          itemHeight: 50.0,
                          value: valueBaik2,
                          onChanged: (newValue) {
                            setState(() {
                              valueBaik2 = newValue as String?;
                            });
                          },
                          validator: (valueBaik2) => valueBaik2 == null
                              ? 'Pilihan Kondisi Atap Tidak Boleh Kosong'
                              : null,
                          items: listBaik2.map((list) {
                            return DropdownMenuItem(
                              value: list['id'],
                              child: Text(list['kate']),
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    SizedBox(height: 20),
                    Padding(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 12.0),
                      child: ButtonTheme(
                        buttonColor: Colors.indigo[900],
                        minWidth: 200.0,
                        height: 50.0,
                        textTheme: ButtonTextTheme.accent,
                        colorScheme: Theme.of(context)
                            .colorScheme
                            .copyWith(secondary: Colors.white),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30.0)),
                        // ignore: deprecated_member_use
                        child: RaisedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate()) {
                              addData();
                              } else {
                                ShowToast().showToastSuccess(
                                    'Gagal data belum lengkap');
                              }
                            },
                          child: Text(
                            "Kirim",
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
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