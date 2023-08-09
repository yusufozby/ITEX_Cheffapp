import 'package:flutter/material.dart';

class LoadingSpin extends StatelessWidget {
  const LoadingSpin({super.key,required this.addLoadingOperator});
  final bool addLoadingOperator;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      SafeArea(child:Column(
      children: [
Expanded(child: 
   Column(
    
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
    Center(
     
      child: SizedBox(
     
   
        width: 50,
        height: 50,
     
   
        child: CircularProgressIndicator(strokeWidth: 5,),),
        
    
    ),
    const SizedBox(height: 20,),
    Visibility(child: Text('Operatörler Ekleniyor...'),visible: addLoadingOperator,)
    ],
   )
   

       , )
      ],
    )
      )
,
    );
  }
}