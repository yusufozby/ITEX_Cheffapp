

class LineMovement {
  final int id;
  final String nameSurname;

  final Condition condition;
  final String dateTime;
 final String lineName;
final int lineId;
final employeeId;

 LineMovement({
    required this.id,
    required this.condition,
    required this.nameSurname,
   
    required this.dateTime,
  required this.lineName,
    required this.lineId,
    required this.employeeId
  });


}

enum Condition { 
  active,
  isOff,
  arrivedLate,
  changeLine,
  earlyQuit,
  undefined,
  partlyOff

}
const conditions = {
  Condition.active:'Aktif',
  Condition.arrivedLate:'Geç geldi',
  Condition.isOff:'Tam Gün izinli',
  Condition.changeLine :'Bant Değişikliği',
  Condition.earlyQuit:'Erken Çıkış',
  Condition.undefined:'Devamsız',
  Condition.partlyOff :'Kısmi izinli'


};