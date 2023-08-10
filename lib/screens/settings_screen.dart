



import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/l10n/l10n.dart';

import 'package:itm_cheffapp/models/Setting.dart';
import 'package:itm_cheffapp/providers/connection_provider.dart';
import 'package:itm_cheffapp/providers/locale_provider.dart';
import 'package:itm_cheffapp/widgets/setting_item.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';





class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});
  @override
  ConsumerState<SettingsScreen> createState() => _SettingsState();
}

class _SettingsState extends ConsumerState<SettingsScreen> {


late final serverIdController = TextEditingController(text:ref.read(connectionProvider)['server']);
late final portIdController = TextEditingController(text:ref.read(connectionProvider)['port']);
late final usernameController = TextEditingController(text: ref.read(connectionProvider)['username']);
late final passwordController = TextEditingController(text: ref.read(connectionProvider)['password']);


void openServerId(){

 showDialog(context: context, 
  useRootNavigator: false,
  builder: (ctx) => 
  AlertDialog(
    shape:const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
    title:const Text('Server ID'),
    content:StatefulBuilder(
      
   builder: (context,StateSetter setState)  {
    var width = MediaQuery.of(context).size.width*0.7;

    return  Container(
      width: width,
      padding:const EdgeInsets.only(top: 15),
      child:TextField(
        keyboardType:const TextInputType.numberWithOptions(decimal: true),
        controller: serverIdController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1,color:Theme.of(context).colorScheme.secondary ))
        ),
      ),
    );
   }
   ),
    actions: [
      TextButton(onPressed: (){
      Navigator.pop(context);
      },
    child:Text(AppLocalizations.of(context)!.cancel)),
    TextButton(onPressed: (){
      ref.read(connectionProvider.notifier).setIPv4(serverIdController.text);
            Navigator.pop(context);
        
    }, child:Text(AppLocalizations.of(context)!.ok))
    ]
    ));


}

void openPortId(){
 
  showDialog(context: context, 
  useRootNavigator: false,
  builder: (ctx) => 
  AlertDialog(
    shape:const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
    title:const Text('PORT ID'),
    content:StatefulBuilder(
      
   builder: (context,StateSetter setState)  {
    var width = MediaQuery.of(context).size.width*0.7;

    return  Container(
      width: width,
      padding:const EdgeInsets.only(top: 15),
      child:TextField(
        keyboardType: TextInputType.number,
        controller: portIdController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1,color:Theme.of(context).colorScheme.secondary ))
        ),
      ),
    );
   }),
    actions: [
      TextButton(onPressed: (){
      Navigator.pop(context);
      },
    child:Text(AppLocalizations.of(context)!.cancel)),
    TextButton(onPressed: (){
  ref.read(connectionProvider.notifier).setPort(portIdController.text);
    Navigator.pop(context);
    }, child:Text(AppLocalizations.of(context)!.ok))
    ]
    ));
}


void openLanguage(){
showDialog(
  context: context,
  builder: (BuildContext context) {

  
  return AlertDialog(
    content: StatefulBuilder(
    
      builder: (context, setState) {
       return Column(
 mainAxisSize: MainAxisSize.min,
 children: [
  ListTile(
    title:const  Text('Türkçe'),
    leading: Radio(activeColor: Theme.of(context).colorScheme.primary,groupValue: ref.watch(localeProvider) ,value:  L10n.all[0],onChanged: (val){
         ref.read(localeProvider.notifier).setLocale(val!);
    },),
  ),
   ListTile(
    title: const Text('English'),
    leading: Radio(activeColor: Theme.of(context).colorScheme.primary,groupValue: ref.watch(localeProvider),value: L10n.all[1],onChanged: (val){
     ref.read(localeProvider.notifier).setLocale(val!);
    },),
  ),

 ],

       );
    },),
        actions: [
     
    TextButton(onPressed: (){
Navigator.of(context).pop();
    }, child:const Text('OK'))
    ]
  );
});
  
}

