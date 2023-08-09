import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:remixicon/remixicon.dart';

class OperatorDetail extends StatefulWidget {
  const OperatorDetail({super.key});

  @override
  State<OperatorDetail> createState() => _OperatorDetailState();
}

class _OperatorDetailState extends State<OperatorDetail> {

 bool lineChange= false;
  final operatorController = TextEditingController(text: "Yusuf Özbay");
  @override
  Widget build(BuildContext context) {
     final List<String> items = ['item1','item2','item3','item4','item5','item6','item7','item8','item9','item10','item21','item33','eitem1','i2tem2','i2tem3','itesm1','itsewqem2','itetem3','item3211','itemewq2','iteeem3','itewqem1','iewqtem2','itemewq3','iteweqdsam1','itemdsa2','itegfdgfdm3','itemgfd1','itemgfdgfd2','itemgfdgfd3',];
     final List<String> cases = ['Geç geldi','Aktif','Tüm gün izinli'];
     
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return
  SingleChildScrollView(
    child:Padding(padding: EdgeInsets.fromLTRB(16,48,16,keyboardSpace+50),child: 
    Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children:<Widget>[
      TextField(
        enabled: false,
controller: operatorController,
        decoration:const InputDecoration(label: Text('Operatör Adı')),
       
        
      ),
 
          Row(children: <Widget>[
            Expanded(child:          DropdownButtonFormField<String>(value: 'Aktif',items: cases.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: (v){

 }
        
       
 
 ),),
   
  
 
     
    
           
    
      ],
      ),
      const SizedBox(height: 10,),
     
       Text('Çalışma',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
            Row(
        children: [
          Expanded(child: 
          Column(
            children: [
              Text('Başlangıç Saati'),
              const SizedBox(height: 10,),
    Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]!)
        

      ),
      padding: EdgeInsets.all(5),
      
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('data'),
                       GestureDetector(
                  onTap: () {
                    showTimePicker(context: context, initialTime: TimeOfDay.now());
                  },
                  child:const Icon(Remix.time_fill,size: 18,),
                )
              ],
            ),
          )
            ],
          )),
          const SizedBox(width: 15,),
             Expanded(child: 
          Column(
            children: [
              Text('Bitiş Saati'),
              const SizedBox(height: 10,),
    Container(
      decoration: BoxDecoration(
        color:  Theme.of(context).colorScheme.background,
        borderRadius: BorderRadius.all(Radius.circular(5)),
        border: Border.all(color: Colors.grey[300]!)
        

      ),
      padding: EdgeInsets.all(5),
      
            child: Row(

              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('data'),
                GestureDetector(
                  onTap: () {
                    showTimePicker(context: context, initialTime: TimeOfDay.now());
                  },
                  child:const Icon(Remix.time_fill,size: 18,),
                )
              ],
            ),
          )
            ],
          )),
      
        ],
      ),
      const SizedBox(height: 15,),

       Text('Bant Değişikliği',style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold),textAlign: TextAlign.center,), 
      
      
      const Divider(height: 30,color: Colors.grey,),
            Row(
        children: [
          Expanded(child: 
          Column(
            children: [
              Text('Aktif Bant'),
              const SizedBox(height: 10,),
                     DropdownButtonFormField<String>(value: items[0],items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: null
        
       
 
 )
   
            ],
          )),
          const SizedBox(width: 15,),
             Expanded(child: 
          Column(
            children: [
             const Text('Gideceği Bant'),
              const SizedBox(height: 10,),
             
       DropdownButtonFormField<String>(value: items[0],items: items.map((e) => DropdownMenuItem<String>(value: e,child: Text(e))).toList(), onChanged: (v){
if(v == items[0]){
return;
}

setState(() {
  lineChange = true;
});
 }
        
       
 
 )
            ],
          )),
      
        ],
      ),

Row(
  mainAxisAlignment: MainAxisAlignment.end,
  children: [
    Text('Bant Değişikliğini Onayla',style: TextStyle(fontSize: 12),),
    Checkbox(value: lineChange, onChanged: (value){
      setState(() {
        lineChange = value!;
      });
    },)
  ],
),


 const SizedBox(height: 10,),
      Row(
        children: [
       
  
    const Spacer(),


          TextButton(
          onPressed: (){Navigator.pop(context);}, 
        child:const Text('İptal'))
        ,
        
        
        
         ElevatedButton(
          onPressed: (){
            showDialog(useRootNavigator: false,context: context, builder: (ctx)=>    AlertDialog(content: Text('Bant değişikliğini onaylamadınız. İşleme devam etmek istediğinizden emin misiniz ?',style: TextStyle(fontSize: 13,height: 1.5),),
            actions: [
              TextButton(onPressed: (){
                Navigator.of(context).pop();
              }, child: Text('Hayır'.toUpperCase())),
              TextButton(onPressed: (){

                Navigator.of(context).pop();
                Navigator.of(context).pop();
              
              }, child: Text('Evet'.toUpperCase()))
            ],));
        
            
          }, 
          child:const  Text('Tamam'))],
      ),

    
    ]
    ),
    )  ,
  ) 
  
     ;
  }
}


