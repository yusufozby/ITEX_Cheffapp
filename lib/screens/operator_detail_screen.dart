import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:itm_cheffapp/models/LineMovement.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;

class OperatorDetail extends ConsumerStatefulWidget {
  const OperatorDetail({super.key,required this.lineMovement});
  final LineMovement lineMovement;
  

  @override 
  ConsumerState<OperatorDetail> createState() => _OperatorDetailState();
}

class _OperatorDetailState extends ConsumerState<OperatorDetail> {

bool loading=false;
 final List<String> items = [];
 List<dynamic> lineEmployees=[];
int? selectedLineId;
String startTime="";
String? selectedCondition;
String endTime = "";
String lineName="";
String constantStartTime = "";
String constantEndTime = "";

void fetchLinesAndLostTimes(String server,String port) async{
  setState(() {
    loading = true;
    selectedCondition = conditions[widget.lineMovement.condition];
  });
final response = await http.get(Uri.parse('http://$server:$port/api/lines'));
final employeeLineResponse = await http.get(Uri.parse('http://$server:$port/api/LineMovement'));
final List employeeList=jsonDecode(employeeLineResponse.body);

var selectedItem = employeeList.firstWhere((e) => e['employeeId'] == widget.lineMovement.employeeId);
setState(() {
  endTime = selectedItem['employeeEndTime'].toString().substring(0,5);
    startTime = selectedItem['employeeStartTime'].toString().substring(0,5);
constantStartTime = selectedItem['employeeStartTime'].toString().substring(0,5);
constantStartTime = selectedItem['employeeEndTime'].toString().substring(0,5);
});

final List<dynamic> responseList = jsonDecode(response.body);

setState(() {
  for(int i = 0; i <responseList.length ;i++){
    items.add(responseList[i]['name']);
  }
  lineEmployees = jsonDecode(employeeLineResponse.body);
var selectedLine = responseList.firstWhere((element) => element['id'] == widget.lineMovement.lineId);
lineName = selectedLine['name'];
loading = false;
});




}
void updateTime(String server,String port) async{
  final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/lostTime'));
  final List lostTimeList = jsonDecode(lostTimeResponse.body);
print(lostTimeList);  
print(selectedCondition);
var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == selectedCondition);

 final response = await http.put(Uri.parse('http://$server:$port/api/LineMovement')
 ,body:jsonEncode({
   'lineId':widget.lineMovement.lineId,
   'employeeId':widget.lineMovement.employeeId,
   'startTime':selectedCondition != conditions[Condition.active] ? startTime : constantStartTime,
   'endTime':endTime,
   'lostTimeId':selectedLostTime['id']
 }),headers: {
  'Content-Type':'application/json'
 } )  ;


}
void updateLine(String server,String port) async{
if(lineChange){


final lineResponse = await http.get(Uri.parse('http://$server:$port/api/lines'));
List lineList = jsonDecode(lineResponse.body);
var selectedLine = lineList.firstWhere((element) => element['name'] == lineName );

final response = await http.put(Uri.parse('http://$server:$port/api/LineMovement')

 ,body:jsonEncode({
   'lineId':selectedLine['id'],
   'employeeId':widget.lineMovement.employeeId,
   'startTime': endTime,
   'endTime':constantEndTime,
   'lostTimeId':2
 }),headers: {
  'Content-Type':'application/json'
 } )  ;
}
else {
  showDialog(useRootNavigator: false,context: context, builder: (ctx)=>    AlertDialog(content:const Text('Bant değişikliğini onaylamadınız. İşleme devam etmek istediğinizden emin misiniz ?',style: TextStyle(fontSize: 13,height: 1.5),),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Hayır'.toUpperCase())),
              TextButton(onPressed: (){

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              
              }, child: Text('Evet'.toUpperCase()))
            ],));
}
}



@override



