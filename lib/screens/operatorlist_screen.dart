import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';

import 'package:itm_cheffapp/widgets/all_operators.dart';
import 'package:itm_cheffapp/widgets/operator_item.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;
class OperatorListScreen extends ConsumerStatefulWidget {
  const OperatorListScreen({super.key,required this.lineId,required this.lineName,required this.userId});
  final int lineId;
  final String lineName;
  final int userId;



  @override
  ConsumerState<OperatorListScreen> createState() => _OperatorListScreenState();
}




class _OperatorListScreenState extends ConsumerState<OperatorListScreen> {
  bool isTimeSelected = false;
  List lineEmployees=[];
   List<Employee> posts=[];
   List<Employee> constantList = [];
   List<Employee> extractByEmployee=[];
   bool addOperatorLoading = false;
  
   bool isLoading = false;
   void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { 
fetchOperators(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
     });
  
    super.initState();
  }
void fetchOperators(String server,String port) async{
setState(() {
  isLoading = true;
});
final response = await http.get(Uri.parse('http://$server:$port/api/Auth'));
 List temp = jsonDecode(response.body);
final lineEmployeeResponse = await http.get(Uri.parse('http://$server:$port/api/lineEmployee'));
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



 
void deleteOperators(String server,String port) async{
 print(posts);
 setState(() {
   addOperatorLoading = true;
 });
 final selectedEmployees = posts.where((element) => element.isSelected).toList();
 final List<int> employeeIdList = [];
for(int i = 0; i  < selectedEmployees.length;i++){
employeeIdList.add(selectedEmployees[i].id);
}

final List extractedlineEmployees = lineEmployees.where((element) => employeeIdList.contains(element['employeeId'])).toList();

final List<int> selectedEmployeeIdList = [];
;
for(int i= 0; i < extractedlineEmployees.length;i++){
    
   final response = await http.delete(Uri.parse('http://$server:$port/api/LineEmployee/'+extractedlineEmployees[i]['id'].toString()),headers: {
    'Content-Type':'application/json'
   });
   selectedEmployeeIdList.add(selectedEmployees[i].id);
}

setState(() {
  posts = posts.where((element) => !selectedEmployeeIdList.contains(element.id)).toList();
  posts = posts.where((element) => !element.isSelected).toList();

});


setState(() {
  addOperatorLoading = false;
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
   var checkSingleEmployee = posts.every((element) => element.id != employees[i].id);
   if(checkSingleEmployee){
posts.add(employees[i]);
   }
        
    

    }
    posts =posts.map((e){
e.isSelected = false;

return e;
    }).toList();
  });

}

void startWorkTime(String server,String port) async{
  if(posts.isNotEmpty){

  
var statusCode;

setState(() {
  addOperatorLoading = true;
});
 
if(!isTimeSelected){
  showDialog(context: context,useRootNavigator: false,builder: (context) =>AlertDialog(
    title:const Text('Hata'),content:const Text('Lütfen çalışma zamanın seçiniz.'),actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child:const Text('Ok'))
    ],
  ));
  setState(() {
    addOperatorLoading = false;
  });
return;
}




 for(int i = 0; i < posts.length;i++){

 
final url = 'http://$server:$port/api/LineMovement';
var response =await http.post(Uri.parse(url)
  ,body: jsonEncode({
  
     'lineId':widget.lineId,
     
     'startTime':(time.hour.toString().padLeft(2,'0')+":"+time.minute.toString().padLeft(2,'0')).toString(),

      'EmployeeId':posts[i].id

   
  }),headers: {
    'Content-Type':'application/json'
  });
statusCode = response.statusCode;
 } 
 if(statusCode >= 400){
  // ignore: use_build_context_synchronously
  showDialog(context: context, builder:(ctx)=>
  AlertDialog(
    content: const Text('Günlük plan üretimi oluşturulmamış. Lütfen Çalışma vaktini başlatmadan önce Günlük plan üretimini oluşturun.',)
    ,title:const Text('Hata'),
    actions: [TextButton(onPressed: (){
   
      
           setState(() {
             addOperatorLoading = false;
           });

           Navigator.of(context).pop();
         

    }, child:const Text('Ok'))],
  
  ));
 }
 else {
  setState(() {
    posts = posts.map((item) {
  item.isSelected = false;

return item;
    }  ).toList();
    addOperatorLoading = false;
  });


       showDialog(useRootNavigator: false,context: context, builder:(ctx) =>AlertDialog(
            title: Text('İşlem Başarılı'),
            content: Text('Çalışma zamanı başarıyla oluşturuldu'),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Ok'))
            ],
            
           ) );
 }

 }
 else {
   showDialog(context: context,useRootNavigator: false,builder: (context) =>AlertDialog(
    title:const Text('Hata'),content:const Text('Operatör listesi boş.'),actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child:const Text('Ok'))
    ],
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
   } ).toList();



    }); 

}



@override


 TimeOfDay time = TimeOfDay.now();
 

  Widget build(BuildContext context) {


     final   hours = time.hour.toString().padLeft(2,'0');
final   minute = time.minute.toString().padLeft(2,'0');
bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;

    return isLoading  ? const LoadingSpin():  Scaffold(
      floatingActionButtonLocation:FloatingActionButtonLocation.startFloat,
      floatingActionButton:Visibility(visible: !keyboardIsOpen  && !addOperatorLoading,child:   FloatingActionButton(backgroundColor: Colors.green,onPressed: (){
                            
                              Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => AllOperators(lineName: widget.lineName,showNewList: showNewList,
                                
                                          
                                         employees: constantList,
                                           lineId: widget.lineId)));
                                   }, child:const Icon(Icons.add,size: 40,) )) 
    ,
      body: SafeArea(child: 
!addOperatorLoading ? 


      Padding(padding:const EdgeInsets.all( 10),child:      Column(
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
                                onTap: (){
                                  deleteOperators(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
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
          child: ElevatedButton(onPressed: (){
            startWorkTime(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
          },style: ElevatedButton.styleFrom(
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
) :const LoadingSpin()
    ) ) ;
  }
}