import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/CategoryController.dart';
import '../UIWidgets/ItemSpeedDialMenu.dart';
import '../UIWidgets/ItemsList.dart';

class FullCategoryItemPage extends StatelessWidget {
  final catid;
  final CategoryController categoryController = Get.find();

  FullCategoryItemPage({this.catid});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      floatingActionButtonLocation:
          FloatingActionButtonLocation.miniStartDocked,
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(25.0),
        child: FloatingActionButton(
          backgroundColor: Colors.yellow,
          child: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Get.back();
          },
        ),
      ),
      body: Container(
          child: Stack(
        children: [
          Align(
            alignment: Alignment.bottomRight,
            child: ItemSpeedDialMenu(),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: ListView(
                shrinkWrap: true,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                    child: Container(
                      height: Get.context.height * 0.15,
                      width: Get.context.width * 0.15,
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: categoryController.catphotourl.value.isBlank
                              ? AssetImage("assets/noimage.png")
                              : NetworkImage(
                                  categoryController.catphotourl.value,
                                ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 5, left: 20, right: 20),
                    child: Center(
                      child: Text(
                        categoryController.catname.value,
                        style: GoogleFonts.rubik(
                            fontWeight: FontWeight.bold,
                            color: Colors.deepOrange,
                            fontSize: 30),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Divider(
                      height: 5,
                      color: Colors.blue,
                      thickness: 5,
                    ),
                  ),
                ],
              )),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: EdgeInsets.only(top: Get.context.height * 0.09),
              child: ItemsList(),
            ),
          )
        ],
      )),
    );
  }
}
