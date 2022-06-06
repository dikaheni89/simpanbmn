// ignore_for_file: file_names, prefer_const_constructors, non_constant_identifier_names, avoid_print

import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:sistemsimpanbmn/screen/Bottomscreen.dart';
import 'package:sistemsimpanbmn/screen/Profilscreen.dart';
import 'package:sistemsimpanbmn/widgets/ShowToast.dart';

class EditProfilScreen extends StatefulWidget {
  final String idusers, alamat, photo, email, phone, full_name;
  const EditProfilScreen(
      {Key? key,
      required this.idusers,
      required this.photo,
      required this.email,
      required this.alamat,
      required this.phone,
      required this.full_name})
      : super(key: key);

  @override
  State<EditProfilScreen> createState() => _EditProfilScreenState();
}

class _EditProfilScreenState extends State<EditProfilScreen> {
  final _formKey = GlobalKey<FormState>();
  File? _image;
  bool isPasswordVisible = true;
  final picker = ImagePicker();

  TextEditingController fullnameController = TextEditingController();
  TextEditingController alamatController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  Future getImageGallery() async {
    var imageFile = await picker.getImage(source: ImageSource.gallery);
    setState(() {
      if (imageFile != null) {
        _image = File(imageFile.path);
      }
    });
  }

  Future upload(File imageFile, String idusers) async {
    var stream = http.ByteStream(imageFile.openRead());
    var length = await imageFile.length();
    var uri = Uri.parse("https://sistemsimpan.cerdasin.id/api/updateusers");

    var request = http.MultipartRequest("POST", uri);

    var multipartFile = http.MultipartFile("file_image", stream, length,
        filename: basename(imageFile.path));
    request.fields['full_name'] = fullnameController.text;
    request.fields['alamat'] = alamatController.text;
    request.fields['email'] = emailController.text;
    request.fields['phone'] = phoneController.text;
    request.fields['password'] = passwordController.text;
    request.fields['id'] = idusers;
    request.files.add(multipartFile);

    var response = await request.send();
    if (response.statusCode == 200) {
      ShowToast().showToastSuccess('Berhasil Tersimpan');
      setState(() {
        Navigator.pushAndRemoveUntil(
            this.context,
            MaterialPageRoute(
              builder: (context) => ProfilScreen(),
            ),
            (route) => false);
      });
    } else {
      ShowToast().showToastError('Data Gagal Disimpan');
    }
    response.stream.transform(utf8.decoder).listen((value) {
      print(value);
    });
  }

  @override
  void initState() {
    fullnameController = TextEditingController(text: widget.full_name);
    alamatController = TextEditingController(text: widget.alamat);
    emailController = TextEditingController(text: widget.email);
    phoneController = TextEditingController(text: widget.phone);
    passwordController = TextEditingController();
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.indigo[900],
        elevation: 1,
        leading: IconButton(
          onPressed: () {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => ProfilScreen(),
                ),
                (route) => false);
          },
          icon: Icon(
            Icons.arrow_back,
            color: Colors.white,
          ),
        ),
      ),
      body: WillPopScope(
        onWillPop: (() => onWillPop()),
        child: Container(
          padding: EdgeInsets.only(left: 16, top: 25, right: 16),
          child: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: ListView(
              children: [
                Text(
                  'Edit Profil',
                  style: TextStyle(fontSize: 25, fontWeight: FontWeight.w500),
                ),
                SizedBox(
                  height: 15,
                ),
                Center(
                  child: Stack(
                    children: [
                      Container(
                        width: 130,
                        height: 130,
                        decoration: BoxDecoration(
                          border: Border.all(
                            width: 4,
                            color: Theme.of(context).scaffoldBackgroundColor,
                          ),
                          boxShadow: [
                            BoxShadow(
                              spreadRadius: 2,
                              blurRadius: 10,
                              color: Colors.black.withOpacity(0.1),
                              offset: Offset(0, 10),
                            ),
                          ],
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(widget.photo),
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              width: 4,
                              color: Theme.of(context).scaffoldBackgroundColor,
                            ),
                            color: Colors.indigo[900],
                          ),
                          // ignore: deprecated_member_use
                          child: InkWell(
                            onTap: getImageGallery,
                            child: Icon(
                              Icons.edit,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 35,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: fullnameController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Nama Lengkap',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Nama Lengkap',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: alamatController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Alamat',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Alamat',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: emailController,
                        obscureText: false,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'E-mail Tidak Boleh Kosong';
                          }
                          if (!RegExp(
                                  r"^([a-zA-Z0-9_\-\.]+)@([a-zA-Z0-9_\-\.]+)\.([a-zA-Z]{2,5})$")
                              .hasMatch(value)) {
                            return 'Tolong Masukan Email yang valid';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Email',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Email',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: phoneController,
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Phone',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Phone',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      TextFormField(
                        controller: passwordController,
                        obscureText: true,
                        validator: (String? value) {
                          if (value!.isEmpty) {
                            return 'Password Tidak Boleh Kosong';
                          }
                          return null;
                        },
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.only(bottom: 3),
                          labelText: 'Password',
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          hintText: 'Password',
                          hintStyle: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 35,
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // ignore: deprecated_member_use
                          OutlineButton(
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            onPressed: () {
                              Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ProfilScreen(),
                                        ),
                                        (route) => false);
                            },
                            child: Text("Cancel",
                                style: TextStyle(
                                  fontSize: 14,
                                  letterSpacing: 2.2,
                                  color: Colors.black,
                                )),
                          ),
                          // ignore: deprecated_member_use
                          RaisedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                if (_image != null) {
                                  upload(_image!, widget.idusers);
                                  
                                }else{
                                  ShowToast()
                                      .showToastSuccess('Gagal Photo Profil Belum dimasukan');
                                  setState(() {
                                    Navigator.pushAndRemoveUntil(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => EditProfilScreen(
                                              idusers: widget.idusers, alamat: widget.alamat, full_name: widget.full_name, photo: widget.photo, email: widget.email, phone: widget.phone),
                                        ),
                                        (route) => false);
                                  });
                                }
                              }
                            },
                            color: Colors.indigo[900],
                            padding: EdgeInsets.symmetric(horizontal: 50),
                            elevation: 2,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20)),
                            child: Text(
                              "Simpan",
                              style: TextStyle(
                                fontSize: 14,
                                letterSpacing: 2.2,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
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