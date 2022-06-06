import 'dart:async';
import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:ghulam_app/controllers/auth_controller.dart';
import 'package:ghulam_app/controllers/user_controller.dart';
import 'package:ghulam_app/models/user.dart';
import 'package:ghulam_app/screens/profile.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../utils/constants.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  late Future<User> futureDetailUser;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  final _globalKey = GlobalKey<ScaffoldMessengerState>();

  var email;
  var nama_lengkap;
  var phone;
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    futureDetailUser = UserNetwork().getProfile();
  }
  File? uploadimage; //variable for choosed file

  Future<void> chooseImage() async {
    var choosedimage = await ImagePicker.pickImage(source: ImageSource.gallery);
    //set source: ImageSource.camera to get image from camera
    setState(() {
      uploadimage = choosedimage;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffffffff),
        appBar: AppBar(
          leading: IconButton(
            icon: Icon(Icons.clear, color: kPrimaryLightColor, size: 20),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title:Text('Edit Profil', style: TextStyle(color: Colors.black, fontSize : 20),),
          elevation: 0,
          backgroundColor: Color(0xffffffff),
        ),
        body:
        FutureBuilder<User>(
          future: futureDetailUser,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              return SingleChildScrollView(
                  child: Padding(
                      padding: EdgeInsets.all(20),
                      child:
                      Form(
                          key: _formKey,
                          child:Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 115,
                                width: 115,
                                child: Stack(
                                  fit: StackFit.expand,
                                  clipBehavior: Clip.none,
                                  children: [
                                    if(uploadimage == null&&snapshot.data!.photo_path!=null)
                                      CircleAvatar(
                                          backgroundImage: NetworkImage(IMG_URL+snapshot.data!.photo_path)
                                      )
                                    else if(uploadimage == null&&snapshot.data!.photo_path==null)
                                      CircleAvatar(backgroundImage: AssetImage('images/user.png')
                                      )
                                    else
                                      CircleAvatar(
                                        backgroundImage: Image.file(uploadimage!).image,
                                      ),
                                    Positioned(
                                      right: -16,
                                      bottom: 0,
                                      child: SizedBox(
                                        height: 46,
                                        width: 46,
                                        child: TextButton(
                                          style: TextButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(50),
                                              side: BorderSide(color: Colors.white),
                                            ),
                                            primary: Colors.white,
                                            backgroundColor: Color(0xFFF5F6F9),
                                          ),
                                          onPressed: () {
                                            chooseImage();
                                          },
                                          child: Icon(Icons.camera_alt, color: Colors.grey),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 40,
                              ),
                              TextFormField(
                                initialValue: '${snapshot.data!.first_name} ${snapshot.data!.last_name}',
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nama lengkap tidak boleh kosong';
                                  }
                                  nama_lengkap = value;

                                  return null;
                                },
                                keyboardType: TextInputType.text,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.person),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14),
                                      onTap: () {
                                        nama_lengkap = '';
                                      }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'Nama lengkap',
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                initialValue: '${snapshot.data!.email}',

                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'E-Mail tidak boleh kosong';
                                  }
                                  email = value;

                                  return null;
                                },
                                keyboardType: TextInputType.emailAddress,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.email),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14),
                                      onTap: () {
                                        email = '';
                                      }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'E-Mail',
                                ),
                              ),
                              const SizedBox(height: 15),
                              TextFormField(
                                initialValue: '${snapshot.data!.phone}',
                                // The validator receives the text that the user has entered.
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Nomor Telepon tidak boleh kosong';
                                  }
                                  phone = value;

                                  return null;
                                },
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  icon: Icon(Icons.phone),
                                  suffixIcon: InkWell(
                                      child: Icon(Icons.clear, size: 14),
                                      onTap: () {
                                        phone = '';
                                      }),
                                  focusedBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  enabledBorder: UnderlineInputBorder(
                                    borderSide: BorderSide(
                                        color: kPrimaryLightColor, width: 2),
                                  ),
                                  errorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  focusedErrorBorder: UnderlineInputBorder(
                                    borderSide:
                                    BorderSide(color: Colors.red, width: 2),
                                  ),
                                  hintText: 'Nomor telepon',
                                ),
                              ),

                              SizedBox(
                                height: 25,
                              ),

                              GestureDetector(
                                  onTap: () {
                                    if (_formKey.currentState!.validate()) {
                                      _updateProfil();
                                    }
                                  },
                                  child: Container(
                                    height: 50,
                                    margin: EdgeInsets.symmetric(horizontal: 50),
                                    decoration: BoxDecoration(
                                      color: kPrimaryColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Center(
                                      child: Text(
                                        _isLoading? 'Memuat...' : 'Update',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ))
                            ],
                          ))

                  ));
            } else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            // By default, show a loading spinner.
            return const Center(child : CircularProgressIndicator());
          },
        )

    );
  }
  void _updateProfil()
  async{
    SharedPreferences localStorage = await SharedPreferences.getInstance();
    Map<String,String> data = {};
    setState(() {
      _isLoading = true;
    });
    var lastName = '';
    var parts = nama_lengkap.split(" ");
    var firstName = parts[0];
    parts.removeAt(0);
    lastName = parts.join(" ");
    if (lastName != '') {
      data = {
        'email': email,
        'first_name': firstName,
        'last_name': lastName,
        'phone': phone
      };
    } else {
      data = {
        'email': email,
        'first_name': firstName,
        'phone': phone
      };
    }
    var body = await AuthController().updateProfile(uploadimage, data, '/update/profile');
    if(body["success"]==true){
      Navigator.push(
        context,
        new MaterialPageRoute(
            builder: (context) => ProfilePage()
        ),
      );
    } else {
      Alert(
        context: context,
        type: AlertType.error,
        title: "Gagal Update!",
        desc: "Pastikan data yang dimasukkan benar.",
        buttons: [
          DialogButton(
            child: Text(
              "OK",
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            onPressed: () => Navigator.pop(context),
            width: 120,
          )
        ],
      ).show();
    }
  }
}