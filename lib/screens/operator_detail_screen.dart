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
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

bool isUndefined=false;
void fetchLinesAndLostTimes(String server,String port) async{
  setState(() {
    loading = true;
    selectedCondition = widget.losttime;
  });
final response = await http.get(Uri.parse('http://$server:$port/api/lines'));

final employeeLineResponse = await http.get(Uri.parse('http://$server:$port/api/Daily_LineMovements'));
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

  setState(() {
    loading = true;
  });
  final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/lostTimes'));
  final List lostTimeList = jsonDecode(lostTimeResponse.body);
print(lostTimeResponse.statusCode);

var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == selectedCondition);
  print(widget.lineMovement.id);
 final response = await http.put(Uri.parse('http://$server:$port/api/Daily_LineMovements/${widget.lineMovement.id}')
 ,body:jsonEncode({
  
   'LineId':widget.lineMovement.lineId,
   'EmployeeId':widget.lineMovement.employeeId,
   'EmployeeStartTime':selectedCondition == conditions[Condition.undefined] ? '00:00' : startTime,
   'EmployeeEndTime':selectedCondition == conditions[Condition.undefined] ? '00:00' : endTime,
   'LostTimeId':selectedLostTime['id']
 }),headers: {
  'Content-Type':'application/json'
 } )  ;
 setState(() {
   loading = false;
 });
if(response.statusCode <= 200 && response.statusCode < 400){

ref.read(lineMovementProvider.notifier).updateLineMovement(widget.lineMovement.id, selectedCondition == conditions[Condition.undefined] ? '00:00' : startTime, selectedLostTime['name']);
if(selectedCondition == "Tam Gün izinli" && widget.losttime != "Tam Gün izinli" ){
ref.read(permissionProvider.notifier).increasePermissionQty(widget.lineMovement.lineId);
}
if(selectedCondition != "Tam Gün izinli" && widget.losttime == "Tam Gün izinli" ){
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
print(response.statusCode);
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
  if(widget.losttime == 'Tam Gün izinli'){
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

final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/LostTimes'));
final List lostTimeList = jsonDecode(lostTimeResponse.body);
var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == 'Bant Değişikliği'); 




final response = await http.put(Uri.parse('http://$server:$port/api/Daily_LineMovements/${widget.lineMovement.id}')

 ,body:jsonEncode({

   'lineId':widget.lineMovement.lineId,
   'employeeId':widget.lineMovement.employeeId,
   'EmployeestartTime': constantStartTime,
   'EmployeeendTime':constantEndTime,
   'lostTimeId':selectedLostTime['id']
 }),headers: {
  'Content-Type':'application/json'
 } )  ;
if(response.statusCode >= 200 && response.statusCode < 400){
ref.read(lineProvider.notifier).increaseEmployeeQty(selectedLine['id']);

ref.read(lineMovementProvider.notifier).updateLineMovement(widget.lineMovement.id,startTime,selectedLostTime['name']);
}

final response2 = await http.post(Uri.parse('http://$server:$port/api/Daily_LineMovements'),body: jsonEncode({
  'lineId':selectedLine['id'],
  'employeeId':widget.lineMovement.employeeId,
  'startTime':endTime,
  'endTime':'18:30'
  
}),headers: {
  'Content-Type':'application/json'
});
print(response.statusCode);
print(response2.statusCode);



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
    bool lineChangeSelected = "Bant Değişikliği" == selectedCondition!;
 


      
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
        decoration: InputDecoration(label: Text(AppLocalizations.of(context)!.operatorName)),
       
        
      ),
 
          Row(children: <Widget>[
            Expanded(child:          DropdownButtonFormField<String>(value:widget.losttime,items: conditions.entries.map((e) =>
             DropdownMenuItem<String>(
             value: e.value,
             child: Text(e.value))).toList(), 
             onChanged: (v){
setState(() { 
  selectedCondition = v;

if(selectedCondition == conditions[Condition.undefined]){
  setState(() {
    isUndefined = true;
    startTime = "00:00";
    endTime = "00:00";
    
  });
return;
}
else {
setState(() {
  isUndefined = false;
});
 
}});
             
 }
  
       
 
 ),),

 
  
 
     
    
           
    
      ],
      ),
      const SizedBox(height: 10,),
     
  Text(AppLocalizations.of(context)!.work,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
            Row(
        children: [
                    Visibility(visible: selectedCondition != conditions[Condition.active],child:          Expanded(child: 
          Column(
            children: [
              Text(AppLocalizations.of(context)!.startingTime),
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
if(isUndefined){
setState(() {
  startTime = "00:00";
  
});


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
             Text(AppLocalizations.of(context)!.endingTime),
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

if(isUndefined){
setState(() {
  endTime = "00:00";
  return;
});}


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
          }, child:Text(AppLocalizations.of(context)!.updateTime))
        ],
      ),
     Text(AppLocalizations.of(context)!.updatingLine,style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
    
            Row(
        children: [
          Expanded(child: 
          Column(
            children: [
           Text(AppLocalizations.of(context)!.activeLine),
              const SizedBox(height: 10,),
                     DropdownButtonFormField<String>(value:widget.lineMovement.lineName,items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: null
        
       
 
 )
   
            ],
          )),
          const SizedBox(width: 15,),
             Expanded(child: 
          Column(
            children: [
              Text(AppLocalizations.of(context)!.sentLine),
              const SizedBox(height: 10,),
             
       DropdownButtonFormField<String>(value: lineName,items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: !lineChangeSelected  ? null : (v){
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
   Text(AppLocalizations.of(context)!.confirmUpdateLine,style: TextStyle(fontSize: 12),),
    Checkbox(activeColor: Theme.of(context).colorScheme.primary,value: lineChange, onChanged: (value){
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
        child:Text(AppLocalizations.of(context)!.cancel))
        ,
  

        
          const SizedBox(width: 5,),
         ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).colorScheme.primary
          ),
          onPressed: !lineChangeSelected ? null : (){
            updateLine(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
        
            
          }, 
          child:  Text(AppLocalizations.of(context)!.confirm))],
      ),

    
    ]
    ),
    )  ,
  ) 
  
     ;
  }
}


