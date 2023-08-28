import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
class LoadingSpin extends StatelessWidget {
  const LoadingSpin({super.key});


  @override
  Widget build(BuildContext context) {
    return  Scaffold(
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
Text(AppLocalizations.of(context)!.loading)
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