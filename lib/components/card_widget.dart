import 'package:flutter/material.dart';
import 'package:pollard/components/reusable_card.dart';

class CardWidget extends StatelessWidget {
  List data = [
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
    {"color": Color(0xffff6968)},
    {"color": Color(0xff7a54ff)},
    {"color": Color(0xffff8f61)},
    {"color": Color(0xff2ac3ff)},
    {"color": Color(0xff5a65ff)},
    {"color": Color(0xff96da45)},
    
  ];
  List data1 = [
    {"text": Text("data")},
    {"text": Text("data1")},
    {"text": Text("data2")},
    {"text": Text("data3")},
    {"text": Text("data4")},
    {"text": Text("data5")},
    {"text": Text("data")},
    {"text": Text("data")},
    {"text": Text("data")},
    {"text": Text("data")},
    {"text": Text("data")},
    {"text": Text("data")},
    
  ];

  final colorwhite = Colors.white;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 18.0),
      child: GridView.builder(
        itemCount: data.length,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          // crossAxisSpacing: 10
        ),
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child:ReusableCard(
              colour: data[index]["color"],
              cardChild:Column(children: [Text("hii")],), ),
            // child: Card(
            //   color: data[index]["color"],
            //   shape: RoundedRectangleBorder(
            //       borderRadius: BorderRadius.circular(20)),
            //   child: Padding(
            //     padding: const EdgeInsets.all(0.0),
            //     child: Column(
            //       children: [
            //         Row(
            //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
            //           children: [
            //             Text(
            //               '  Heart Rate',
            //               style: TextStyle(color: colorwhite, fontSize: 16),
            //             ),
            //             Container(
            //               padding: EdgeInsets.all(20),
            //               decoration: const BoxDecoration(
            //                   borderRadius: BorderRadius.only(
            //                       topLeft: Radius.circular(30),
            //                       bottomLeft: Radius.circular(30),
            //                       bottomRight: Radius.circular(30)),
            //                   color: Color.fromRGBO(255, 255, 255, 0.38)),
            //               child: Icon(
            //                 Icons.favorite,
            //                 color: colorwhite,
            //                 size: 30,
            //               ),
            //             )
            //           ],
            //         )
            //         ,Container(
            //           alignment: Alignment.topLeft,
            //           padding: EdgeInsets.only(left:10,bottom: 20),
            //           child: Text('Sales'
            //           ,style: TextStyle(
            //             fontSize: 27,
            //             color: colorwhite),
            //           )),
            //           Container(
            //           alignment: Alignment.bottomRight,
            //           padding: EdgeInsets.only(right:10),
            //           child: Column(
            //             children: [
            //               Text('Healthy'
            //               ,style: TextStyle(
            //                 fontSize: 18,
            //                 color: colorwhite),
            //               ),
            //               Text('50-120'
            //               ,style: TextStyle(
            //                 fontSize: 18,
            //                 color: colorwhite),
            //               ),
            //             ],
            //           ))
                 
            //       ],
            //     ),
            //   ),
            // ),
          );
        },
      ),
    );
  }
}