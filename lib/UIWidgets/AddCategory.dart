import 'package:flutter/material.dart';
import 'package:form_validator/form_validator.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myrestaurant/UIWidgets/AllWidgets.dart';
import 'package:path/path.dart' as p;

import '../Services/FirebaseDBService.dart';
import '../Services/StorageServices.dart';

class AddaCategory extends StatelessWidget {
  static final _formKey = GlobalKey<FormState>();
  static final categorynamecontroller = TextEditingController();
  final imagename = "".obs;
  final originalfilepath = "".obs;
  @override
  Widget build(BuildContext context) {
    return Container(
      // alignment: Alignment.center,
      height: Get.context.height * 0.35,
      width: Get.context.width * 0.6,
      color: Colors.white24,
      child: Stack(
        children: [
          Align(
              alignment: Alignment.topCenter,
              child: SelectableText(
                "Add a Category",
                style: GoogleFonts.workSans(
                    fontWeight: FontWeight.bold, fontSize: 18),
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      TextFormField(
                        controller: categorynamecontroller,
                        keyboardType: TextInputType.text,
                        obscureText: false,
                        validator: ValidationBuilder()
                            .minLength(3)
                            .maxLength(40)
                            .build(),
                        onSaved: (newValue) =>
                            categorynamecontroller.text = newValue,
                        style: TextStyle(color: Colors.black),
                        decoration: InputDecoration(
                          floatingLabelBehavior: FloatingLabelBehavior.always,
                          alignLabelWithHint: true,
                          counterStyle: TextStyle(color: Colors.blueAccent),
                          hintText: "Enter Category Name",
                          labelText: "Category name",
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
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Obx(
                          () => Text(
                            "File name: ${imagename.value}",
                            style: GoogleFonts.rubik(),
                          ),
                        ),
                      ),
                      Container(
                        height: 50,
                        width: Get.context.width * 0.8,
                        child: Padding(
                          padding: const EdgeInsets.only(top: 8.0),
                          child: ElevatedButton(
                              onPressed: () async {
                                originalfilepath.value = await pickaimage();
                                imagename.value =
                                    p.basename(originalfilepath.value);
                              },
                              child: Row(
                                children: [
                                  Expanded(
                                      flex: 4,
                                      child: Text("Upload Category Image")),
                                  Expanded(
                                    flex: 2,
                                    child: Icon(
                                      Icons.cloud_upload,
                                      color: Colors.yellow,
                                      size: 30,
                                    ),
                                  ),
                                ],
                              )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 12.0),
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.amber[900],
                          ),
                          onPressed: () async {
                            //print(_formKey.currentState);
                            if (_formKey.currentState.validate()) {
                              print(categorynamecontroller.text);
                              print(imagename.value);
                              var catname = categorynamecontroller.text;
                              var restdb = RestaurantDBService();
                              if (await restdb.isexistingCategory(
                                name: catname,
                              )) {
                                print("Category already added");
                                Get.snackbar("Duplicate Category",
                                    "Exisiting category found");
                              } else {
                                var catid = await restdb.addCategory(
                                    catname: catname, caturl: "");
                                if (originalfilepath.isBlank ||
                                    originalfilepath.value.isBlank) {
                                  print("Image not selected");
                                  Get.snackbar(
                                      "category added", "$catname added");
                                  Get.back();
                                } else {
                                  showLoading();
                                  print("Image Selcted");
                                  var compressedpath = await compressImage(
                                      imagepath: originalfilepath.value);
                                  if (compressedpath.isBlank) {
                                    print("Cannot compress image");
                                  } else {
                                    print("image compressed");
                                    var caturl = await uploadCategoryImage(
                                        catid: catid, path: compressedpath);
                                    print("got cat url $caturl");
                                    var isUpdated = await restdb.updateCategory(
                                        catid: catid,
                                        catname: catname,
                                        caturl: caturl);
                                    if (isUpdated) {
                                      print("Category added with photo");
                                      Get.back();
                                    } else {
                                      print(
                                          "Failed to add Category with photo");
                                    }
                                    Get.back();
                                  }
                                }
                              }
                            } else {
                              print("Not validated yet");
                            }
                          },
                          child: Text("Add Category"),
                        ),
                      )
                    ],
                  )),
            ),
          )
        ],
      ),
    );
  }
}
