import 'package:flutter/material.dart';

import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Services/FirebaseDBService.dart';

class AddLocation extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final pincontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height * 0.2,
      width: Get.context.width * 0.6,
      color: Colors.white24,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Add a Location",
                style: GoogleFonts.workSans(
                    fontWeight: FontWeight.bold, fontSize: 18),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 30),
              child: Form(
                  key: _formKey,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        controller: pincontroller,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        maxLength: 6,
                        validator: ValidationBuilder()
                            .minLength(6)
                            .maxLength(6)
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
                      ElevatedButton(
                          onPressed: () async {
                            if (_formKey.currentState.validate()) {
                              var pin = pincontroller.text;
                              if (await RestaurantDBService()
                                  .isExistingPin(pin)) {
                                Get.snackbar(
                                    "Already added", "$pin added already");
                              } else {
                                var isAdded =
                                    await RestaurantDBService().addPin(pin);

                                if (isAdded) {
                                  Get.back();
                                  Get.snackbar(
                                      "Added", "Pin Added Successfully");
                                } else {
                                  print("Failed to add");
                                  Get.snackbar("Failed", "Failed to add");
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
                          child: Text("Add Location"))
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
