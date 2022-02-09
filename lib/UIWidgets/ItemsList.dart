import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/CategoryController.dart';
import '../Controllers/ItemCootroller.dart';
import '../Services/FirebaseDBService.dart';
import 'EditItemDialog.dart';

class ItemsList extends GetResponsiveView {
  final CategoryController categoryController = Get.find();
  final ItemController itemController = Get.find();

  @override
  Widget phone() {
    return Container(
      child: StreamBuilder<QuerySnapshot>(
          stream: FirebaseFirestore.instance
              .collection("restaurants")
              .doc(FirebaseAuth.instance.currentUser.uid)
              .collection("categories")
              .doc(categoryController.catid.value)
              .collection("items")
              .snapshots(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text("Error ${snapshot.error}"));
            }
            if (!snapshot.hasData) {
              return Center(child: Text("No data"));
            }
            if (snapshot.hasData) {
              final List<DocumentSnapshot> documents = snapshot.data.docs;
              if (documents.length == 0) {
                return Center(child: Text("No items added yet"));
              } else {
                return Padding(
                  padding: const EdgeInsets.only(
                      top: 150, left: 20, right: 20, bottom: 30),
                  child: Container(
                    child: ListView.builder(
                      itemCount: documents.length,
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        var itemdoc = documents[index];
                        var itemid = itemdoc.id;
                        var name = itemdoc.get("name");
                        var description = itemdoc.get("description");
                        var totalprice = itemdoc.get('totalprice');
                        var type = itemdoc.get('type');
                        //print(itemid);
                        return Row(
                          children: [
                            Expanded(
                              flex: 5,
                              child: buildItem(
                                  name: name,
                                  itemid: itemid,
                                  description: description,
                                  totalprice: totalprice,
                                  type: type),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                );
              }
            }
            return Center(
                child: Column(
              children: [CircularProgressIndicator(), Text("Loading")],
            ));
          }),
    );
  }

  Container buildItem(
      {dynamic name,
      dynamic itemid,
      dynamic description,
      dynamic totalprice,
      dynamic type}) {
    return Container(
      width: Get.context.width * 0.3,
      height: 170,
      color: Colors.white24,
      child: Card(
        elevation: 9,
        child: Stack(
          children: [
            type == "Veg"
                ? Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10),
                      child: Image.asset(
                        "assets/veg.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                  )
                : Align(
                    alignment: Alignment.topLeft,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 15, left: 10),
                      child: Image.asset(
                        "assets/nonveg.png",
                        height: 40,
                        width: 40,
                      ),
                    ),
                  ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(left: 10, top: 8),
                child: Text(
                  name,
                  style: GoogleFonts.nunitoSans(
                      fontWeight: FontWeight.bold,
                      fontSize: 25,
                      color: Color(0xFFD419B5)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: Text(
                  "Description:$description",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Color(0xFF102AC0)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomLeft,
              child: Padding(
                padding: EdgeInsets.only(left: 10, bottom: 20),
                child: Text(
                  "Price: ₹ $totalprice",
                  style: GoogleFonts.quicksand(
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                      color: Color(0xFF28B43B)),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomRight,
              child: Container(
                width: 100,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.edit,
                          color: Colors.blue,
                        ),
                        onPressed: () {
                          itemController.catid.value =
                              categoryController.catid.value;
                          itemController.itemid.value = itemid;
                          itemController.itemname.value = name;
                          itemController.itemdescription.value = description;
                          itemController.itemprice.value =
                              totalprice.toString();
                          itemController.itemtype.value = type;
                          Get.defaultDialog(
                              title: "",
                              content: EditItemDialog(),
                              backgroundColor: Colors.white);
                        },
                      ),
                    ),
                    Expanded(
                      child: IconButton(
                        icon: Icon(
                          Icons.delete,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          print(itemid);
                          if (await RestaurantDBService().deleteItem(
                            catid: categoryController.catid.value,
                            itemid: itemid,
                          )) {
                            Get.snackbar(
                                "Item deleted", "Item deleted successfully",
                                snackPosition: SnackPosition.BOTTOM);
                          } else {
                            Get.snackbar("Failed", "Failed to delete item");
                          }
                        },
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
