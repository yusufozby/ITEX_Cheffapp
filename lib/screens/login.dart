import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:itm_cheffapp/screens/settings_screen.dart';
import 'package:itm_cheffapp/widgets/login_form.dart';


class Login extends ConsumerStatefulWidget {
  
  const Login({super.key});
   
  @override
  ConsumerState<Login> createState() => _LoginState();
}

class _LoginState extends ConsumerState<Login> {

  @override
  Widget build(BuildContext context) {
    bool keyboardIsOpen = MediaQuery.of(context).viewInsets.bottom != 0;
    return Scaffold(
     
      appBar: AppBar(  title:Text('ITEX Operation Control '),actions: [
        PopupMenuButton(
       
        itemBuilder: (ctx)  {
        return   [
   PopupMenuItem(child: Text('Server Config'),value: 'Settings',)
  ];
      },
      onSelected: (value) => {
          if(mounted){
   Navigator.of(context).push(MaterialPageRoute(builder: (ctx)=>const SettingsScreen()))
          }
 
     
     },
     icon:const Icon(Icons.more_vert), 
      )
      ]
      ),
      body: 
       
       
       Column(

       
        children: [
       Expanded(child:
       SingleChildScrollView(
        child:     Container(
            
            padding:const EdgeInsets.fromLTRB(25, 0, 25, 0),
           width: double.infinity,
            child:const LoginForm()

          ),
       )
    , )   ,
  Visibility(child: Text('dsa'),visible: !keyboardIsOpen,)
        
        
          

        ],
      
      
      )
        
      


    );
  }
}