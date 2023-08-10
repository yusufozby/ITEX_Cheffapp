import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/models/LineEmployee.dart';
import 'package:itm_cheffapp/widgets/operator_item.dart';
import 'package:http/http.dart' as http;
class AllOperators extends StatefulWidget {
   AllOperators({super.key,required this.employees,this.employeesByLine,required this.lineId,required this.lineEmployees,required this.showNewList});
  final List<Employee> employees;
   List<Employee>? employeesByLine;
  final List lineEmployees;
  final int lineId;
  final void Function(List<Employee> emploees) showNewList;

  @override
  State<AllOperators> createState() => _AllOperatorsState();
}

class _AllOperatorsState extends State<AllOperators> {
 List<Employee> allEmployees = [];
void selectOperator(Employee employee){
 setState(() {
   allEmployees = allEmployees.map((item)  
   {
   if(item.id == employee.id){
    item.isSelected = !item.isSelected;

   }
   return item;
   }
   
    ).toList();
    }); 

}
void addOperators() async{

List<int> lineEmployeesIdList=[];
for(int i = 0; i < widget.lineEmployees.length;i++){
   lineEmployeesIdList.add(widget.lineEmployees[i]['id']);
}

  var uri = 'http://192.168.1.7:5246/api/lineEmployee';
List<Employee> extractedEmployees = allEmployees.where((element) => element.isSelected).toList();

List<int> lineEmployeeIdList=[];
for(int i = 0; i <extractedEmployees.length;i++){
  lineEmployeeIdList.add(extractedEmployees[i].id);
}
List <LineEmployee> lineEmployeeList=[];
for(int i = 0; i < widget.lineEmployees.length;i++){
lineEmployeeList.add(LineEmployee(employeeId: widget.lineEmployees[i]['employeeId'], id: widget.lineEmployees[i]['id'], lineId: widget.lineEmployees[i]['lineId']));
}



print(lineEmployeeIdList);

for(int i = 0; i <lineEmployeeIdList.length;i++){

  

print(lineEmployeeList[i].lineId);
  try {
final response = await http.post(Uri.parse(uri),body: jsonEncode({

'lineId':widget.lineId,
'employeeId':lineEmployeeIdList[i],

}),headers: {
  'Content-Type':'application/json'
});
print(response.statusCode);
  }
  catch(e){
    print("object");
  } 


}



widget.showNewList(extractedEmployees);

Navigator.of(context).pop();
}



@override
  void initState() {
    // TODO: implement initState
    super.initState();
    setState(() {
      allEmployees = widget.employees;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 

      SafeArea(
        child: Padding(
          padding: EdgeInsets.only(
            top: MediaQuery.of(context).padding.top,
            bottom: MediaQuery.of(context).viewInsets.bottom
          ),
          child: Column(
            
            children: [
         
              Expanded(child: ListView.builder(itemBuilder: (ctx,i)=>
              GestureDetector(
                onTap: () {
                  selectOperator(allEmployees[i]);
                },
                child:  OperatorItem(index: i, employee: allEmployees[i], ),
              )
             ,itemCount: allEmployees.length,)),
             const SizedBox(height: 20,),
             Padding(padding: EdgeInsets.symmetric(horizontal: 10),
             child:        Row(
              children: [
                Expanded(child: ElevatedButton(onPressed:addOperators, child:Text('Ekle'),style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ),),  ),
                const SizedBox(width: 10,),
        Expanded(child: ElevatedButton(onPressed: (){}, child:Text('İptal'))  ),  
              ],
            )
             ,)
     
            ],
          ),
        ),
      )
    );
  }
}