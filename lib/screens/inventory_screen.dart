import'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pollard/screens/selling_screen.dart';


class Inventory_Screen extends StatefulWidget {
  static const String id = 'inventory_screen';
  

  @override
  State<Inventory_Screen> createState() => _Inventory_ScreenState();
}

class _Inventory_ScreenState extends State<Inventory_Screen> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inventory'),
        backgroundColor: const Color(0xFF0A0E21),
        leading: const Icon(Icons.dataset_linked),
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: <Widget>[
                             Container(
                              decoration: BoxDecoration(color: Color(0xFFEB1555)),
                               child: Padding(
                                 padding: const EdgeInsets.all(8.0),
                                 child: Row(
                                  
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: const [
                                    
                                  
                                  Expanded(child: Text("Item",style: TextStyle(fontSize: 20.0))
                                  ),
                                  
                                  
                                  
                                  Expanded(
                                    child: Text('Quantity',style: TextStyle(fontSize: 20.0)),
                                  ),
                                  ],
                                     
                                                           ),
                               ),
                             ),
            StreamBuilder(
              
              stream: FirebaseFirestore.instance.collection("Stock").snapshots(),
              builder: (context,snapshot) {
            
                if (snapshot.hasData) {
                  return ListView.builder(
                      
                      reverse: false,
                      shrinkWrap: true,
                      itemCount: snapshot.data?.docs.length,
            
                      itemBuilder: (context,index){
                        DocumentSnapshot documentSnapshot=snapshot.data!.docs[index];
                        return Column(
                          children: [
                            
                            Row(
                            children: [
                              // Expanded(
                              //   child: Text(documentSnapshot["studentName"]),
                              // ),
                              
                              Expanded(
                                child: Text(documentSnapshot["type"].toString(),style: TextStyle(fontSize: 20.0)),
                              ),
                              
                              Expanded(
                                child: Text(documentSnapshot["secondNumber"].toString(),style: TextStyle(fontSize: 20.0)),
                              ),
                              
                                  
                            
                            ],
                          ),
                          const Divider(),
                          ]);
            
                      });
                } else if (snapshot.hasError) {
                  return Text(
                    'Error: ${snapshot.error}',
                    style: TextStyle(fontSize: 24.0),
                  );
                } else {
                  return CircularProgressIndicator();
                }
            
              },),
           
          
          ],
        ),
      ),
    );
  }
}
