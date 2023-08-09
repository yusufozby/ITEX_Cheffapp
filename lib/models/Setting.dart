
import 'package:uuid/uuid.dart';

final uuid = Uuid();

class Setting {
   final String id;
   final String title;
   final String subtitle;
  
  Setting({
    required this.title,
    required this.subtitle,
 
   }) : id = uuid.v4() ;
}