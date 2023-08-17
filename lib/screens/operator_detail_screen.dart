import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:itm_cheffapp/models/LineMovement.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/line_provider.dart';
import 'package:itm_cheffapp/providers/linemovement_provider.dart';
import 'package:itm_cheffapp/providers/permission_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:remixicon/remixicon.dart';
import 'package:http/http.dart' as http;

class OperatorDetail extends ConsumerStatefulWidget {
  const OperatorDetail({super.key,required this.lineMovement,required this.losttime});
  final LineMovement lineMovement;
  final String losttime;
  

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
    selectedCondition = widget.losttime;
  });
final response = await http.get(Uri.parse('http://$server:$port/api/lines'));
final employeeLineResponse = await http.get(Uri.parse('http://$server:$port/api/LineMovement'));
final List employeeList=jsonDecode(employeeLineResponse.body);

var selectedItem = employeeList.firstWhere((e) => e['id'] == widget.lineMovement.id);
setState(() {
  endTime = selectedItem['employeeEndTime'].toString().substring(0,5);
    startTime = selectedItem['employeeStartTime'].toString().substring(0,5);
constantStartTime = selectedItem['employeeStartTime'].toString().substring(0,5);
constantEndTime = selectedItem['employeeEndTime'].toString().substring(0,5);
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
  if((startTime == constantStartTime && selectedCondition != conditions[Condition.active]) ){
 showDialog(context: context, builder:(context) =>  AlertDialog(
  title: Text('Hata'),
  content: Text('Lütfen saati değiştiriniz'),
actions: [
        TextButton(onPressed: (){
                Navigator.of(context).pop();
        }, child: Text('Ok'))
],
),);
    return;

  }
  setState(() {
    loading = true;
  });
  final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/lostTime'));
  final List lostTimeList = jsonDecode(lostTimeResponse.body);


var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == selectedCondition);

 final response = await http.put(Uri.parse('http://$server:$port/api/LineMovement')
 ,body:jsonEncode({
  'id':widget.lineMovement.id,
   'lineId':widget.lineMovement.lineId,
   'employeeId':widget.lineMovement.employeeId,
   'startTime':selectedCondition != conditions[Condition.active] ? startTime : constantStartTime,
   'endTime':endTime,
   'lostTimeId':selectedLostTime['id']
 }),headers: {
  'Content-Type':'application/json'
 } )  ;
 setState(() {
   loading = false;
 });
if(response.statusCode <= 200 && response.statusCode < 400){

ref.read(lineMovementProvider.notifier).updateLineMovement(widget.lineMovement.id, startTime, selectedLostTime['name']);
if(selectedCondition == "izinli" && widget.losttime != "izinli" ){
ref.read(permissionProvider.notifier).increasePermissionQty(widget.lineMovement.lineId);
}
if(selectedCondition != "izinli" && widget.losttime == "izinli" ){
ref.read(permissionProvider.notifier).decreasePermissionQty(widget.lineMovement.lineId);
}
 showDialog(context: context, builder:(context) =>  AlertDialog(
  title: Text('İşlem Başarılı'),
  content: Text('Saat başarıyla değişitirildi.'),
actions: [
        TextButton(onPressed: (){
                Navigator.of(context).pop();
        }, child: Text('Ok'))
],
),);
}
else {
 showDialog(context: context, builder:(context) =>  AlertDialog(
  title: Text('Hata'),
  content: Text('işlem yapılırken hata meydana geldi.'),
  actions: [
    TextButton(onPressed: (){
      Navigator.of(context).pop();
    }, child: Text('Tamam'))
  ],
),);
}







}


void deleteLineMovement(String server,String port) async{
  setState(() {
    loading = true;
  });
final response =  await http.delete(Uri.parse("http://$server:$port/api/LineMovement/${widget.lineMovement.id}"));
if(response.statusCode >= 200 && response.statusCode < 400){
   ref.read(lineMovementProvider.notifier).deleteEmployee(widget.lineMovement.id);
   ref.read(lineProvider.notifier).decreaseEmployeeQty(widget.lineMovement.lineId);
  if(widget.losttime == 'izinli'){
        ref.read(permissionProvider.notifier).decreasePermissionQty(widget.lineMovement.lineId);
  }
}
setState(() {
loading =   true;
});
 
   
   Navigator.of(context).pop();
                  Navigator.of(context).pop();
}

  
  void popUsingContext() {

  Navigator.of(context,rootNavigator: true).pop();
    
  
  }
