import 'package:flutter/material.dart';
import 'package:itm_cheffapp/models/Employee.dart';

class OperatorItem extends StatelessWidget {
  const OperatorItem({super.key,required this.index,required this.employee});
  final int index;
  final Employee employee;


  @override
  Widget build(BuildContext context) {
    return
    Container(
     

     
  decoration: BoxDecoration(
    color: employee.isSelected ? Colors.blue : Colors.white,
      border:Border(
      bottom: BorderSide(color: Colors.grey),
      left: BorderSide(color: Colors.grey),
      right: BorderSide(color: Colors.grey),
      top: index == 0 ? BorderSide(color: Colors.grey) : BorderSide(width: 0,color: Colors.grey)
      )
    ),
    child: 
     
     
     
      Padding(padding: EdgeInsets.all(10),child:Text(employee.NameSurname,style: TextStyle(color:employee.isSelected ? Colors.white : Colors.black, ),) ,)
      ,
    )  
    

    
    
;
  }
}