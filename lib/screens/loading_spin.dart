import 'package:flutter/material.dart';

class LoadingSpin extends StatelessWidget {
  const LoadingSpin({super.key});


  @override
  Widget build(BuildContext context) {
    return const Scaffold(
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
    SizedBox(height: 20,),
Text('İşlem yapılıyor...')
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