void updateLine(String server,String port) async{
if(lineChange){
setState(() {
  loading = true;
});
bool checkSameLine = widget.lineMovement.lineName == lineName;

if(checkSameLine){
 showDialog(context: context, builder: (ctx)=>   
  AlertDialog(
    title: const Text('Hata'),
    content:const Text('Aynı bantı seçerek değişiklik yapamazsınız. Lütfen farklı bir bant seçin.',
    style: TextStyle(fontSize: 13,height: 1.5),),
            actions: [
          TextButton(onPressed: (){

                Navigator.of(context).pop();
              
              
              }, child: Text('tamam'.toUpperCase()))
            ],));
            setState(() {
              loading = false;
            });
            return;
}

final lineResponse = await http.get(Uri.parse('http://$server:$port/api/lines'));

List lineList = jsonDecode(lineResponse.body);
var selectedLine = lineList.firstWhere((element) => element['name'] == lineName );

final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/LostTime'));
final List lostTimeList = jsonDecode(lostTimeResponse.body);
var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == 'Aktif'); 
print(widget.lineMovement.id);
final response = await http.put(Uri.parse('http://$server:$port/api/LineMovement')

 ,body:jsonEncode({
  'id':widget.lineMovement.id,
   'lineId':selectedLine['id'],
   'employeeId':widget.lineMovement.employeeId,
   'startTime': endTime,
   'endTime':constantEndTime,
   'lostTimeId':selectedLostTime['id']
 }),headers: {
  'Content-Type':'application/json'
 } )  ;
if(response.statusCode >= 200 && response.statusCode < 400){
ref.read(lineProvider.notifier).increaseEmployeeQty(selectedLine['id']);
ref.read(lineProvider.notifier).decreaseEmployeeQty(widget.lineMovement.lineId);
ref.read(lineMovementProvider.notifier).deleteEmployee(widget.lineMovement.id);
}

setState(() {
  loading = false;
});

 showDialog(useRootNavigator: true,context: context, builder: (ctx)=>    AlertDialog(title: Text('Bant Değişitirildi'),content: Text("Operatörün yeni atandığı bant : $lineName",style: TextStyle(fontSize: 13,height: 1.5),),
            actions: [
       
              TextButton(onPressed: (){

           popUsingContext();
           Navigator.of(context).pop();
              
              
              }, child: Text('tamam'.toUpperCase()))
            ],));
}

else {
  setState(() {
    loading = false;
  });
  showDialog(useRootNavigator: false,context: context, builder: (ctx)=>    AlertDialog(title: const Text('Hata'),content:const Text('Bant değişikliğini onaylamadınız. Lütfen bant değişikliğini onaylayın.',style: TextStyle(fontSize: 13,height: 1.5),),
            actions: [
       
              TextButton(onPressed: (){

                Navigator.of(context).pop();
              
              
              }, child: Text('tamam'.toUpperCase()))
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
            Expanded(child:          DropdownButtonFormField<String>(value:widget.losttime,items: conditions.entries.map((e) =>
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
        borderRadius:const BorderRadius.all(Radius.circular(5)),
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
                     DropdownButtonFormField<String>(value:widget.lineMovement.lineName,items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: null
        
       
 
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
            showDialog(context: context, builder :(c)=>AlertDialog(
              title:const Text('Silme işlemi'),
              content:const Text("Operatörü silerseniz operatör herhangi bir banta sahip olmayacaktır. Operatörü silmek istediğinizden emin misiniz ?"),
              actions: [
                      TextButton(onPressed: (){
                  Navigator.of(context).pop();
                }, child:const Text('Hayır')),
                TextButton(onPressed:(){
                  deleteLineMovement(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
                }, child:const Text('Evet')),
            
              ],
            ));
        
            
          }, 
          child:const  Text('Sil')),
        
          const SizedBox(width: 5,),
         ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green
          ),
          onPressed: (){
            updateLine(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
        
            
          }, 
          child:const  Text('Onayla'))],
      ),

    
    ]
    ),
    )  ,
  ) 
  
     ;
  }
}


