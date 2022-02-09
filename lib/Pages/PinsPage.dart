import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../Services/FirebaseDBService.dart';
import '../UIWidgets/AddLocation.dart';

class PinsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      extendBodyBehindAppBar: true,
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Text("Deliverable Pins"),
        elevation: 0,
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(15.0),
        child: FloatingActionButton(
          onPressed: () {
            Get.defaultDialog(title: "", content: AddLocation());
          },
          child: Icon(Icons.add_location_alt_rounded),
        ),
      ),
      body: Container(
        child: Stack(
          children: [
            Align(
                alignment: Alignment.center,
                child: StreamBuilder<DocumentSnapshot<Map<String, dynamic>>>(
                  stream: FirebaseFirestore.instance
                      .collection("restaurants")
                      .doc(FirebaseAuth.instance.currentUser.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Text("Error ${snapshot.error}");
                    }
                    if (!snapshot.hasData &&
                        snapshot.connectionState == ConnectionState.done) {
                      return Text("No data");
                    }
                    if (snapshot.hasData) {
                      var doc = snapshot.data;

                      List<String> deliverablepins = new List<String>.from(
                          doc.get("userinfo.deliverablepins"));
                      //print(deliverablepins.length);
                      if (deliverablepins.length == 0) {
                        return Text("No pin codes added yet");
                      } else {
                        return ListView.builder(
                          itemCount: deliverablepins.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 9,
                              child: ListTile(
                                dense: true,
                                leading: Text(deliverablepins[index]),
                                trailing: IconButton(
                                    onPressed: () async {
                                      var isdeleted =
                                          await RestaurantDBService().deletAPin(
                                              deliverablepins[index]);
                                      print("deleted $isdeleted");
                                    },
                                    icon: Icon(
                                      Icons.delete,
                                      color: Colors.redAccent,
                                    )),
                              ),
                            );
                          },
                        );
                      }
                    }
                    return CircularProgressIndicator();
                  },
                ))
          ],
        ),
      ),
    );
  }
}
