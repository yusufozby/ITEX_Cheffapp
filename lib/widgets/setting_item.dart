import 'package:flutter/material.dart';
import 'package:itm_cheffapp/models/Setting.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({super.key,required this.setting,required this.openModal});
  final Setting setting;
  final VoidCallback openModal;

  @override
  Widget build(BuildContext context) {
    return     ListTile(
title: Text(setting.title,style:const TextStyle(fontSize: 20),),
subtitle:Text(setting.subtitle,style:const TextStyle(fontSize: 16),),
 shape: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5)),
onTap:openModal,
    );
  }
}