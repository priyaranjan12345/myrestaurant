import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

import '../../Services/FirebaseDBService.dart';
import '../../UIWidgets/AllWidgets.dart';

class DashboardOrderHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Orders"),
        centerTitle: true,
      ),
      body: Container(
        height: Get.context.height * 0.95,
        width: Get.context.width,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                  padding: EdgeInsets.only(top: Get.context.height * 0.01),
                  child: StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("orders")
                        .where('restid',
                            isEqualTo: FirebaseAuth.instance.currentUser.uid)
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
                            padding: const EdgeInsets.symmetric(horizontal: 3),
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
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 10, horizontal: 2),
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
                                    subtitle:
                                        actionContainer(orderid, orderstatus),
                                    children: [allItems(orderid)],
                                  ),
                                );
                              },
                            ),
                          );
                        } else {
                          return Center(child: Text("No Orders Recieved yet"));
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
      ),
    );
  }

  Container actionContainer(orderid, orderstatus) {
    if (orderstatus == "Placed") {
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
    if (orderstatus == "Accepted") {
      return Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  print("Prepare $orderid");
                  await RestaurantDBService()
                      .updateOrderStatus(orderid, "Preparing");
                  Get.snackbar("Order Preparing", "Order $orderid preparing ");
                },
                child: Text("Prepare Order")),
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
    if (orderstatus == "Preparing") {
      return Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  print("Pickedup $orderid");
                  await RestaurantDBService()
                      .updateOrderStatus(orderid, "Pickedup");
                  Get.snackbar("Order Pickedup", "Order $orderid Pickedup ");
                },
                child: Text("Pickedup Order")),
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
    if (orderstatus == "Pickedup") {
      return Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  print("Delivered $orderid");
                  await RestaurantDBService()
                      .updateOrderStatus(orderid, "Delivered");
                  Get.snackbar("Order Delivered", "Order $orderid delivered");
                },
                child: Text("Delivery Order")),
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
    if (orderstatus == "Cancelled by restaurant") {
      return Container(
        height: 60,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          // mainAxisSize: MainAxisSize.min,
          children: [
            ElevatedButton(
                onPressed: () async {
                  print("Revoke $orderid");
                  await RestaurantDBService()
                      .updateOrderStatus(orderid, "Placed");
                  Get.snackbar("Order Placed", "Order $orderid Placed");
                },
                child: Text("Revoke Cancellation")),
          ],
        ),
      );
    }
    return Container();
  }
}
