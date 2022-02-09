import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';

import '../Controllers/CategoryController.dart';
import '../Pages/FullCategoryItemPage.dart';
import '../Services/FirebaseDBService.dart';
import 'EditCategory.dart';

class DesignCategory extends StatelessWidget {
  final String catid;
  final String catname;
  final String catphoto;
  DesignCategory({this.catid, this.catname, this.catphoto});
  final CategoryController categoryController = Get.find();
  @override
  Widget build(BuildContext context) {
    return InkWell(
      splashColor: Colors.yellow,
      onTap: () {
        categoryController.catid.value = catid;
        categoryController.catname.value = catname;
        categoryController.catphotourl.value = catphoto;
        Get.to(() => FullCategoryItemPage(
              catid: catid,
            ));
      },
      child: Container(
          height: Get.context.height * 0.1,
          width: Get.context.width * 0.4,
          child: Stack(
            children: [
              //Box
              Positioned(
                right: 30,
                top: 50,
                left: 30,
                child: Container(
                  height: Get.context.height * 0.2,
                  width: Get.context.width * 0.4,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(40),
                      color: Color(0xFF8C00FF).withOpacity(.09)),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20, right: 10),
                          child: IconButton(
                            onPressed: () async {
                              print("$catid $catname $catphoto");
                              Get.defaultDialog(
                                  title: "",
                                  content: EditCategory(
                                    catid: this.catid,
                                    catname: this.catname,
                                    catphoto: this.catphoto,
                                  ));
                            },
                            icon: Icon(
                              Icons.edit_sharp,
                              color: Colors.greenAccent,
                            ),
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomRight,
                        child: Padding(
                          padding: const EdgeInsets.only(bottom: 20, right: 10),
                          child: IconButton(
                            onPressed: () async {
                              print(catid);
                              var isdeleted = await RestaurantDBService()
                                  .deleteCategory(catid: catid);
                              if (isdeleted) {
                                Get.snackbar(
                                  "Category Deleted",
                                  "Successfully deleted category",
                                );
                                //snackPosition: SnackPosition.BOTTOM);
                              } else
                                Get.snackbar(
                                  "Failed to Delete",
                                  "",
                                );
                            },
                            icon: Icon(
                              Icons.delete_sharp,
                              color: Colors.redAccent,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
              //rounded background
              Positioned(
                left: 15,
                top: -50,
                child: Container(
                  height: Get.context.height * 0.25,
                  width: Get.context.width * 0.25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Color(0xFFFF0263).withOpacity(.1)),
                ),
              ),
              Positioned(
                left: 15,
                top: -50,
                child: Container(
                  height: Get.context.height * 0.25,
                  width: Get.context.width * 0.25,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        alignment: Alignment.center,
                        image: catphoto.isBlank
                            ? AssetImage(
                                "assets/noimage.png",
                              )
                            : NetworkImage(catphoto),
                        fit: BoxFit.contain,
                      )),
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Padding(
                  padding: const EdgeInsets.only(top: 50),
                  child: Text(
                    catname,
                    style: GoogleFonts.robotoMono(
                        textStyle: Theme.of(context).textTheme.headline6,
                        fontSize: 25),
                  ),
                ),
              ),

              //
              //image
            ],
          )),
    );
  }
}
