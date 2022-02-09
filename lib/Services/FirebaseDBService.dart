import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

FirebaseFirestore firestore = FirebaseFirestore.instance;
CollectionReference restaurants = firestore.collection('restaurants');
CollectionReference orders = firestore.collection("orders");
FirebaseAuth auth = FirebaseAuth.instance;
ConfirmationResult confirmationResult;

Future<bool> isRestaurant({String uid}) async {
  var restdocs = await restaurants.where('uid', isEqualTo: uid).get();
  if (restdocs.docs.length == 1) {
    print("Restaurant");
    return true;
  } else
    return false;
}

class RestaurantDBService {
  Future<bool> logout() async {
    var isloggedout = false;
    await FirebaseAuth.instance.signOut().then((value) => isloggedout = true);
    return isloggedout;
  }

  Future<bool> createAccount({
    String phoneno,
    String resturantname,
    String fssaino,
    String completeaddress,
    String pin,
    List<String> deliverablepins,
  }) async {
    //
    print("$phoneno $resturantname $fssaino $completeaddress,$pin");
    bool isCreated = false;
    var currentdatetime = DateTime.now();
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    await restdoc.set({
      "userinfo": {
        "uid": uid,
        "fssaino": fssaino,
        "phoneno": phoneno,
        "restaurant_name": resturantname,
        "restphotourl": "",
        "address": completeaddress,
        "pincode": pin,
        "deliverablepins": [],
        "created_at": currentdatetime.toString(),
      }
    }).then((value) => isCreated = true);

    return isCreated;
  }

  Future<bool> updateProfile(
      {String address, String pincode, String name}) async {
    var isupdated = false;
    await restaurants.doc(FirebaseAuth.instance.currentUser.uid).update({
      "userinfo.address": address,
      "userinfo.pincode": pincode,
      "userinfo.restaurant_name": name,
    }).then((value) => isupdated = true);
    return isupdated;
  }

  Future<bool> setProfileImageURL(String url) async {
    var isImageUrlSetted = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    await restdoc.update({"userinfo.restphotourl": url}).then(
        (value) => isImageUrlSetted = true);
    return isImageUrlSetted;
  }

  Future<bool> addPin(String pin) async {
    var isAdded = false;
    await restaurants.doc(FirebaseAuth.instance.currentUser.uid).update({
      "userinfo.deliverablepins": FieldValue.arrayUnion([pin])
    }).then((value) => isAdded = true);
    return isAdded;
  }

  Future<bool> isExistingPin(String pin) async {
    var isexisting = false;
    await restaurants
        .where('userinfo.deliverablepins', arrayContains: pin)
        .where('userinfo.uid', isEqualTo: FirebaseAuth.instance.currentUser.uid)
        .get()
        .then((QuerySnapshot querySnapshot) {
      print("Got same pin in dics " + querySnapshot.docs.length.toString());
      // print(querySnapshot.docs.first.id);
      if (querySnapshot.docs.length != 0) {
        isexisting = true;
      } else
        print("Not found");
    });

    return isexisting;
  }

  Future<bool> deletAPin(String pin) async {
    var isdeleted = false;
    await restaurants.doc(FirebaseAuth.instance.currentUser.uid).update({
      "userinfo.deliverablepins": FieldValue.arrayRemove([pin])
    }).then((value) => isdeleted = true);
    return isdeleted;
  }

  Future<String> addCategory({String catname, String caturl}) async {
    var catid = "";
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    await restdoc
        .collection("categories")
        .add({"cat_name": catname, "cat_photo": caturl}).then(
            (value) => catid = value.id);
    return catid;
  }

  Future<bool> updateCategory(
      {String catid, String caturl, String catname}) async {
    var isupdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    await restdoc
        .collection("categories")
        .doc(catid)
        .update({"cat_photo": caturl, "cat_name": catname}).then(
            (value) => isupdated = true);
    return isupdated;
  }

  Future<bool> updateCategoryName({String catid, String catname}) async {
    var isupdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    await restdoc
        .collection("categories")
        .doc(catid)
        .update({"cat_name": catname}).then((value) => isupdated = true);
    return isupdated;
  }

  Future<bool> deleteCategory({String catid}) async {
    var isdeleted = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var catdoc = restdoc.collection("categories").doc(catid);
    await catdoc.delete().then((value) => isdeleted = true).onError((error, _) {
      print(error);
      return isdeleted;
    });
    return isdeleted;
  }

  Future<bool> isexistingCategory({String name}) async {
    var isexisting = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var docs = await restdoc
        .collection("categories")
        .where('cat_name', isEqualTo: name)
        .get();
    if (docs.docs.length != 0) {
      isexisting = true;
    }
    return isexisting;
  }

  Future<bool> addItem({
    String catid,
    String itemtype,
    String itemname,
    double totalprice,
    String description,
  }) async {
    var isItemAdded = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var catdoc = restdoc.collection("categories").doc(catid);
    var items = catdoc.collection("items");
    await items.add({
      "type": itemtype,
      "name": itemname,
      "totalprice": totalprice,
      "description": description,
    }).then((value) => isItemAdded = true);
    return isItemAdded;
  }

  Future<bool> updateItem({
    String catid,
    String itemid,
    String itemname,
    String itemtype,
    String totalprice,
    String description,
  }) async {
    var isUpdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var catdoc = restdoc.collection("categories").doc(catid);
    var itemdoc = catdoc.collection("items").doc(itemid);
    await itemdoc.update({
      "id": itemid,
      "name": itemname,
      "type": itemtype,
      "totalprice": totalprice,
      "description": description
    }).then((value) => isUpdated = true);
    return isUpdated;
  }

  Future<bool> isExistingItem(
      {String catid,
      String itemname,
      String itemprice,
      String itemdescription,
      String itemtype}) async {
    var isexisting = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var catdoc = restdoc.collection("categories").doc(catid);
    var docs = await catdoc
        .collection("items")
        .where('name', isEqualTo: itemname)
        .where('totalprice', isEqualTo: itemprice)
        .where("type", isEqualTo: itemtype)
        .where("description", isEqualTo: itemdescription)
        .get();
    if (docs.docs.length != 0) {
      isexisting = true;
    }
    return isexisting;
  }

  Future<bool> deleteItem({String catid, String itemid}) async {
    var isdeleted = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var restdoc = restaurants.doc(uid);
    var catdoc = restdoc.collection("categories").doc(catid);
    var itemdoc = catdoc.collection("items").doc(itemid);
    await itemdoc
        .delete()
        .then((value) => isdeleted = true)
        .onError((error, _) {
      print(error);
      return isdeleted;
    });
    return isdeleted;
  }

  Future<bool> checkExistingRestaurant() async {
    var isexistingaccount = false;
    var user = await FirebaseAuth.instance.authStateChanges().first;
    if (user != null) {
      await restaurants
          .doc(user.uid)
          .get()
          .then((DocumentSnapshot documentSnapshot) {
        if (documentSnapshot.exists) {
          isexistingaccount = true;
        }
      });
    } else {
      print("User not verified yet");
    }

    return isexistingaccount;
  }

  Future<void> updateOrderStatus(String orderid, String status) async {
    await orders.doc(orderid).update({"status": status});
  }
   Future<bool> updateProfileImage({String imageurl}) async {
    var isupdated = false;
    var uid = FirebaseAuth.instance.currentUser.uid;
    var userdoc = restaurants.doc(uid);
    await userdoc.update({"userinfo.restphotourl": imageurl}).then(
        (value) => isupdated = true);
    return isupdated;
  }
}