void changeUsername(){
    showDialog(context: context, 
  useRootNavigator: false,
  builder: (ctx) => 
  AlertDialog(
    shape:const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
    title: Text(AppLocalizations.of(context)!.username),
    content:StatefulBuilder(
      
   builder: (context,StateSetter setState)  {
    var width = MediaQuery.of(context).size.width*0.7;

    return  Container(
      width: width,
      padding:const EdgeInsets.only(top: 15),
      child:TextField(
        
        controller: usernameController,
        decoration: InputDecoration(
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1,color:Theme.of(context).colorScheme.secondary ))
        ),
      ),
    );
   }),
    actions: [
      TextButton(onPressed: (){
      Navigator.pop(context);
      },
    child: Text(AppLocalizations.of(context)!.cancel)),
    TextButton(onPressed: (){
    ref.read(connectionProvider.notifier).setUsername(usernameController.text);
    Navigator.pop(context);
    }, child:Text(AppLocalizations.of(context)!.ok))
    ]
    ));
}

void changePassword(){
    showDialog(context: context, 
  useRootNavigator: false,
  builder: (ctx) => 
  AlertDialog(
    shape:const RoundedRectangleBorder(
                   borderRadius: BorderRadius.all(Radius.circular(10.0)),
          ),
    title:Text(AppLocalizations.of(context)!.password),
    content:StatefulBuilder(
      
   builder: (context,StateSetter setState)  {
    var width = MediaQuery.of(context).size.width*0.7;

    return  Container(
      width: width,
      padding:const EdgeInsets.only(top: 15),
      child:TextField(
    obscureText: true,  
        controller: passwordController,
        decoration: InputDecoration(
    
          border: UnderlineInputBorder(borderSide: BorderSide(width: 1,color:Theme.of(context).colorScheme.secondary ))
        ),
      ),
    );
   }),
    actions: [
      TextButton(onPressed: (){
      Navigator.pop(context);
      },
    child:Text(AppLocalizations.of(context)!.cancel)),
    TextButton(onPressed: (){
    ref.read(connectionProvider.notifier).setPassword(passwordController.text);
    Navigator.pop(context);
    }, child: Text(AppLocalizations.of(context)!.ok))
    ]
    ));
}


@override


 void dispose() {
   
    serverIdController.dispose();
    portIdController.dispose();
    usernameController.dispose();
    passwordController.dispose();
     super.dispose();
  }


  @override
  Widget build(BuildContext context) {
   
    return Scaffold(


body:

SingleChildScrollView(
  child:   SafeArea(child: 
  Column(
  children: [
  SettingItem(setting:Setting(title: 'Server ID', subtitle: AppLocalizations.of(context)!.serviceDescription) , openModal:openServerId),
  SettingItem(setting:Setting(title: 'Port ID',subtitle:AppLocalizations.of(context)!.portDescription ) , openModal:openPortId),
  SettingItem(setting:Setting(title: AppLocalizations.of(context)!.language, subtitle: AppLocalizations.of(context)!.languageSelection) , openModal:openLanguage),  
  SettingItem(setting:Setting(title: AppLocalizations.of(context)!.username, subtitle: AppLocalizations.of(context)!.usernameDesc) , openModal:changeUsername), 
  SettingItem(setting:Setting(title: AppLocalizations.of(context)!.password, subtitle: AppLocalizations.of(context)!.passwordDesc) , openModal:changePassword), 
  ListTile(
  title: Text(AppLocalizations.of(context)!.version,style: TextStyle(fontSize: 20,color: Colors.grey.withOpacity(0.4)),),
  subtitle: Text('2.0.5',style: TextStyle(fontSize: 16,color: Colors.grey.withOpacity(0.8)),),
   shape: Border(bottom: BorderSide(color: Colors.grey.withOpacity(0.4),width: 1.5)),
  onTap:null,
    ),
  ] ,
  )),
)
);}
}