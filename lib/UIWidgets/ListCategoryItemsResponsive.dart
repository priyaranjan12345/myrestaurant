import 'package:flutter/material.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:get/get.dart';

import 'DesignCategory.dart';

class ListCategoryItemsResponsive extends GetResponsiveView {
  final List<DocumentSnapshot> list;
  ListCategoryItemsResponsive({this.list});
  Widget phone() {
    return AnimationLimiter(
        child: GridView.builder(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 1,
        mainAxisSpacing: 0,
        crossAxisSpacing: 0,
        childAspectRatio: 1.7,
      ),
      itemCount: list.length,
      shrinkWrap: true,
      itemBuilder: (context, index) {
        var doc = list[index];
        var catid = doc.id.toString();
        var catname = doc.get("cat_name");
        var catphoto = doc.get("cat_photo");
        //print("$catid $catname $catphoto");
        return AnimationConfiguration.staggeredGrid(
            position: index,
            columnCount: 4,
            child: ScaleAnimation(
                child: FadeInAnimation(
                    child: DesignCategory(
              catid: catid,
              catname: catname,
              catphoto: catphoto,
            ))));
      },
    ));
  }
}
