import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:itm_cheffapp/screens/work_time_screen.dart';
import 'package:itm_cheffapp/widgets/operator_item.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;
class OperatorListScreen extends StatefulWidget {
  const OperatorListScreen({super.key,required this.lineId,required this.lineName});
  final int lineId;
  final String lineName;



  @override
  State<OperatorListScreen> createState() => _OperatorListScreenState();
}




class _OperatorListScreenState extends State<OperatorListScreen> {
  bool isTimeSelected = false;
   List<Employee> posts=[];
   List<Employee> constantList = [];
   bool addOperatorLoading = false;
  
   bool isLoading = false;
Future<void> fetchOperators() async{
setState(() {
  isLoading = true;
});
final response = await http.get(Uri.parse('http://192.168.1.48:5246/api/Auth'));
final List temp = jsonDecode(response.body);

setState(() {
  for(int i = 0; i < temp.length;i++){
    posts.add(Employee(NameSurname: temp[i]['fullName'], isSelected: false, id:temp[i]['id'] ));
    constantList.add(Employee(NameSurname: temp[i]['fullName'], isSelected: false, id:temp[i]['id'] ));
  }  

   isLoading = false;
});



}

void filterOperators(String search){
  setState(() {
    posts = constantList.where((element) => element.NameSurname.toLowerCase().contains(search.toLowerCase())).toList();
  });
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
void addOperators() async{
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
    title: Text('Hata'),content: Text('Herhangi bir operatör seçmediniz. Lütfen operatör seçin.'),actions: [
      TextButton(onPressed: (){
        Navigator.of(context).pop();
      }, child: Text('Ok'))
    ],
  ));
}
 setState(() {
    addOperatorLoading = true;
  });


 for(int i = 0; i < selectedPosts.length;i++){

 
const url = 'http://192.168.1.48:5246/api/LineMovement';
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
    addOperatorLoading = false;
  });
 }
 catch(e) {
  showDialog(context: context, builder:(ctx)=>
  AlertDialog(
    content: Text('Günlük plan üretimi oluşturulmamış. Lütfen Çalışma vaktini başlatmadan önce Günlük plan üretimini oluşturun.',)
    ,title: Text('Hata'),
    actions: [TextButton(onPressed: (){
      Navigator.of(context).pop();
           setState(() {
             addOperatorLoading = false;
           });

    }, child: Text('Ok'))],
  
  ));
 }
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
           ListView.builder(itemBuilder: (ctx,index) =>OperatorItem(selectOperator: selectOperator,index: index,employee: posts[index],),itemCount: posts.length,)
           
       //     ListView.builder(itemBuilder: (ctx,i) =>OperatorItem(index: i,),itemCount: 40,))
             )   ],
          )),
      Visibility(visible: !keyboardIsOpen,child:    Padding(padding:const EdgeInsets.symmetric(vertical:10),child:          Row(
            children: [
              Expanded(child:
              Row(
                children: [
                         
              
                               Expanded(child:
                               InkWell(
                                onTap: () {
                                  
                                },
                       
                                child:    
                                InkWell(
                                  onTap: addOperators,
                                  child:             Container(
                
     width: double.infinity, 
     alignment: Alignment.center,
     height: 80,
     decoration:const BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(5)),
      color: Colors.green
     ),     
child: Text('Ekle',style: TextStyle(fontSize: 16,letterSpacing: 0.2,color: Theme.of(context).colorScheme.onPrimary,fontWeight: FontWeight.bold)),            ) ,
                                )
                                
                       ,
                               )
       
              ),
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
          Text(!isTimeSelected ? 'Saat seç': '$hours:$minute'),
          InkWell(
            onTap: () async {
            
           TimeOfDay? newTime  = await   showTimePicker(context: context, initialTime: TimeOfDay.now())  ;
 
    setState(() {
       time = newTime!;
       isTimeSelected = true;
    });
            },
            child:const Icon(Remix.time_fill,size: 20),
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
            Navigator.push(context, MaterialPageRoute(builder: (ctx)=>const WorkTimeScreen()));
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
) : LoadingSpin(addLoadingOperator: true,)
    ) ) ;
  }
}