void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) { 
   fetchLinesAndLostTimes(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
     });
 
    super.initState();
  }

 bool lineChange= false;
 late final operatorController = TextEditingController(text: widget.lineMovement.nameSurname);
  @override
  Widget build(BuildContext context) {
    
 


      
      final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return loading ? const LoadingSpin() :
  SingleChildScrollView(
    child:Padding(padding: EdgeInsets.fromLTRB(16,48,16,keyboardSpace+50),child: 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
      TextField(
        enabled: false,
controller: operatorController,
        decoration:const InputDecoration(label: Text('Operatör Adı')),
       
        
      ),
 
          Row(children: <Widget>[
            Expanded(child:          DropdownButtonFormField<String>(value: conditions[widget.lineMovement.condition],items: conditions.entries.map((e) =>
             DropdownMenuItem<String>(
             value: e.value,
             child: Text(e.value))).toList(), 
             onChanged: (v){
setState(() {
  selectedCondition = v;
});
 }
        
       
 
 ),),

 
  
 
     
    
           
    
      ],
      ),
      const SizedBox(height: 10,),
     
   const    Text('Çalışma',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
            Row(
        children: [
                    Visibility(visible: selectedCondition != conditions[Condition.active],child:          Expanded(child: 
          Column(
            children: [
             const Text('Başlangıç Saati'),
              const SizedBox(height: 10,),
    Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.background,
        borderRadius:const BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]!)
        

      ),
      padding:const EdgeInsets.all(5),
      
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(startTime,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                GestureDetector(
                  onTap: () async {
                TimeOfDay? newTime =  await  showTimePicker(context: context, initialTime: TimeOfDay.now());
if(newTime == null){
return;
}
final hour = newTime.hour.toString().padLeft(2,'0');
final minute = newTime.minute.toString().padLeft(2,'0');
setState(() {
  startTime =  '$hour:$minute';
});
                  },
                  child:const Icon(Remix.time_fill,size: 40,),
                )
              ],
            ),
          )
            ],
          ))),
    Visibility(child: SizedBox(width: 15,),visible: selectedCondition != conditions[Condition.active]) ,
          Expanded(child: 
          Column(
            children: [
             const Text('Bitiş Saati'),
              const SizedBox(height: 10,),
    Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]!)
        

      ),
      padding:const EdgeInsets.all(5),
      
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(endTime,style:const TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                       GestureDetector(
                  onTap: () async {
                                    TimeOfDay? newTime =  await  showTimePicker(context: context, initialTime: TimeOfDay.now());
if(newTime == null){
return;
}
final hour = newTime.hour.toString().padLeft(2,'0');
final minute = newTime.minute.toString().padLeft(2,'0');
setState(() {
 endTime =  '$hour:$minute';
});
                  
                  },
                  child:const Icon(Remix.time_fill,size: 40,),
                )
              ],
            ),
          )
            ],
          )),
         
  
      
        ],
      ),
      const SizedBox(height: 15,),
  Row(
        children: [
          const Spacer(),
          ElevatedButton(onPressed: (){
            updateTime(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
          }, child:const Text('Saati Değiştir'))
        ],
      ),
    const  Text('Bant Değişikliği',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
    
            Row(
        children: [
          Expanded(child: 
          Column(
            children: [
            const  Text('Aktif Bant'),
              const SizedBox(height: 10,),
                     DropdownButtonFormField<String>(value:lineName,items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: null
        
       
 
 )
   
            ],
          )),
          const SizedBox(width: 15,),
             Expanded(child: 
          Column(
            children: [
             const Text('Gideceği Bant'),
              const SizedBox(height: 10,),
             
       DropdownButtonFormField<String>(value: lineName,items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: (v){
if(v == lineName){
return;
}

setState(() {
  lineChange = true;
   lineName = v!;

 
});
 }
        
       
 
 )
            ],
          )),
      
        ],
      ),

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
  const  Text('Bant Değişikliğini Onayla',style: TextStyle(fontSize: 12),),
    Checkbox(value: lineChange, onChanged: (value){
      setState(() {
        lineChange = value!;
      });
    },)
  ],
),


 const SizedBox(height: 10,),
      Row(
        children: [
       
  
    const Spacer(),


          TextButton(
          onPressed: (){Navigator.pop(context);}, 
        child:const Text('İptal'))
        ,
        
        
        
         ElevatedButton(
          onPressed: (){
            updateLine(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
        
            
          }, 
          child:const  Text('Tamam'))],
      ),

    
    ]
    ),
    )  ,
  ) 
  
     ;
  }
}


