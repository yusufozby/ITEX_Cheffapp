import 'dart:convert';


import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:http/http.dart' as http;
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/line_provider.dart';
import 'package:itm_cheffapp/providers/permission_provider.dart';
import 'package:itm_cheffapp/screens/loading_spin.dart';
import 'package:itm_cheffapp/widgets/line_item.dart';
class LineListScreen extends ConsumerStatefulWidget {
  const LineListScreen({super.key,required this.userId});
  final int userId;
 

  @override
  ConsumerState<LineListScreen> createState() => _LineListScreenState();
}

class _LineListScreenState extends ConsumerState<LineListScreen> {
    List lineList=[];
    
   bool loading = false;
  int lostTimeId=0;
  Map<dynamic,int> totalOffEmployees={};
void fetchLines(String server,String port) async{
  setState(() {
    loading = true;
  });
  Map<dynamic,int> totalLineEmployees={}; 
  List posts = [];

      // This is an open REST API endpoint for testing purposes
      final lineUrl = 'http://$server:$port/api/lines';
  
      
      final http.Response response = await http.get(Uri.parse(lineUrl));
      posts = json.decode(response.body);
for(int i = 0; i < posts.length;i++){
  final EfficientResponse = await http.get(Uri.parse("http://$server:$port/api/Daily_LineMovements/LineProductivity?lineId=${posts[i]['id']}"));
 String efficient ="" ;
 
if(jsonDecode(EfficientResponse.body).runtimeType == int){
   efficient = double.parse(jsonDecode(EfficientResponse.body).toString()).toString();
}
else {

   efficient = jsonDecode(EfficientResponse.body).toString();
}
   posts = posts.map((e) {
if(e['id'] == posts[i]['id']){

   posts[i]['efficient'] = efficient;
}


    return e;
   }).toList();

}
print(posts);


      final lineEmployeeUrl = 'http://$server:$port/api/line_Employees';
      final e = 'http://$server:$port/api/daily_lineMovements';
      final losttimeUrl = 'http://$server:$port/api/lostTimes';
      
      final lostTimeResponse = await http.get(Uri.parse(losttimeUrl));
      final List lostTimeList = jsonDecode(lostTimeResponse.body);
      

      final lineEmployeeResponse = await http.get(Uri.parse(lineEmployeeUrl));
      final s = await http.get(Uri.parse(e));
     List templineMovementList = jsonDecode(s.body);
     List TempList =  jsonDecode(lineEmployeeResponse.body);
    
        var selectedLostTime = lostTimeList.firstWhere((element) => element['name'] == 'Tam Gün izinli');
        setState(() {
          lostTimeId = selectedLostTime['id'];
        });
      
  
     
  for(int i = 0; i < templineMovementList.length;i++){
totalLineEmployees[templineMovementList[i]['lineId']] =  ( (totalLineEmployees[templineMovementList[i]['lineId']] ?? 0) + 1) ;




  }

ref.read(lineProvider.notifier).setLineFeatures(totalLineEmployees);  
TempList = TempList.where((element) => element['employeeId'] == widget.userId).toList();
final  List<int> linEmployeeIdList= [];
for(int i = 0; i< TempList.length; i++){
         
        linEmployeeIdList.add(TempList[i]['lineId']);
      }
posts = posts.where((element) => linEmployeeIdList.contains(element['id'])).toList();
setState(() {
  lineList = posts;
});
templineMovementList = templineMovementList.where((linemovement) => linemovement['lostTimeId'] == lostTimeId).toList();
setState(() {
  
for(int i = 0; i < lineList.length;i++){
  totalOffEmployees[lineList[i]['id']] = 0;
}


    for(int i = 0; i < templineMovementList.length;i++){
if(totalOffEmployees[templineMovementList[i]['lineId']] == null){
totalOffEmployees[templineMovementList[i]['lineId']] = 0;
}

totalOffEmployees[templineMovementList[i]['lineId']] =  ( (totalOffEmployees[templineMovementList[i]['lineId']] ?? 0) + 1) ;

  }
});
ref.read(permissionProvider.notifier).setPermissions(totalOffEmployees);




setState(() {
  loading = false;
});


}
@override
  void initState() {
        WidgetsBinding.instance.addPostFrameCallback((_) { 
            fetchLines(ref.watch(connectionProvider)['server'], ref.watch(connectionProvider)['port']);
        });

    super.initState();
 
  }



  Widget build(BuildContext context) {
     bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return loading ? const LoadingSpin() :  Scaffold(
      body: SafeArea(child:
      
         Column(
          children: [
            Expanded(child:      
         
          Padding(padding:const EdgeInsets.symmetric(horizontal: 10),
          child:         Column(
            children: [
                const  SizedBox(height: 40,),
               Center(
                  child: Text(AppLocalizations.of(context)!.linelist,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
                
                 ),
                 const Divider(height: 10,color: Colors.grey,),
                  Expanded(child:  
                 
                  
                          
         
      
      
       
      
      SingleChildScrollView(
        child: ListView.builder(
          physics:const NeverScrollableScrollPhysics(),
          shrinkWrap: true,itemCount: lineList.length,
          itemBuilder: (context, index) => 
          LineItem(
          totalOffEmployees: ref.watch(permissionProvider)[lineList[index]['id']].toString(),
          f: ref.watch(lineProvider),features: lineList[index],
          ))) 
      
      
        ,
   
      
      
      
      
      
      
       
      
       
                  ),
       
       
              
                 
      
            ],
          ) ,)
      
        
        ),
         
          ],
        ),
      )
       
);
    
  }
}