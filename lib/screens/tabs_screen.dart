import 'package:flutter/material.dart';
import 'package:itm_cheffapp/screens/linelist_screen.dart';

import 'package:itm_cheffapp/screens/work_time_screen.dart';
import 'package:remixicon/remixicon.dart';

class TabsScreen extends StatefulWidget {
  const TabsScreen({super.key,required this.lineId});
 final int lineId;

  @override
  State<TabsScreen> createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabsScreen> {


  int selectedPageIndex = 0;
  @override
  void selectPage(int index){
    setState(() {
      selectedPageIndex = index;
    });

  }



  Widget build(BuildContext context) {
    Widget activePage =LineListScreen(userId: widget.lineId,);
if(selectedPageIndex == 0){

 Widget activePage = LineListScreen(userId: widget.lineId,);
}
else {
 activePage =const WorkTimeScreen();
}
    return Scaffold(
      body: activePage,
      
bottomNavigationBar: BottomNavigationBar(currentIndex: selectedPageIndex,onTap: (value) {
  selectPage(value);
},items: const [
  BottomNavigationBarItem(icon: Icon(Icons.line_axis),label: "Bant Listesi"),
   BottomNavigationBarItem(icon: Icon(Remix.opera_fill),label: "Operatör Listesi"),
]),
      
    );
  }
}