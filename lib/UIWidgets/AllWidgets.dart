import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:cool_alert/cool_alert.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

StreamBuilder<QuerySnapshot<Map<String, dynamic>>> allItems(String orderid) {
  return StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
    stream: FirebaseFirestore.instance
        .collection("orders")
        .doc(orderid)
        .collection("items")
        .snapshots(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text('Something went wrong'));
      }
      if (snapshot.hasData) {
        var items = snapshot.data.docs;
        if (items.length != 0) {
          return ListView.builder(
            shrinkWrap: true,
            itemCount: items.length,
            itemBuilder: (context, index) {
              var item = items[index];

              return ListTile(
                leading: Text("${index + 1}"),
                title: Text("${item.get('itemname')}"),
                subtitle: Text("${item.get('description')}"),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("${item.get("quantity")}"),
                    Text("   X   "),
                    Text("₹ ${item.get("itemprice")}"),
                    Text("   =   "),
                    Text(" ₹ ${item.get("subtotal")}"),
                  ],
                ),
              );
            },
          );
        } else {
          return Text("No Items");
        }
      }
      return Center(
        child: CircularProgressIndicator(),
      );
    },
  );
}

//
Container ordersMainContent(userid, String datetime, String orderid,
    orderstatus, paymentType, totalquantity, totalprice, useraddress) {
  return Container(
    height: 160,
    width: Get.context.width,
    //color: Colors.red,
    child: Card(
      elevation: 9,
      child: Stack(
        children: [
          Align(
            alignment: Alignment.topLeft,
            child: ListView(
              shrinkWrap: true,
              children: [
                username(userid),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text("Address : $useraddress"),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8, top: 2),
                  child: orderTime(datetime),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomLeft,
            child: orderID(orderid),
          ),
          Align(
            alignment: Alignment.topRight,
            child: orderStatus(
              orderstatus,
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "Payment : $paymentType",
                style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                  "  Total Quantity: $totalquantity   Total: ₹ $totalprice"),
            ),
          )
        ],
      ),
    ),
  );
}
//

Padding orderID(String orderid) {
  return Padding(
    padding: const EdgeInsets.all(4.0),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: Text(
            "Order ID:$orderid ",
            style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}

Text orderTime(String datetime) {
  return Text("Time: ${datetime.toString()}");
}

FutureBuilder<DocumentSnapshot<Map<String, dynamic>>> username(userid) {
  return FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
    future: FirebaseFirestore.instance.collection("users").doc(userid).get(),
    builder: (context, snapshot) {
      if (snapshot.hasError) {
        return Center(child: Text("Error in data"));
      }
      if (snapshot.hasData) {
        var isUserdoc = snapshot.data.exists;
        if (isUserdoc) {
          var userdoc = snapshot.data;
          var username = userdoc.get('userinfo.name');
          var userphone = userdoc.get('userinfo.phoneno');

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView(
              shrinkWrap: true,
              children: [
                Text(
                  "From : $username",
                  style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: Text(
                    "Mobile number : $userphone",
                    style: GoogleFonts.nunito(fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
          );
        } else
          return Text("No user found");
      }
      return Text("No data");
    },
  );
}

//
Padding orderStatus(orderstatus) {
  if (orderstatus == "Placed") {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style: GoogleFonts.nunito(
            color: Colors.green, fontWeight: FontWeight.bold),
      ),
    );
  }
  if (orderstatus.toString().toLowerCase().contains("cancel")) {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style:
            GoogleFonts.nunito(color: Colors.red, fontWeight: FontWeight.bold),
      ),
    );
  }
  if (orderstatus == "Accepted") {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style:
            GoogleFonts.nunito(color: Colors.blue, fontWeight: FontWeight.bold),
      ),
    );
  }
  if (orderstatus == "Preparing") {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style: GoogleFonts.nunito(
            color: Colors.amber, fontWeight: FontWeight.bold),
      ),
    );
  }
  if (orderstatus == "Pickedup") {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style: GoogleFonts.nunito(
            color: Colors.purple, fontWeight: FontWeight.bold),
      ),
    );
  }
  if (orderstatus == "Delivered") {
    return Padding(
      padding: const EdgeInsets.only(right: 5, top: 8),
      child: Text(
        "Status : $orderstatus",
        style: GoogleFonts.nunito(
            color: Colors.indigo, fontWeight: FontWeight.bold),
      ),
    );
  }
  return Padding(
    padding: const EdgeInsets.only(right: 5, top: 8),
    child: Text(
      "Status : $orderstatus",
      style:
          GoogleFonts.nunito(color: Colors.pink, fontWeight: FontWeight.bold),
    ),
  );
}

showLoading() {
  CoolAlert.show(
    context: Get.context,
    type: CoolAlertType.loading,
    text: "Uploading Image......",
  );
}
