import 'package:flutter/material.dart';
import 'package:itm_cheffapp/screens/operator_detail_screen.dart';


class WorkTimeScreen extends StatelessWidget {
  const WorkTimeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SafeArea(child: 
      Padding(
        padding:const EdgeInsets.symmetric(vertical: 20,horizontal: 10),
        child: Column(
        children: [
            Row(
mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [ Container(
                  padding:const EdgeInsets.symmetric(vertical: 10),
              

                
             
                child:   const   Text('Line 1 Operatör Listesi',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),textAlign: TextAlign.center) ,
                
               
                  
           
              ),
       
            Container(
                     padding:const EdgeInsets.symmetric(vertical: 10),
                
                
                child: 
              Column(
                children: [
                  Text('Anlık Saat'),
 Text('09:46',textAlign: TextAlign.center,style: TextStyle(fontSize: 30,fontWeight: FontWeight.bold),),
                ],
              )
               
              )],
            ),
            const SizedBox(height: 20,),
        
            Row(
              children: [
                Expanded(child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text('Featured',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),),
                )),
                  Expanded(child: Container(
                    height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text('Tarih',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),),
                )),
                 Expanded(child: Container(
                  height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10,horizontal: 5),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text('Başlama Saati',style: TextStyle(fontSize: 11,color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                )),
                Expanded(child: Container(
                  alignment: Alignment.center,
                  height: 50,
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border(
                    top: BorderSide(color: Colors.grey,width: 1),
                    left: BorderSide(color: Colors.grey,width: 1),
                    bottom: BorderSide(color: Colors.grey,width: 1),
                   )
                  ),
             
                  child: Text('Çalışma Süresi',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),textAlign: TextAlign.center,),
                )),
                  Expanded(child: Container(
                    height: 50,
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(vertical: 10),
                  decoration: BoxDecoration(
                         color: Theme.of(context).colorScheme.primary,
                   border: Border.all(color: Colors.grey,width: 1)
                  ),
             
                  child: Text('Durum',style: TextStyle(fontSize: 12,color: Theme.of(context).colorScheme.onPrimary),),
                )),
              ],
            ),
            Expanded(child:  SingleChildScrollView(
              
              child: 
              ListView.builder(physics:const NeverScrollableScrollPhysics(),shrinkWrap: true,itemCount: 50,itemBuilder: (context, index) =>
              InkWell(
                onTap: () {
                  showModalBottomSheet(context: context,isScrollControlled: true, builder: (ctx)
                  {
return FractionallySizedBox(
  heightFactor: 1,
  child:  OperatorDetail(),
);
                  }
                 );
                },
                child:    Row(
              children: [
               Expanded(child:
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration:const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey)
                  ,bottom: BorderSide(color: Colors.grey) )
                ),
                child:const  Text('Hüseyin Akyer',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
               ),
               
                          Expanded(child:
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey)
                  ,bottom: BorderSide(color: Colors.grey) )
                ),
                child:const  Text('07.09.2023',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
               ),
                              Expanded(child:
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey)
                  ,bottom: BorderSide(color: Colors.grey) )
                ),
                child:  Text('08:00',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
               ),
                                  Expanded(child:
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(left: BorderSide(color: Colors.grey)
                  ,bottom: BorderSide(color: Colors.grey) )
                ),
                child:  Text('95',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
               ),
                                      Expanded(child:
               Container(
                height: 40,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border(
                  left: BorderSide(color: Colors.grey)
                  ,bottom: BorderSide(color: Colors.grey)  ,
                  right:        BorderSide(color: Colors.grey)   
                   )
                ),
                child:  Text('Aktif',overflow: TextOverflow.ellipsis,maxLines: 2,style: TextStyle(fontSize: 11),textAlign: TextAlign.center,),) ,
               ),
              ],
            ),
              )
              
             ,)
              
                
            )
            
            )
        
        ],
      )
      ),
    )
    );
  }
}