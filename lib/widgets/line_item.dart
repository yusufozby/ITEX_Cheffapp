import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/providers/line_provider.dart';

import 'package:itm_cheffapp/screens/work_time_screen.dart';

import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import 'package:percent_indicator/percent_indicator.dart';

class LineItem extends ConsumerStatefulWidget {
const  LineItem({super.key,required this.features,required this.f,required this.totalOffEmployees});
  final Map<String,dynamic> features;
  final Map<dynamic,int> f;
 final String totalOffEmployees;

  @override
  ConsumerState<LineItem> createState() => _LineItemState();
}

class _LineItemState extends ConsumerState<LineItem> {
 
 
 String total="0";

  @override
  
void initState() {
  


    super.initState();
  
  }
  Widget build(BuildContext context) {

   
final double width  = MediaQuery.of(context).size.width ;
final bool isMobile = width >= 768;



    return GestureDetector(
      onTap: () {
      
  Navigator.of(context).push(MaterialPageRoute(builder: (ctx) => WorkTimeScreen(lineName: widget.features['name'],lineId: widget.features['id'])));
      },
      child:Card(
        child: Container(
        padding:const EdgeInsets.symmetric(vertical: 10 ),
        color: Theme.of(context).colorScheme.background, width: double.infinity,
        child: Row(
            children:  [
      
      Expanded(
       flex: 2,
       child:
      
       Column(
       
           children: [
      
            Text(AppLocalizations.of(context)!.productivity,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
        const SizedBox(height: 10,),
         
          
       CircularPercentIndicator(
      radius:isMobile ? 125 : 80,
       lineWidth: 15,
        percent:  double.parse(widget.features['efficient']) ,
        center: Text( "${double.parse(widget.features['efficient']).toStringAsFixed(0)}%" ,style:const TextStyle(fontWeight: FontWeight.bold,fontSize: 25),),
       backgroundColor: Theme.of(context).colorScheme.onBackground.withOpacity(0.1),
       progressColor:Theme.of(context).colorScheme.inversePrimary,
       
       ),
    
          
      
          ]
         ),
       
       
        )
        
         ,
      
     Expanded(child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
       children:  [
        
           Text(AppLocalizations.of(context)!.lineName,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
         
           Text(AppLocalizations.of(context)!.employeQty,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold),),
          SizedBox(height: 20,),
           Text(AppLocalizations.of(context)!.offQty,overflow: TextOverflow.ellipsis,style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 20,),
         
       ],  
      ),),
      
      
      
      Expanded(child: Column(
        
       children: [
       Text(widget.features['name'],style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary,overflow: TextOverflow.ellipsis,)),
        const  SizedBox(height: 20,),
           Text(ref.watch(lineProvider)[widget.features['id']] != null ? ref.watch(lineProvider)[widget.features['id']].toString() :  "0",style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary,overflow: TextOverflow.ellipsis,)),
        const  SizedBox(height: 20,),
           Text(widget.totalOffEmployees,style: TextStyle(fontWeight: FontWeight.bold,color: Theme.of(context).colorScheme.primary),overflow: TextOverflow.ellipsis),
        const  SizedBox(height: 20,),
        
       ],  
      ), )
      
      
      
          ],
        
        ),
           
          ),
      ) ,
    ) ;
  }
}