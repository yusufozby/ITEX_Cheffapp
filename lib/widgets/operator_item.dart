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
      bottom:const BorderSide(color: Colors.grey),
      left:const BorderSide(color: Colors.grey),
      right:const BorderSide(color: Colors.grey),
      top: index == 0 ?const BorderSide(color: Colors.grey) :const BorderSide(width: 0,color: Colors.grey)
      )
    ),
    child: 
     
     
     
      Padding(padding:const EdgeInsets.all(10),child:Text(employee.NameSurname,style: TextStyle(color:employee.isSelected ? Colors.white : Colors.black, ),) ,)
      ,
    )  
    

    
    
;
  }
}