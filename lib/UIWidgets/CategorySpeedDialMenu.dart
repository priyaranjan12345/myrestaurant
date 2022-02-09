import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'AddCategory.dart';

class CategorySpeedDialMenu extends StatelessWidget {
  const CategorySpeedDialMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      orientation: SpeedDialOrientation.Down,
      useRotationAnimation: true,
      activeForegroundColor: Colors.red,
      marginEnd: 35,
      marginBottom: Get.context.height * 0.95,
      icon: Icons.restaurant_menu_sharp,
      activeIcon: Icons.close_sharp,
      buttonSize: 56.0,
      visible: true,
      closeManually: false,
      renderOverlay: false,
      curve: Curves.bounceIn,
      overlayColor: Colors.white12,
      overlayOpacity: 0.5,
      onOpen: () => print('OPENING DIAL'),
      onClose: () => print('DIAL CLOSED'),
      tooltip: 'Speed Dial',
      heroTag: 'speed-dial-hero-tag',
      backgroundColor: Colors.yellowAccent,
      foregroundColor: Colors.black,
      elevation: 8.0,
      shape: CircleBorder(),
      children: [
        SpeedDialChild(
          child: Icon(Icons.add_sharp),
          backgroundColor: Colors.red,
          label: 'Add a Category',
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: Colors.white,
          onTap: () {
            Get.defaultDialog(
              title: "",
              content: AddaCategory(),
            );
          },
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
      ],
    );
  }
}
