import 'package:flutter/material.dart';

import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/FirebaseDBService.dart';

class UpdateProfilePage extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final namecontroller = TextEditingController();
  static final addresscontroller = TextEditingController();
  static final pincontroller = TextEditingController();
  final String name;
  final String address;
  final String pin;
  UpdateProfilePage({this.name, this.address, this.pin});
  @override
  Widget build(BuildContext context) {
    namecontroller.text = name;
    addresscontroller.text = address;
    pincontroller.text = pin;
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Update Profile"),
        elevation: 0,
      ),
      body: Container(
        padding: EdgeInsets.all(20),
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Form(
                key: _formKey,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: namecontroller,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: ValidationBuilder().minLength(5).build(),
                        onSaved: (newValue) => namecontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Restaurant Name",
                          labelText: "Restaurant Name",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: addresscontroller,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: ValidationBuilder().minLength(5).build(),
                        onSaved: (newValue) =>
                            addresscontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Your Address",
                          labelText: "Address",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: TextFormField(
                        controller: pincontroller,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        maxLength: 6,
                        validator: ValidationBuilder()
                            .minLength(6)
                            .maxLength(6)
                            .add((value) => GetUtils.isNumericOnly(value)
                                ? null
                                : "Number only")
                            .build(),
                        onSaved: (newValue) => pincontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Pin",
                          labelText: "PIN",
                          labelStyle: TextStyle(color: Colors.blueAccent),
                          enabledBorder: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0)),
                              borderSide: BorderSide(
                                  color: Colors.blueAccent, width: 2)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0)),
                            borderSide:
                                BorderSide(color: Colors.blueAccent, width: 2),
                          ),
                        ),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState.validate()) {
                          var restdbservice = RestaurantDBService();
                          if (await restdbservice.updateProfile(
                              name: namecontroller.text,
                              address: addresscontroller.text,
                              pincode: pincontroller.text)) {
                            Get.snackbar("Profile Updated",
                                "Profile Update Successfully");
                          } else {
                            Get.snackbar('profile updation failed',
                                'Failed to update profile');
                          }
                        }
                      },
                      style: ElevatedButton.styleFrom(
                          elevation: 8,
                          primary: Colors.blueAccent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          )),
                      child: Text(
                        "Update Profile",
                        style: GoogleFonts.openSans(fontSize: 20),
                      ),
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
