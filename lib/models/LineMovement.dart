

class LineMovement {
  final int id;
  final String nameSurname;
  final String startTime;
  final Condition condition;
  final String dateTime;
 final String lineName;
final int lineId;
final employeeId;

 LineMovement({
    required this.id,
    required this.condition,
    required this.nameSurname,
    required this.startTime,
    required this.dateTime,
  required this.lineName,
    required this.lineId,
    required this.employeeId
  });


}

enum Condition { 
  active,
  isOff,
  arrivedLate
}
const conditions = {
  Condition.active:'Aktif',
  Condition.arrivedLate:'Geç geldi',
  Condition.isOff:'izinli'
};