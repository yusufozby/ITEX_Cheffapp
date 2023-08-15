

import 'package:flutter_riverpod/flutter_riverpod.dart';

class LineProvider extends StateNotifier<Map<dynamic,int>>
{
  LineProvider() : super({});
void setLineFeatures(Map<dynamic,int> features){
  state = features;
}
void increaseEmployeeQty(int id){

if(state[id] == null){

 state = {...state,id:1};
}

else {

state = {...state,id:state[id]!+1};
}
}

void decreaseEmployeeQty(int id){





}





}
final lineProvider= StateNotifierProvider<LineProvider,Map<dynamic,int>>((ref){
  return LineProvider();
});
