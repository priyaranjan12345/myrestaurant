import 'package:flutter/material.dart';

import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:toggle_switch/toggle_switch.dart';

import '../Controllers/CategoryController.dart';
import '../Services/FirebaseDBService.dart';

class AddItemstoCategoryDialog extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  final itemnamecontroller = TextEditingController();
  final itempricecontroller = TextEditingController();
  final itemdescriptioncontroller = TextEditingController();
  final itemfoodtypes = ['Veg', 'Non-Veg'];
  final selectedfoodtype = "Veg".obs;
  final CategoryController categoryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height * 0.35,
      width: Get.context.width * 0.8,
      color: Colors.white,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Text(
              "Add a item to ${categoryController.catname.value}",
              style: GoogleFonts.workSans(
                  fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 20),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        controller: itemnamecontroller,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: ValidationBuilder()
                            .minLength(3)
                            .maxLength(40)
                            .regExp(RegExp('[a-zA-Z]'),
                                "Name must not contain other than characters")
                            .build(),
                        onSaved: (newValue) =>
                            itemnamecontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Item name",
                          labelText: "Item name",
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
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        controller: itempricecontroller,
                        keyboardType: TextInputType.number,
                        obscureText: false,
                        validator:
                            ValidationBuilder().minLength(1).add((value) {
                          if (value.isNum) {
                            return null;
                          } else
                            return "Must be a number";
                        }).build(),
                        onSaved: (newValue) =>
                            itempricecontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Price",
                          labelText: "Item Price",
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
                      padding: const EdgeInsets.only(top: 12),
                      child: TextFormField(
                        controller: itemdescriptioncontroller,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: ValidationBuilder()
                            .minLength(1)
                            .maxLength(30)
                            .build(),
                        onSaved: (newValue) =>
                            itemdescriptioncontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Description",
                          labelText: "Item Description",
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
                      padding: const EdgeInsets.only(top: 8),
                      child: Container(
                        height: 100,
                        width: 300,
                        alignment: Alignment.center,
                        child: Stack(
                          children: [
                            ToggleSwitch(
                              minWidth: 120.0,
                              minHeight: 60.0,
                              fontSize: 10.0,
                              initialLabelIndex: 0,
                              activeBgColor: Colors.green,
                              activeFgColor: Colors.white,
                              inactiveBgColor: Colors.grey,
                              inactiveFgColor: Colors.grey[900],
                              activeBgColors: [
                                Colors.green,
                                Colors.red,
                              ],
                              labels: itemfoodtypes,
                              onToggle: (index) {
                                print('switched to: $index');
                                selectedfoodtype.value = itemfoodtypes[index];
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8),
                      child: ElevatedButton(
                        style:
                            ElevatedButton.styleFrom(minimumSize: Size(50, 50)),
                        onPressed: () async {
                          if (_formKey.currentState.validate()) {
                            print(categoryController.catid.value);
                            print(itemnamecontroller.text);
                            print(itempricecontroller.text);
                            print(itemdescriptioncontroller.text);
                            print(selectedfoodtype.value);
                            var restdb = RestaurantDBService();
                            if (await restdb.isExistingItem(
                                catid: categoryController.catid.value,
                                itemdescription: itemdescriptioncontroller.text,
                                itemname: itemnamecontroller.text,
                                itemprice: itemnamecontroller.text,
                                itemtype: selectedfoodtype.value)) {
                              Get.back();
                              Get.snackbar(
                                  "Failed to add item", "Already item added");
                            } else {
                              var isAdded = await restdb.addItem(
                                  catid: categoryController.catid.value,
                                  description: itemdescriptioncontroller.text,
                                  itemname: itemnamecontroller.text,
                                  itemtype: selectedfoodtype.value,
                                  totalprice:
                                      double.parse(itempricecontroller.text));
                              if (isAdded) {
                                Get.back();
                                Get.snackbar("Item Added Successfully",
                                    "Successfully added item");
                              } else {
                                Get.back();
                                Get.snackbar("Failed", "Failed to add item");
                              }
                            }
                          }
                        },
                        child: Text("Add Item"),
                      ),
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
