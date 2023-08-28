import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:itm_cheffapp/models/Employee.dart';
import 'package:itm_cheffapp/models/LineMovement.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/linemovement_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:itm_cheffapp/screens/operator_detail_screen.dart';
import 'package:http/http.dart' as http;


class WorkTimeScreen extends ConsumerStatefulWidget {
  const WorkTimeScreen({super.key,required this.lineId,required this.lineName});
  final String lineName;
  final int lineId;

  @override
  ConsumerState<WorkTimeScreen> createState() => _WorkTimeScreenState();
}

class _WorkTimeScreenState extends ConsumerState<WorkTimeScreen> {
List<Employee> employees = [];
bool loading = false;

Condition selectedCondition = Condition.active;
int checkOperator=0;
void fetchLineOperators(String server,String port) async{
setState(() {
  loading = true;
});
final lineMovementResponse = await http.get(Uri.parse('http://$server:$port/api/daily_LineMovements'));

final EmployeeListResponse = await http.get(Uri.parse('http://$server:$port/api/Employees'));





// final DailyListResponse = await http.get(Uri.parse('http://$server:$port/api/DailyProductionPlans'));

final lostTimeResponse = await http.get(Uri.parse('http://$server:$port/api/LostTimes'));
setState(() {
  loading = false;
});

// final List DailyPlanProductionList = jsonDecode(DailyListResponse.body);

final List employeeList =  jsonDecode(EmployeeListResponse.body);
for(int i = 0; i < employeeList.length;i++){
 setState(() {
   employees.add(Employee(jobId: employeeList[i]['jobId'],NameSurname: employeeList[i]['fullName'], id: employeeList[i]['id']));
  
 });
}
setState(() {
  employees = employees.where((element) => element.jobId == 1).toList();
});


List lineMovementList = jsonDecode(lineMovementResponse.body);
if(lineMovementList.isNotEmpty){
final List lostTimeList = jsonDecode(lostTimeResponse.body);



 

lineMovementList = lineMovementList.map((item) {
 
 Map<String,dynamic> selectedEmployee = employeeList.firstWhere((e) => item['employeeId'] == e['id']);

   Map<String,dynamic> selectedLostTime= lostTimeList.firstWhere((e) => item['lostTimeId'] == e['id']);
 
  
item = {...item,'namesurname':selectedEmployee['fullName'],'employeeId':selectedEmployee['id'],'losttime':selectedLostTime['name']};
return item;
}).toList();





for(int i = 0; i <lineMovementList.length;i++){

  

 

lineMovementList = lineMovementList.where((element) => element['lineId'] ==widget.lineId).toList();
  setState(() {
    checkOperator = lineMovementList.length;
  });

ref.read(lineMovementProvider.notifier).addElementProviderList(lineMovementList);

 
}
}


}
  void initState() {
     WidgetsBinding.instance.addPostFrameCallback((_) { 
fetchLineOperators(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
     });
    super.initState();
  }
@override




  Widget build(BuildContext context) {
 bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom !=0 ;
    return loading ? const LoadingSpin()  : Scaffold(
      
 
      body:SafeArea(child: 
      Padding(
        padding:const EdgeInsets.only(top: 20,right: 10,left: 10),
        child: Column(
        children: [
            Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ Container(
                  padding:const EdgeInsets.symmetric(vertical: 10),
              

                
             
                child:    Text('${widget.lineName} ${AppLocalizations.of(context)!.operatorList}',style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center) ,
                
               
                  
           
              ),
       
            Container(
                     padding:const EdgeInsets.symmetric(vertical: 10),
                
                
                child: 
              Column(
                children: [
                  Text(AppLocalizations.of(context)!.date),
 Text(DateTime.now().toString().substring(0,10).replaceAll("-", "."),textAlign: TextAlign.center,style: TextStyle(fontSize: 20,fontWeight: FontWeight.bold),),
                ],
              )
               
              )],
            ),
            const SizedBox(height: 20,),
        
            Row(
              children: [
                Expanded(child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding:const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border:const Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text('Featured',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),),
                )),
          
                 Expanded(child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding:const EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border:const Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text(AppLocalizations.of(context)!.startTime,style: TextStyle(fontSize: 11,color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                )),
        
                  Expanded(child: Container(
                    height: 50,
                  alignment: Alignment.center,
                  padding:const EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border.all(color: Colors.grey,width: 1)
                  ),
             
                  child: Text(AppLocalizations.of(context)!.situation,style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),),
                )),
              ],
            ),
            Expanded(child:  SingleChildScrollView(
              
              child: 
 
           
             
              ListView.builder(physics:const NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: ref.watch(lineMovementProvider).length,itemBuilder: (context, index) =>
               InkWell(
                 onTap: () {
                   showModalBottomSheet(enableDrag: false,isDismissible: false,context: context,isScrollControlled: true, builder: (ctx)
                   {
 return  FractionallySizedBox(
   heightFactor: 1,
   child:  OperatorDetail(losttime: ref.watch(lineMovementProvider)[index]['losttime'],lineMovement: LineMovement(lineName: widget.lineName,id: ref.watch(lineMovementProvider)[index]['id'], condition: selectedCondition!, nameSurname: ref.watch(lineMovementProvider)[index]['namesurname'], dateTime: ref.watch(lineMovementProvider)[index]['employeeStartTime'], 
   lineId: widget.lineId, employeeId:ref.watch(lineMovementProvider)[index]['employeeId'])),
 );
                   }
                  );
                 },
                 child:    Row(
               children: [
                Expanded(child:
                Container(
             height: 40,
                 alignment: Alignment.center,
                 decoration:const BoxDecoration(
                   border: Border(left: BorderSide(color: Colors.grey)
                   ,bottom: BorderSide(color: Colors.grey) )
                 ),
                 child:  Text(ref.watch(lineMovementProvider)[index]['namesurname'],overflow: TextOverflow.ellipsis,maxLines: 2,style:const TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
                ),
               
                    Expanded(child:
                Container(
               height: 40,
                 alignment: Alignment.center,
                 decoration:const BoxDecoration(
                   border: Border(left: BorderSide(color: Colors.grey)
                   ,bottom: BorderSide(color: Colors.grey) )
                 ),
                 child:  Text(ref.watch(lineMovementProvider)[index]['employeeStartTime'].toString().substring(0,5),overflow: TextOverflow.ellipsis,maxLines: 2,style:const TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
                ),
                                 
                                       Expanded(child:
                Container(
          height: 40,
                 alignment: Alignment.center,
                 decoration:const BoxDecoration(
                   border: Border(
                   left: BorderSide(color: Colors.grey)
                   ,bottom: BorderSide(color: Colors.grey)  ,
                   right:        BorderSide(color: Colors.grey)   
                    )
                 ),
                 child:  Text(ref.watch(lineMovementProvider)[index]['losttime'],overflow: TextOverflow.ellipsis,maxLines: 2,style: const TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
                ),
               ],
             ),
               )
              
              ,) 
                

                
              
                
              

              
        

            )
            
            ),
            Padding(padding: EdgeInsets.only(top:65),child: 
              
               
               Center(child:   Visibility(child: Image(image: AssetImage('assets/itmbottom-logo.png')),visible: !keyboardIsOpen,),) 
              
             ,),
      
        ],
      )
      ),
    )
    );
  }
}