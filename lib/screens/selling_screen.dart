import 'package:flutter/material.dart';
import 'package:pollard/components/reusable_card.dart';
import 'package:pollard/constant.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pollard/screens/day_sales_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Selling_Screen extends StatefulWidget {
  static const String id = 'selling_screen';
  @override
  _Selling_ScreenState createState() => _Selling_ScreenState();
}

class _Selling_ScreenState extends State<Selling_Screen> {
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();

  int _type = 0;
  bool _isSelected1 = true;
  bool _isSelected2 = false;
  bool _isSelected3 = false;

  int _result = 0;

  int _counter = 0;

  late String studentName;
  // String userId = '';

  DateTime now = DateTime.now();

  getFirstNumber(firstNumber) {
    firstNumber = firstNumber;
  }

  getSecondNumber(secondNumber) {
    secondNumber = secondNumber;
  }

  // getStudentName(name){
  //   studentName = name;
  // }

  // createData() {
  //   print('created');

  //   String formattedDate = DateFormat('yyyy-MM-dd-kk:mm').format(now);

  //   DocumentReference documentReference =
  //       FirebaseFirestore.instance.collection("Selling").doc(formattedDate);

  //   num firstNumber = int.parse(_firstNumberController.text);
  //   num secondNumber = int.parse(_secondNumberController.text);

  //   Map<String, dynamic> selling = {
  //     // "studentName": studentName,
  //     "firstNumber": firstNumber,
  //     "secondNumber": secondNumber,
  //     "type": _type,
  //     "count": _counter,
  //   };

  //   documentReference.set(selling).whenComplete(() {
  //     print('$_counter  created');
  //   });
  // }

  createData() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    print('created');
    print('User ID: $userId');

    DateTime now = DateTime.now();
    print(now);
    String formattedDate = DateFormat('yyyy-MM-dd-kk:mm:ss').format(now);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users/$userId/Selling");

    CollectionReference collectionReference2 =
        FirebaseFirestore.instance.collection("users/$userId/Stock");

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    num firstNumber = int.parse(_firstNumberController.text);
    int secondNumber = int.parse(_secondNumberController.text);

    Map<String, dynamic> selling = {
      "firstNumber": firstNumber,
      "secondNumber": secondNumber,
      "type": _type,
      "count": _counter,
      "date": now,
      "value": _result,
    };
    Map<String, dynamic> Stock = {
      "secondNumber": secondNumber,
      "type": _type,
    };

    collectionReference.doc(formattedDate).set(selling).whenComplete(() {
      print('$_counter created');
    });

    // Update stock quantity in Firestore
    DocumentSnapshot snapshot =
        await firestore.collection("users/$userId/Stock").doc('$_type').get();
    int currentQuantity =
        (snapshot.data() as Map<String, dynamic>)['secondNumber'] as int;

    // Calculate the updated quantity after selling
    int updatedQuantity = currentQuantity - secondNumber;

    // Ensure the updated quantity does not go below zero
    if (updatedQuantity < 0) {
      updatedQuantity = 0;
    }

    // Update the stock quantity in Firestore
    await firestore
        .collection("users/$userId/Stock")
        .doc('$_type')
        .update({'secondNumber': updatedQuantity});
  }

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  void _printDateTime() {
    DateTime now = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(now);
    print(formattedDate);
  }

  void _multiplyNumbers() {
    int firstNumber = int.tryParse(_firstNumberController.text) ?? 0;
    int secondNumber = int.tryParse(_secondNumberController.text) ?? 0;

    setState(() {
      _result = firstNumber * secondNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: const Color(0xFF0A0E21),
          title: Text('Selling'),
          leading: const Icon(Icons.sell)),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: IconButton(
                          iconSize: 72,
                          icon: const Icon(Icons.home),
                          onPressed: () {
                            _type = 0;
                            print(_type);
                            setState(() {
                              _isSelected1 = true;
                              _isSelected2 = false;
                              _isSelected3 = false;
                            });
                          },
                          color: _isSelected1 == true
                              ? Color.fromARGB(255, 248, 248, 247)
                              : Color.fromARGB(104, 104, 166, 228)),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            _type = 1;
                            print(_type);
                            setState(() {
                              _isSelected1 = false;
                              _isSelected2 = true;
                              _isSelected3 = false;
                            });
                          },
                          iconSize: 72,
                          icon: const Icon(Icons.water_drop_rounded),
                          color: _isSelected2 == true
                              ? Color.fromARGB(255, 248, 248, 247)
                              : Color.fromARGB(104, 104, 166, 228)),
                    ),
                    Expanded(
                      child: IconButton(
                          onPressed: () {
                            _type = 2;
                            print(_type);
                            setState(() {
                              _isSelected1 = false;
                              _isSelected2 = false;
                              _isSelected3 = true;
                            });
                          },
                          iconSize: 72,
                          icon: const Icon(Icons.bed),
                          color: _isSelected3 == true
                              ? Color.fromARGB(255, 248, 248, 247)
                              : Color.fromARGB(104, 104, 166, 228)),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    children: [
                      Expanded(
                        child: ReusableCard(
                          colour: kActiveCardColor,
                          cardChild: Column(
                            children: [
                              const Text('Unit Price', style: kTextStyle),
                              Container(
                                child: TextField(
                                  style: kNumberTextStyle,
                                  keyboardType: TextInputType.number,
                                  controller: _firstNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Mila',
                                  ),
                                  onChanged: (String firstNumber) {
                                    getFirstNumber(firstNumber);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: ReusableCard(
                          colour: kActiveCardColor,
                          cardChild: Column(
                            children: [
                              const Text('Quantity', style: kTextStyle),
                              Container(
                                child: TextField(
                                  style: kNumberTextStyle,
                                  keyboardType: TextInputType.number,
                                  controller: _secondNumberController,
                                  decoration: const InputDecoration(
                                    labelText: 'Quantity',
                                  ),
                                  onChanged: (String secondNumber) {
                                    getSecondNumber(secondNumber);
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Center(
            child: Text(
              'Result: $_result',
              style: kNumberTextStyle,
            ),
          ),
          ElevatedButton(
            onPressed: () => {
              _multiplyNumbers(),
              createData(),
              _incrementCounter(),
              _printDateTime(),
              _firstNumberController.clear(),
              _secondNumberController.clear(),
              Navigator.pushNamed(context, Day_Sales_Screen.id),
            },
            child: const Text(
              'CALCULATE',
              style: TextStyle(fontSize: 30, color: Colors.white),
            ),
            style: ElevatedButton.styleFrom(
              primary: Color(0xFFEB1555),
              shadowColor: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }
}
