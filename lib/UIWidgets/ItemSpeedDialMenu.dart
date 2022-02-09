import 'package:flutter/material.dart';

import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:get/get.dart';

import 'AddItemstoCategoryDialog.dart';

class ItemSpeedDialMenu extends StatelessWidget {
  const ItemSpeedDialMenu({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SpeedDial(
      orientation: SpeedDialOrientation.Up,
      useRotationAnimation: true,
      activeForegroundColor: Colors.red,
      marginEnd: 40,
      marginBottom: 40,
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
          label: 'Add a Item',
          labelStyle: TextStyle(fontSize: 14.0),
          labelBackgroundColor: Colors.white,
          onTap: () {
            Get.defaultDialog(
              title: "",
              backgroundColor: Colors.white,
              content: AddItemstoCategoryDialog(),
            );
          },
          onLongPress: () => print('FIRST CHILD LONG PRESS'),
        ),
      ],
    );
  }
}
