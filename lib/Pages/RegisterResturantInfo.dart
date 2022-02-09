import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/FirebaseDBService.dart';

class RegisterRestaurantInfo extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  //
  static final fssainocontroller = TextEditingController();
  static final namecontroller = TextEditingController();
  static final completeaddresscontroller = TextEditingController();
  static final pincontroller = TextEditingController();

  //
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: context.height * 0.8,
          width: context.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                  flex: 1,
                  child: Padding(
                    padding: EdgeInsets.only(top: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Register Restaurant Info",
                          style: GoogleFonts.raleway(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  )),
              Expanded(
                  flex: 10,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        vertical: 80, horizontal: 20),
                    child: Form(
                        //autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Expanded(flex: 3, child: restaurantnametextfield()),
                            Expanded(flex: 3, child: fssaiTextField()),
                            Expanded(flex: 3, child: addressextField()),
                            Expanded(flex: 3, child: pinTextField()),
                            Expanded(flex: 1, child: registerRestaurantButton())
                          ],
                        )),
                  ))
            ],
          ),
        ),
      ),
    );
  }

  Container registerRestaurantButton() {
    return Container(
      width: Get.context.width * 0.8,
      height: 70,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState.validate()) {
            var restdbservice = RestaurantDBService();
            if (await restdbservice.checkExistingRestaurant()) {
              Get.toNamed("/dashboard");
            } else {
              var isAccountCreated = await restdbservice.createAccount(
                  completeaddress: completeaddresscontroller.text,
                  resturantname: namecontroller.text,
                  fssaino: fssainocontroller.text,
                  phoneno: FirebaseAuth.instance.currentUser.phoneNumber,
                  pin: pincontroller.text);
              if (isAccountCreated) {
                print("Account created successfully");
                Get.offNamed("/dashboard");
              } else {
                Get.snackbar("Failed", "account creation failed");
              }
            }
          }
        },
        style: ElevatedButton.styleFrom(
            elevation: 8,
            primary: Colors.blue,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            )),
        child: Text(
          "Register Restaurant",
          style: GoogleFonts.openSans(fontSize: 20),
        ),
      ),
    );
  }

  TextFormField pinTextField() {
    return TextFormField(
      controller: pincontroller,
      keyboardType: TextInputType.number,
      obscureText: false,
      maxLength: 6,
      validator: pinvalidator,
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
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  TextFormField addressextField() {
    return TextFormField(
      controller: completeaddresscontroller,
      keyboardType: TextInputType.text,
      obscureText: false,
      validator: addressvalidator,
      onSaved: (newValue) => completeaddresscontroller.text = newValue,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: Colors.blueAccent),
        hintText: "Enter Your Address",
        labelText: "Address",
        labelStyle: TextStyle(color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  TextFormField fssaiTextField() {
    return TextFormField(
      controller: fssainocontroller,
      keyboardType: TextInputType.number,
      obscureText: false,
      validator: fssaivalidator,
      maxLength: 14,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      onSaved: (newValue) => fssainocontroller.text = newValue,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: Colors.blueAccent),
        hintText: "Enter FSSAI License Number",
        labelText: "FSSAI License Number",
        labelStyle: TextStyle(color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }

  TextFormField restaurantnametextfield() {
    return TextFormField(
      controller: namecontroller,
      keyboardType: TextInputType.text,
      obscureText: false,
      validator: namevalidator,
      onSaved: (newValue) => namecontroller.text = newValue,
      style: TextStyle(color: Colors.black),
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.always,
        alignLabelWithHint: true,
        counterStyle: TextStyle(color: Colors.blueAccent),
        hintText: "Enter Restaurant Name",
        labelText: "RestaurantName",
        labelStyle: TextStyle(color: Colors.blueAccent),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0)),
            borderSide: BorderSide(color: Colors.blueAccent, width: 2)),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0)),
          borderSide: BorderSide(color: Colors.blueAccent, width: 2),
        ),
      ),
    );
  }
}

String namevalidator(String name) {
  if (name.length < 3) {
    return "Name must be more than 3 character";
  } else {
    return null;
  }
}

String fssaivalidator(String value) {
  if (value.length == 14) {
    return null;
  } else
    return "License no is not valid";
}

String addressvalidator(String address) {
  if (address.length < 3) {
    return "Invalid address";
  } else
    return null;
}

String pinvalidator(String pin) {
  if (pin.length < 6) {
    return "Pin length must be 6 digit";
  } else if (pin.length == 6) {
    return null;
  }
  return "";
}
