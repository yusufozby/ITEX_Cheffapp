import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/models/LineEmployee.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/line_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';

import 'package:itm_cheffapp/screens/work_time_screen.dart';
import 'package:itm_cheffapp/widgets/operator_item.dart';
import 'package:http/http.dart' as http;
class AllOperators extends ConsumerStatefulWidget {
 const  AllOperators({super.key,required this.lineName,required this.employees,required this.lineId,required this.showNewList});
  
  final List<Employee> employees;
 final String lineName;

 
  final int lineId;
  final void Function(List<Employee> emploees) showNewList;

  @override
  ConsumerState<AllOperators> createState() => _AllOperatorsState();
}

class _AllOperatorsState extends ConsumerState<AllOperators> {
  bool loading = false;
  final TimeOfDay time = TimeOfDay.now(); 
  
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
void addOperators(String server,String port) async{
setState(() {
  loading = true;
});
List<Employee> extractedEmployees = allEmployees.where((element) => element.isSelected).toList();
if(extractedEmployees.isEmpty){
  setState(() {
    loading = false;
  });

// ignore: use_build_context_synchronously
showDialog(context: context, builder: (ctx)=>  AlertDialog(
title:const Text('Hata'),
content:const Text('Herhangi bir operatör seçmediniz.'),
  actions: [
    TextButton(onPressed: (){
      Navigator.of(context).pop();
    }, child:const Text('Ok'))
  ],
));
return;

}
  var uri = 'http://$server:$port/api/lineEmployee';
    var uri2 = 'http://$server:$port/api/LineMovement';
  final lineEmployeeResponse = await http.get(Uri.parse(uri));
    final lineMovementResponse = await http.get(Uri.parse(uri2));
  final List lineEmployees = jsonDecode(lineEmployeeResponse.body); 




List<int> lineEmployeeIdList=[];
for(int i = 0; i <extractedEmployees.length;i++){
  lineEmployeeIdList.add(extractedEmployees[i].id);
}
List <LineEmployee> lineEmployeeList=[];
for(int i = 0; i < lineEmployees.length;i++){
lineEmployeeList.add(LineEmployee(employeeId: lineEmployees[i]['employeeId'], id: lineEmployees[i]['id'], lineId: lineEmployees[i]['lineId']));
}


for(int i = 0; i <lineEmployeeIdList.length;i++){


final response = await http.post(Uri.parse(uri2),body: jsonEncode({

  'lineId':widget.lineId,
  'employeeId':lineEmployeeIdList[i],
  'startTime':'${time.hour}:${time.minute}'

}),headers: {
  'Content-Type':'application/json'
});

if(response.statusCode < 400 && response.statusCode >= 200){
List t =jsonDecode(lineMovementResponse.body);





ref.read(lineProvider.notifier).increaseEmployeeQty(widget.lineId);
  



}




 



}

Navigator.of(context).pop();
Navigator.of(context).pop();


Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>WorkTimeScreen(lineId: widget.lineId, lineName: widget.lineName)));





}

void cancel(){
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
void filterAllOperators(String search){

  setState(() {
    allEmployees = widget.employees.where((element) =>element.NameSurname.toLowerCase().contains(search.toLowerCase()) ).toList();
  });

}


  @override
  Widget build(BuildContext context) {
   bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return loading ? const LoadingSpin() : Scaffold(
      body: 

      SafeArea(
        child: Padding(
          padding:const EdgeInsets.all(
           10
            
          ),
          child: Column(
            
            children: [
      Padding(padding:const EdgeInsets.symmetric(vertical:15,horizontal: 10),child: TextField(
        decoration:const InputDecoration(
          hintText: "Operatör Ara"
        ),
        onChanged: (value) {
          filterAllOperators(value);
        },
        
      )),


              Expanded(child: ListView.builder(itemBuilder: (ctx,i)=>
              GestureDetector(
                onTap: () {
                  selectOperator(allEmployees[i]);
                },
                child:  OperatorItem(index: i, employee: allEmployees[i], ),
              )
             ,itemCount: allEmployees.length,)),
             const SizedBox(height: 20,),
             Padding(padding:const EdgeInsets.symmetric(horizontal: 10),
             child:   Visibility(visible: !keyboardIsOpen,child:  Row(
              children: [
                Expanded(child: ElevatedButton(onPressed:(){
                  addOperators(ref.watch(connectionProvider)['server'],ref.watch(connectionProvider)['port']);
                   },style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue
                ), child:const Text('Ekle'),),  ),
                const SizedBox(width: 10,),
        Expanded(child: ElevatedButton(onPressed: cancel, child:const Text('İptal'))  ),  
              ],
            ), )   
             ,)
     
            ],
          ),
        ),
      )
    );
  }
}