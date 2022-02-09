import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:myrestaurant/Services/StorageServices.dart';
import 'package:myrestaurant/UIWidgets/AllWidgets.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:widget_circular_animator/widget_circular_animator.dart';

import '../../Services/FirebaseDBService.dart';
import '../UpdateProfile.dart';

class DashbaordProfile extends StatelessWidget {
  final darkmode = false.obs;

  @override
  Widget build(BuildContext context) {
    return Container(
        height: Get.context.height,
        width: Get.context.width,
        //color: Colors.white24,
        child: Stack(children: [
          Align(
              child: Padding(
                  padding: EdgeInsets.only(top: 0),
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
                        var pincode = doc.get("userinfo.pincode");
                        var fssaino = doc.get("userinfo.fssaino");
                        var phoneno = doc.get("userinfo.phoneno");
                        var photourl = doc.get("userinfo.restphotourl");
                        var restaurantname =
                            doc.get("userinfo.restaurant_name");
                        var address = doc.get("userinfo.address");
                        List<String> deliverablepins = new List<String>.from(
                            doc.get("userinfo.deliverablepins"));
                        // print(deliverablepins);

                        return buildRestaurantProfile(
                            photourl,
                            restaurantname,
                            fssaino,
                            phoneno,
                            pincode,
                            address,
                            deliverablepins.toList());
                      }
                      return CircularProgressIndicator();
                    },
                  )))
        ]));
  }

  Container buildRestaurantProfile(photourl, restaurantname, fssaino, phoneno,
      pincode, address, List<String> deliverablepins) {
    return Container(
        height: Get.context.height,
        width: Get.context.width,
        alignment: Alignment.topCenter,
        child: Stack(
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                //color: Colors.white24,
                child: Stack(
                  children: [
                    Align(
                      alignment: Alignment.topLeft,
                      child: Padding(
                          padding: const EdgeInsets.only(
                            left: 20,
                            top: 50,
                          ),
                          child: Container(
                            height: 90,
                            width: 90,
                            child: photourl == "null" ||
                                    photourl.toString().isEmpty ||
                                    photourl == null
                                ? FlutterLogo(
                                    size: 60,
                                  )
                                : Stack(
                                    children: [
                                     
                                      WidgetCircularAnimator(
                                        innerAnimation: Curves.easeInExpo,
                                        outerAnimation: Curves.linear,
                                        child: Container(
                                          height: 40,
                                          width: 40,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              image: DecorationImage(
                                                  image: NetworkImage(photourl),
                                                  fit: BoxFit.contain),
                                              color: Colors.grey[200]),
                                        ),
                                      ),
                                       buildEditIcon(),
                                    ],
                                  ),
                          )),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 30),
                        child: Text(
                          restaurantname,
                          style: GoogleFonts.cairo(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 25),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 80),
                        child: Text(
                          phoneno,
                          style: GoogleFonts.cairo(
                              color: Colors.blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ),
                      ),
                    ),
                    Align(
                      alignment: Alignment.topCenter,
                      child: Padding(
                          padding: const EdgeInsets.only(top: 110),
                          child: ElevatedButton(
                            onPressed: () async {
                              if (await RestaurantDBService().logout()) {
                                Get.offAllNamed("/");
                              }
                            },
                            child: Text("Sign Out"),
                          )),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.topCenter,
              child: Padding(
                padding: const EdgeInsets.only(top: 170),
                child: Obx(() => SettingsList(
                      // backgroundColor: Colors.white,
                      sections: [
                        SettingsSection(
                          title: 'Account Settings',
                          tiles: [
                            SettingsTile(
                              title: 'Update Profile',
                              titleTextStyle: GoogleFonts.titilliumWeb(
                                color: Colors.blue,
                              ),
                              leading: Icon(
                                Icons.account_circle_outlined,
                                color: Colors.blue,
                              ),
                              onPressed: (context) {
                                print("Profile Update");
                                Get.to(() => UpdateProfilePage(
                                      name: restaurantname,
                                      address: address,
                                      pin: pincode,
                                    ));
                              },
                            ),
                            SettingsTile(
                              title: 'Deliverable Pins',
                              titleTextStyle: GoogleFonts.titilliumWeb(
                                color: Colors.blue,
                              ),
                              leading: Icon(
                                Icons.location_pin,
                                color: Colors.blue,
                              ),
                              onPressed: (context) {
                                print("Deliverable pins");
                                Get.toNamed("/pins");
                              },
                            ),
                          ],
                        ),
                        SettingsSection(
                          title: 'App Settings',
                          tiles: [
                            SettingsTile.switchTile(
                              title: 'Dark Mode',
                              titleTextStyle: GoogleFonts.titilliumWeb(
                                color: Colors.blue,
                              ),
                              leading: Icon(
                                Icons.brightness_2_outlined,
                                color: Colors.blue,
                              ),
                              switchValue: darkmode.value,
                              onToggle: (bool value) {
                                darkmode.toggle();
                                // Get.changeThemeMode(Get.isDarkMode
                                //     ? ThemeMode.light
                                //     : ThemeMode.dark);
                              },
                            ),
                          ],
                        ),
                      ],
                    )),
              ),
            ),
          ],
        ));
  }

  buildLogout() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            primary: Colors.amber[800],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          ),
          onPressed: () async {
            if (await RestaurantDBService().logout()) {
              print("User signed out");
              Get.snackbar("Restaurant Signed Out", "Successfully signed out");
              Get.offAllNamed("/login");
            } else {
              print("failed to signout");
              Get.snackbar("Signout Failed", "Failed to sign out restaurant");
            }
          },
          child: Text("Logout")),
    );
  }

  buildEditIcon() {
    return Positioned(
      right: -10,
      bottom: 0,
      child: IconButton(
        onPressed: () async {
          var originalimagepath = await pickaimage();
          var restid = FirebaseAuth.instance.currentUser.uid;
          if (!originalimagepath.isBlank) {
            showLoading();
            var compressimagepath =
                await compressImage(imagepath: originalimagepath);

            if (!compressimagepath.isBlank) {
              var imageurl = await uploadRestaurantProfileImage(
                  restid: restid, path: compressimagepath);
              var isupdated = await RestaurantDBService()
                  .updateProfileImage(imageurl: imageurl);
              if (isupdated) {
                Get.back();
                Get.snackbar("Profile Updated Successfully", "");
              } else {
                Get.snackbar("Failed to update profile", "");
              }
            } else {
              Get.snackbar("Compress image path is blank", "");
            }
          }
        },
        icon: Icon(
          Icons.add_a_photo_outlined,
          color: Colors.amber,
        ),
      ),
    );
  }
}
