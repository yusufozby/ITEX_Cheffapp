import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:itm_cheffapp/screens/linelist_screen.dart';
import 'package:http/http.dart' as http;
import 'package:itm_cheffapp/screens/tabs_screen.dart';
class LoginForm extends StatefulWidget {
 
  const LoginForm({super.key});

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final usernameController = TextEditingController();
    final passwordController = TextEditingController();
bool isError = false;

String message = "";

  void dispose() {

    super.dispose();
    usernameController.dispose();
    passwordController.dispose();
  }
  @override

  Future<void> login() async{
try {
var url = 'http://192.168.1.7:5246/api/Auth';

 final response = await http.post(Uri.parse(url)

 ,headers: <String,String>{'Content-Type':'application/json'}
 ,body: jsonEncode( {
  'Username':usernameController.text.toString(),
 'Password':passwordController.text.toString(),
 'Job':'Sef'}
 ))
;


 if(response.statusCode >= 400){  
          setState(() {
         isError = true;
         message = "Hatalı kullanıcı adı veya şifre.";
          });
          return;
}
 else {

int lineId =  jsonDecode(response.body)['id'];
print(lineId);

   Navigator.of(context).push(MaterialPageRoute(builder: (ctx) =>TabsScreen(lineId: lineId,)));
    setState(() {
   isError = false;

  });

}
}
catch(e) {
     setState(() {
    
       message = "Geçersiz server ip veya port.";
       isError = true;
     });
    
}


 }



  Widget build(BuildContext context) {
    
var constraitsHeight = MediaQuery.of(context).size.height;

var constraitsWidth = MediaQuery.of(context).size.width;


  
    return  Column(
     
      children: [
            SizedBox(height: constraitsHeight >= 750 ? 60 : 30,),
              Center(
              
         child : Image(image:const AssetImage('assets/ITMtechSoft-logo.png'),width:constraitsWidth >= 750 ? 200 : 125,height: constraitsWidth >= 750 ? 200 :125,) ,
        ),
     const   SizedBox(height: 25,),
        Text('ITEX Soft',style: TextStyle(color: Colors.blue[600],fontSize: 20,letterSpacing: 3),),
        SizedBox(height:constraitsHeight >= 750 ?  60 : 30,),
       TextField(
      
    controller: usernameController,
    textInputAction: TextInputAction.next,
       decoration:const InputDecoration(

       hintText: "Username",
       enabledBorder:UnderlineInputBorder(
       borderSide: BorderSide( color:Colors.grey),
       ),
     ),),
   const    SizedBox(height: 30,),
       TextField(
        controller: passwordController,
        
        obscureText:true,
        decoration:const InputDecoration(
       
        hintText: "Password",
         
        enabledBorder:UnderlineInputBorder(
         borderSide: BorderSide( color:Colors.grey),
      ),
      
     
    
    
   ),

),
const SizedBox(height: 20,),
Visibility(visible: isError,child: 
  Center(child: Text(message,style:const TextStyle(color: Colors.red,fontSize: 20),),),),
     const  SizedBox(height: 20,),

      ElevatedButton(onPressed: login
       ,
       style: ElevatedButton.styleFrom(padding:constraitsWidth >= 750 ? const EdgeInsets.all(20): const EdgeInsets.all(10) ,foregroundColor: Theme.of(context).colorScheme.background,
       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
       minimumSize:const Size.fromHeight(35),backgroundColor: Colors.grey),
       child: Text('Giriş',
       style: 
       TextStyle(fontSize: constraitsWidth >= 750 ? 55 : 35,
       fontWeight: FontWeight.w800,
       letterSpacing: 2,)),
       )
,
    

const SizedBox(height: 10,)


            ]
            );
  }
}