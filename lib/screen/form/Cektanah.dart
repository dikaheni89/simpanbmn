// ignore_for_file: file_names, avoid_unnecessary_containers, prefer_const_constructors, prefer_const_constructors_in_immutables, unused_field, avoid_print, non_constant_identifier_names

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';
import 'package:sistemsimpanbmn/widgets/ShowToast.dart';

class Cektanah extends StatefulWidget {
  Cektanah({Key? key, required this.idmoni, required this.idinvents}) : super(key: key);
  final String idmoni;
  final String idinvents;
  @override
  State<Cektanah> createState() => _CektanahState();
}

class _CektanahState extends State<Cektanah> {
  File? _image;
  final _formKey = GlobalKey<FormState>();
  final picker = ImagePicker();
  TextEditingController pemanfaatan = TextEditingController();
  TextEditingController jenis_tumbuhan = TextEditingController();

  Future getImageGallery() async {
    var imageFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _image = File(imageFile.path);
      }
    });
  }

  Future getImageCamera() async {
    var imageFile = await picker.getImage(source: ImageSource.camera);
    setState(() {
      if (imageFile != null) {
        _image = File(imageFile.path);
      }
    });
  }

  Future upload(File imageFile, String idmoni, String idinvents) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var uri = Uri.parse("https://simpanbmnatrbpn.id/api/savetanah");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("file_image", stream, length,
        filename: basename(imageFile.path));
    request.fields['pemanfaatan'] = pemanfaatan.text;
    request.fields['jenis_tumbuhan'] = jenis_tumbuhan.text;
    request.fields['idmoni'] = widget.idmoni;
    request.fields['idinvent'] = widget.idinvents;
    request.files.add(multipartFile);

    var response = await request.send();

    if (response.statusCode == 200) {
      ShowToast().showToastSuccess('Berhasil Tersimpan');
      setState(() {
        Navigator.pushAndRemoveUntil(
            this.context,
            MaterialPageRoute(
              builder: (context) =>
                  BottomScreen(),
            ),
            (route) => false);
      });
    } else {
      print(response.statusCode);
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: (() => onWillPop()),
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
                Padding(
                  padding: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Container(
                        alignment: Alignment.center,
                        padding: EdgeInsets.all(10),
                        child: Text(
                          'Cek Asset Tanah',
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontWeight: FontWeight.w500,
                              fontSize: 30),
                        ),
                      ),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: pemanfaatan,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Pemanfaatan Tidak Boleh Kosong';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Pemanfaatan Lahan',
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            TextFormField(
                              controller: jenis_tumbuhan,
                              validator: (String? value) {
                                if (value!.isEmpty) {
                                  return 'Jenis Tumbuhan Tidak Boleh Kosong';
                                }
                                return null;
                              },
                              decoration: const InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: 'Jenis Tumbuhan',
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 12.0),
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      _PostButton(
                                        icon: Icon(
                                          Icons.image,
                                          color: Colors.grey[600],
                                          size: 50.0,
                                        ),
                                        label: 'Gallery',
                                        onTap: getImageGallery,
                                      ),
                                      _PostButton(
                                        icon: Icon(
                                          Icons.camera,
                                          color: Colors.grey[600],
                                          size: 50.0,
                                        ),
                                        label: 'Camera',
                                        onTap: getImageCamera,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 10.0,
                            ),
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
                                      upload(_image!, widget.idmoni, widget.idinvents);
                                      if (_image != null) {
                                        
                                      } else {
                                        ShowToast().showToastSuccess(
                                            'Gagal di Posting Gambar belum dimasukan');
                                      }
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
                    ],
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
            this.context,
            MaterialPageRoute(
              builder: (context) => BottomScreen(),
            ),
            (route) => false)) ??
        false;
  }
}

class _PostButton extends StatelessWidget {
  final Icon icon;
  final String label;
  final VoidCallback onTap;

  const _PostButton({
    Key? key,
    required this.icon,
    required this.label,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.white,
        child: InkWell(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            height: 50.0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                icon,
                const SizedBox(width: 4.0),
                Text(label),
              ],
            ),
          ),
        ),
      ),
    );
  }
}