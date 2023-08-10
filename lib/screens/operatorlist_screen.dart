import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:itm_cheffapp/screens/work_time_screen.dart';
import 'package:itm_cheffapp/widgets/all_operators.dart';
import 'package:itm_cheffapp/widgets/operator_item.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;
class OperatorListScreen extends StatefulWidget {
  const OperatorListScreen({super.key,required this.lineId,required this.lineName,required this.userId});
  final int lineId;
  final String lineName;
  final int userId;



  @override
  State<OperatorListScreen> createState() => _OperatorListScreenState();
}




class _OperatorListScreenState extends State<OperatorListScreen> {
  bool isTimeSelected = false;
  List lineEmployees=[];
   List<Employee> posts=[];
   List<Employee> constantList = [];
   List<Employee> extractByEmployee=[];
   bool addOperatorLoading = false;
  
   bool isLoading = false;
Future<void> fetchOperators() async{
setState(() {
  isLoading = true;
});
final response = await http.get(Uri.parse('http://192.168.1.7:5246/api/Auth'));
 List temp = jsonDecode(response.body);
final lineEmployeeResponse = await http.get(Uri.parse('http://192.168.1.7:5246/api/lineEmployee'));
List temp2= jsonDecode(lineEmployeeResponse.body);

setState(() {
  lineEmployees = temp2;
});
List lineEmployeeIdList=[];
temp2 = temp2.where((element) => element['lineId'] == widget.lineId ).toList();
for(int i = 0; i< temp2.length;i++){
  lineEmployeeIdList.add(temp2[i]['employeeId']);
}





setState(() {
  for(int i = 0; i < temp.length;i++){
    posts.add(Employee(NameSurname: temp[i]['fullName'], id:temp[i]['id'] ));
    constantList.add(Employee(NameSurname: temp[i]['fullName'], id:temp[i]['id'] ));
    extractByEmployee.add(Employee(NameSurname: temp[i]['fullName'], id:temp[i]['id'] ));
  }  
   posts =posts.where((element) => lineEmployeeIdList.contains(element.id) && element.id != widget.userId ).toList();
   extractByEmployee =extractByEmployee.where((element) => lineEmployeeIdList.contains(element.id) && element.id != widget.userId ).toList();
   isLoading = false;
});



}



 


void filterOperators(String search){
  
  setState(() {
    posts = extractByEmployee.where((element) => element.NameSurname.toLowerCase().contains(search.toLowerCase())).toList();
  });
}

void showNewList(List<Employee> employees){
  setState(() {
    for(int i = 0; i < employees.length;i++){
      setState(() {
        posts.add(employees[i]);
      });

    }
    posts =posts.map((e){
e.isSelected = false;

return e;
    }).toList();
  });

}

void startWorkTime() async{
 try {

 
if(!isTimeSelected){
  showDialog(context: context,useRootNavigator: false,builder: (context) =>AlertDialog(
    title: Text('Hata'),content: Text('Lütfen çalışma zamanın seçiniz.'),actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: Text('Ok'))
    ],
  ));
return;
}

 final List<Employee> selectedPosts = posts.where((element) => element.isSelected).toList();
if(selectedPosts.isEmpty){
    showDialog(context: context,useRootNavigator: false,builder: (context) =>AlertDialog(
    title:const Text('Hata'),content:const Text('Herhangi bir operatör seçmediniz. Lütfen operatör seçin.'),actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child:const Text('Ok'))
    ],
  ));
}
 setState(() {
    addOperatorLoading = true;
  });


 for(int i = 0; i < selectedPosts.length;i++){

 
const url = 'http://192.168.1.7:5246/api/LineMovement';
  final response = await http.post(Uri.parse(url)
  ,body: jsonEncode({
  
     'lineId':widget.lineId,
     
     'startTime':(time.hour.toString().padLeft(2,'0')+":"+time.minute.toString().padLeft(2,'0')).toString(),

      'EmployeeId':selectedPosts[i].id

   
  }),headers: {
    'Content-Type':'application/json'
  });

 } 
  setState(() {
    posts = posts.map((item) {
  item.isSelected = false;

return item;
    }  ).toList();
    addOperatorLoading = false;
  });
 }
 catch(e) {
  showDialog(context: context, builder:(ctx)=>
  AlertDialog(
    content: const Text('Günlük plan üretimi oluşturulmamış. Lütfen Çalışma vaktini başlatmadan önce Günlük plan üretimini oluşturun.',)
    ,title:const Text('Hata'),
    actions: [TextButton(onPressed: (){
      Navigator.of(context).pop();
           setState(() {
             addOperatorLoading = false;
           });

    }, child: Text('Ok'))],
  
  ));
 }
}
void selectOperator(Employee employee){
 setState(() {
posts = posts.map((item)  
   {
   if(item.id == employee.id){
    item.isSelected = !item.isSelected;

   }
   return item;
   }
   
    ).toList();
    }); 

}




