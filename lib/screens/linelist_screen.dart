import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:http/http.dart' as http;
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/line_provider.dart';
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
      final lineEmployeeUrl = 'http://$server:$port/api/lineEmployee';
      final e = 'http://$server:$port/api/lineMovement';

      final lineEmployeeResponse = await http.get(Uri.parse(lineEmployeeUrl));
      final s = await http.get(Uri.parse(e));
      final List templineMovementList = jsonDecode(s.body);
     List TempList =  jsonDecode(lineEmployeeResponse.body);
      
  
     
  for(int i = 0; i < templineMovementList.length;i++){
totalLineEmployees[templineMovementList[i]['lineId']] =  ( (totalLineEmployees[templineMovementList[i]['lineId']] ?? 0) + 1) ;

  }



 
  





print(totalLineEmployees);
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
                child: Text('Bant Listesi',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 25,color: Theme.of(context).colorScheme.secondary),),
              
               ),
               const Divider(height: 10,color: Colors.grey,),
                Expanded(child:  
               
                
                        
   


 

ListView.builder(physics:const NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: lineList.length,itemBuilder: (context, index) => LineItem(f: ref.watch(lineProvider),features: lineList[index],)) 


      
   






 

 ,
                )

 
         

          ],
        ) ,)

      
      ),
   
        ],
      )
       
),
    );
  }
}