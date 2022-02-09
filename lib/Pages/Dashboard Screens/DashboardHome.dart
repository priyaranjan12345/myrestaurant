import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

import '../../Services/FirebaseDBService.dart';
import '../../UIWidgets/AllWidgets.dart';

class DashboardHome extends StatelessWidget {
  final texteditingcontroller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Container(
      height: Get.context.height,
      width: Get.context.width,
      //color: Colors.red,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topRight,
            child: Padding(
              padding:
                  EdgeInsets.only(right: 0, top: Get.context.height * 0.03),
              child: buildFloatingSearchBar(),
            ),
          ),
          Align(
            alignment: Alignment.topCenter,
            child: Padding(
                padding:
                    EdgeInsets.only(right: 0, top: Get.context.height * 0.09),
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection("orders")
                      .where('restid',
                          isEqualTo: FirebaseAuth.instance.currentUser.uid)
                      .where('status', isEqualTo: "Placed")
                      .orderBy('time', descending: true)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.hasError) {
                      return Center(child: Text('Something went wrong'));
                    }
                    if (snapshot.hasData) {
                      var orderdocs = snapshot.data.docs;
                      if (orderdocs.length != 0) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 2,vertical:10),
                          child: ListView.builder(
                            shrinkWrap: true,
                            itemCount: orderdocs.length,
                            itemBuilder: (context, index) {
                              var orderdoc = orderdocs[index];
                              var orderid = orderdoc.id;
                              var userid = orderdoc.get('userid');
                              var orderstatus = orderdoc.get('status');
                              var useraddress = orderdoc.get('address');
                              Timestamp timestamp = orderdoc.get('time');
                              var datetime = DateFormat.yMMMd()
                                  .add_jm()
                                  .format(timestamp.toDate());
                              var totalquantity =
                                  orderdoc.get('total_quantity');
                              var totalprice = orderdoc.get('total');
                              var paymentType = orderdoc.get('payment_type');
                              return Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: ExpansionTile(
                                  backgroundColor: Colors.amberAccent,
                                  collapsedBackgroundColor: Colors.amber,
                                  title: ordersMainContent(
                                      userid,
                                      datetime,
                                      orderid,
                                      orderstatus,
                                      paymentType,
                                      totalquantity,
                                      totalprice,
                                      useraddress),
                                  subtitle: actionContainer(orderid),
                                  children: [allItems(orderid)],
                                ),
                              );
                            },
                          ),
                        );
                      } else {
                        return Center(
                            child: Text(
                                "No Orders Placed yet.\nFor other orders visit order history."));
                      }
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  },
                )),
          ),
        ],
      ),
    );
  }

  Widget buildFloatingSearchBar() {
    return FloatingSearchBar(
      hint: 'Search Orders',
      scrollPadding: const EdgeInsets.only(top: 16, bottom: 0),
      transitionDuration: const Duration(milliseconds: 200),
      transitionCurve: Curves.easeInOut,
      physics: const BouncingScrollPhysics(),
      axisAlignment: 0.0,
      openAxisAlignment: 0.0,
      width: Get.context.width,
      debounceDelay: const Duration(milliseconds: 00),
      closeOnBackdropTap: true,
      hintStyle: GoogleFonts.ubuntu(fontWeight: FontWeight.bold),
      onQueryChanged: (query) {
        // Call your model, bloc, controller here.
      },
      // Specify a custom transition to be used for
      // animating between opened and closed stated.
      transition: CircularFloatingSearchBarTransition(),
      actions: [
        FloatingSearchBarAction.back(
          showIfClosed: false,
        ),
      ],
      builder: (context, transition) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Material(
            color: Colors.amber.shade100,
            elevation: 4.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: Colors.accents.map((color) {
                return Container(
                    height: Get.context.height, color: Colors.amber.shade100);
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Container actionContainer(orderid) {
    return Container(
      height: 60,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        // mainAxisSize: MainAxisSize.min,
        children: [
          ElevatedButton(
              onPressed: () async {
                print("Accept $orderid");
                await RestaurantDBService()
                    .updateOrderStatus(orderid, "Accepted");
                Get.snackbar("Order Accepted", "Order $orderid accepted ");
              },
              child: Text("Accept Order")),
          Padding(
            padding: const EdgeInsets.only(left: 50),
            child: ElevatedButton(
                onPressed: () async {
                  print("Cancel $orderid");
                  await RestaurantDBService()
                      .updateOrderStatus(orderid, "Cancelled by restaurant");
                  Get.snackbar("Order Cancelled", "Order $orderid cancelled");
                },
                child: Text("Cancel Order ")),
          ),
        ],
      ),
    );
  }
}
