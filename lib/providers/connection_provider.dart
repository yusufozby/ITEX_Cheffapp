




import 'package:dart_ipify/dart_ipify.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';




class ConnectionProvider extends StateNotifier<Map<String,dynamic>> {

  ConnectionProvider() : super({'port':'','username':'','password':'','server':''});
  
void getConnection () async{
  final ipv4 = await Ipify.ipv4();
 SharedPreferences prefs = await SharedPreferences.getInstance();
 if(prefs.getString('server') != null){
 state['server'] = prefs.getString('server');
   }
  else {
   state['server'] = ipv4;
  }
  if(prefs.getString('port') != null){
state['port'] = prefs.getString('port');
  }
  else {
     state['port'] = '5246';
  }
   
   if(prefs.getString('username') != null){
 state['username'] = prefs.getString('username');
   }
      if(prefs.getString('password') != null){
 state['password'] = prefs.getString('password');
   }






}
  void setIPv4(String serverOption) async {
         SharedPreferences prefs = await SharedPreferences.getInstance();
         state['server'] = serverOption;
           prefs.setString('server', serverOption);

  }
    void setPort(String serverOption) async{
                 SharedPreferences prefs = await SharedPreferences.getInstance();
         state['port'] = serverOption;
           prefs.setString('port', serverOption);

  }
  void setUsername(String username) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
          state['username'] = username;
          prefs.setString('username', username);
  }
    void setPassword(String password) async {
     SharedPreferences prefs = await SharedPreferences.getInstance();
          state['password'] = password;
          prefs.setString('password', password);
  }

}


 final connectionProvider = StateNotifierProvider<ConnectionProvider,Map<String,dynamic>>((ref){
  return ConnectionProvider();
 });