@override

void initState() {
   fetchOperators();
    super.initState();
  }
 TimeOfDay time = TimeOfDay.now();
 

  Widget build(BuildContext context) {
     final   hours = time.hour.toString().padLeft(2,'0');
final   minute = time.minute.toString().padLeft(2,'0');
bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return isLoading  ? const LoadingSpin(addLoadingOperator: false,):  Scaffold(
      floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
      floatingActionButton:Visibility(visible: !keyboardIsOpen  && !addOperatorLoading,child:   FloatingActionButton(child: Icon(Icons.add,size: 30,),backgroundColor: Colors.green,onPressed: (){
                              showModalBottomSheet(useSafeArea: true,backgroundColor: Colors.transparent,context: context,isScrollControlled: true, builder: (ctx) => 
                              AllOperators(
                                showNewList: showNewList,
                                lineEmployees: lineEmployees,
                                          employeesByLine: posts
                                         ,employees: constantList,
                                          lineId: widget.lineId,));
                                   } )) 
    ,
      body: SafeArea(child: 
!addOperatorLoading ? 


      Padding(padding:const EdgeInsets.all(10),child:      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
Text('${widget.lineName} OPERATÖR LİSTESİ',style:const TextStyle(fontWeight: FontWeight.bold),),
          const SizedBox(height: 10,),
          TextField(
 
     onChanged: (value) {
       filterOperators(value);
     },
         decoration: const InputDecoration(
     
          
labelText: "Operatör Ara",
          border:UnderlineInputBorder(
            
            borderSide: BorderSide(
              color: Colors.black,
              width: 5
            ),
            
          ),
           ),
          ),
          const SizedBox(height: 20,),
       Container(
     
        alignment: Alignment.center,
        padding:const EdgeInsets.all(10),
    
        child:const Text('Operatör Listesi',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),),
       ),
           Expanded(child:
           ListView.builder(shrinkWrap: true,physics:const NeverScrollableScrollPhysics(),itemBuilder: (ctx,index) =>
           GestureDetector(
            onTap: () {
              selectOperator(posts[index]);
            },
            child: OperatorItem(index: index,employee: posts[index],),
           )
           ,itemCount: posts.length,)
           
       //     ListView.builder(itemBuilder: (ctx,i) =>OperatorItem(index: i,),itemCount: 40,))
             )   ],
          )),
      Visibility(visible: !keyboardIsOpen,child:    Padding(padding:const EdgeInsets.symmetric(vertical:10),child:          Row(
            children: [
              Expanded(child:
              Row(
                children: [
                         
              
//                              
              const SizedBox(width: 5,),
                        Expanded(child:
      InkWell(
                                onTap: () {
                                  
                                },
                                
                                child:       Container(
                
     width: double.infinity, 
     alignment: Alignment.center,
     height: 80,
     decoration: BoxDecoration(
      borderRadius:const BorderRadius.all(Radius.circular(5)),
      color: Theme.of(context).colorScheme.primary
     ),     
child: FittedBox(
child:  Text('Çıkar',style: TextStyle(fontSize: 16,letterSpacing: 0.2,color: Theme.of(context).colorScheme.onPrimary,fontWeight: FontWeight.bold)),
)
              ) ,
                               )
              ),
                ],
              )
  
              ),
         
              const SizedBox(width: 15,),
                       Expanded(child:
              SizedBox(
                width :double.infinity,
child: Column(
  children: [
   Container(
    padding:const EdgeInsets.symmetric(vertical:40,horizontal: 10),
    width: double.infinity,
    decoration: BoxDecoration(border: Border.all(color: Colors.grey),borderRadius:const BorderRadius.all(Radius.circular(5))),
    child:Container(
      padding:const EdgeInsets.all(5),
      color: Theme.of(context).colorScheme.background,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(!isTimeSelected ? 'Saat seç': '$hours:$minute',style:const TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
          InkWell(
            onTap: () async {
            
           TimeOfDay? newTime  = await   showTimePicker(context: context, initialTime: TimeOfDay.now())  ;
 
    setState(() {
       time = newTime!;
       isTimeSelected = true;
    });
            },
            child:const Icon(Remix.time_fill,size: 30),
          )
        //  showTimePicker(context: context, initialTime: TimeOfDay.now())  ;
       
        ],
      ),
    ),
  
   ),
        const SizedBox(height: 15,),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(onPressed: startWorkTime,style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 15),
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(20)),
              
            )
          ), child:const Text('Çalışma Zamanını Başlat'))  ,
          
        )
            
  ],
)
              )
              ),
            ],
          ) ,))
   

  
 ])
) : LoadingSpin(addLoadingOperator: true,)
    ) ) ;
  }
}