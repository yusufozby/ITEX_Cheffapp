import 'package:flutter_riverpod/flutter_riverpod.dart';


class PermissionProvider extends StateNotifier<Map<dynamic,int>> {
PermissionProvider() : super({});        

void setPermissions (Map<dynamic,int> losttime){
state = {...state,...losttime};
}
void increasePermissionQty(int id){

if(state[id] == null){

 state = {...state,id:1};
}

else {

state = {...state,id:state[id]!+1};
}
}

void decreasePermissionQty(int id){

if(state[id] == null){

return;
}

else {

state = {...state,id:state[id]!-1};
}
}



}
final permissionProvider = StateNotifierProvider<PermissionProvider,Map<dynamic,int>>((ref){
  return PermissionProvider();
});