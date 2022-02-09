import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../UIWidgets/CategorySpeedDialMenu.dart';
import '../../UIWidgets/ListCategoryItemsResponsive.dart';

class Categories extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height,
      width: Get.context.width,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.only(top: 50),
              child: Text(
                "Categories",
                style: GoogleFonts.raleway(
                    fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
              alignment: Alignment.topCenter,
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("restaurants")
                    .doc(FirebaseAuth.instance.currentUser.uid)
                    .collection("categories")
                    .snapshots(),
                builder: (context, snapshot) {
                  // print(snapshot.connectionState);
                  // print(snapshot.hasData);
                  if (snapshot.hasError) {
                    return Center(child: Text("Error ${snapshot.error}"));
                  }
                  if (!snapshot.hasData) {
                    return Center(child: Text("No data"));
                  }
                  if (snapshot.hasData) {
                    final List<DocumentSnapshot> documents = snapshot.data.docs;
                    if (documents.length == 0) {
                      return Center(child: Text("No Categories Added Yet "));
                    }
                    return Padding(
                      padding: const EdgeInsets.only(top: 100),
                      child: ListCategoryItemsResponsive(
                        list: documents,
                      ),
                    );
                  }

                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [CircularProgressIndicator(), Text("Loading")],
                  );
                },
              )),
          Align(
            alignment: Alignment.topRight,
            child: CategorySpeedDialMenu(),
          ),
        ],
      ),
    );
  }
}
