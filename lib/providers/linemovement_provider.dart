


import 'package:flutter_riverpod/flutter_riverpod.dart';


class LineMovementProvider extends StateNotifier<List> {
LineMovementProvider() : super([]);        

void addElementProviderList (List lineMovement){
state = lineMovement;
}
void deleteEmployee(int id){
  state = state.where((element) => element['id'] != id).toList();
}
void updateLineMovement(int Id,String startTime,String losttime){
  state = state.map((linemovement) {
    if(Id == linemovement['id']){
                linemovement['employeeStartTime'] =  startTime;
                linemovement['losttime'] = losttime;

    }
    return linemovement;
  } 
  
    ).toList();

}




}
final lineMovementProvider  = StateNotifierProvider<LineMovementProvider,List>((ref) => LineMovementProvider());