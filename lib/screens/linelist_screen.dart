import 'dart:convert';

import 'package:flutter/material.dart';


import 'package:itm_cheffapp/screens/operatorlist_screen.dart';
import 'package:http/http.dart' as http;
class LineListScreen extends StatefulWidget {
  const LineListScreen({super.key});

  @override
  State<LineListScreen> createState() => _LineListScreenState();
}

class _LineListScreenState extends State<LineListScreen> {
Future<List> fetchLines() async{
  List posts = [];
    
      // This is an open REST API endpoint for testing purposes
      const apiUrl = 'http://192.168.1.48:5246/api/lines';

      final http.Response response = await http.get(Uri.parse(apiUrl));
      posts = json.decode(response.body);
    return posts;
}



  Widget build(BuildContext context) {
    return  Scaffold(
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
               
               SingleChildScrollView(
                child:               FutureBuilder(
  future: fetchLines(),
  builder: (ctx,snapshot) {

if(snapshot.hasError){
 return  Padding(padding: EdgeInsets.all(10),child:const Text('Bantlar yüklenirken bir hata oluştu. İnternet bağlantınızı kontrol edin') ,);
 
}

if(snapshot.connectionState == ConnectionState.done){
return ListView.builder(physics:const NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: snapshot.data!.length,itemBuilder: (context, index) => Card(
  margin:const EdgeInsets.all(2),
  color: Theme.of(context).colorScheme.onPrimary,
  child:    ListTile(
 
  leading: Text(snapshot.data![index]['name'],style:const TextStyle(fontSize: 20),),
  onTap: () {
    Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => OperatorListScreen(lineId: snapshot.data![index]['id'],lineName: snapshot.data![index]['name'],)));
  },

),
)) ; 


      
  }




 else  {
  return const Padding(padding: EdgeInsets.all(20),child: CircularProgressIndicator(),);
  }

  }
  ) )


 

,
               )

 ,
         

          ],
        ) ,)

      
      ),
   
        ],
      )
       
),
    );
  }
}