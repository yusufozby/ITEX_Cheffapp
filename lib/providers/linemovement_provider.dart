


import 'package:flutter_riverpod/flutter_riverpod.dart';


class LineMovementProvider extends StateNotifier<List> {
LineMovementProvider() : super([]);        

void addElementProviderList (List lineMovement){
state = lineMovement;





}




}
final lineMovementProvider  = StateNotifierProvider<LineMovementProvider,List>((ref) => LineMovementProvider());