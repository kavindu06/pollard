import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';

import '../components/reusable_card.dart';
import '../constant.dart';

class Wallet_Screen extends StatefulWidget {
  const Wallet_Screen({super.key});
  static const String id = 'wallet_screen';
  @override
  State<Wallet_Screen> createState() => _Wallet_ScreenState();
}

class _Wallet_ScreenState extends State<Wallet_Screen> {
  final TextEditingController _initialNumberController =
      TextEditingController();
  // want to correct
  // int initialNumber = int.parse(_initialNumberController.text);
  int totalCoconut = 0;
  int totalCoconutValue = 0;
  int totalCoconutOil = 0;
  int totalCoconutOilValue = 0;
  int totalOther = 0;
  int totalOtherValue = 0;
  int totalQuantity = 0;
  int totalValue = 0;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  getInitialNumber(initialNumber) {
    initialNumber = initialNumber;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cashier'),
        backgroundColor: const Color(0xFF0A0E21),
        centerTitle: true,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            child: TextField(
              style: kNumberTextStyle,
              keyboardType: TextInputType.number,
              controller: _initialNumberController,
              decoration: const InputDecoration(
                labelText: 'Mila',
              ),
              onChanged: (String initialNumber) {
                getInitialNumber(initialNumber);
              },
            ),
            // ...
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () {},
            child: const Text('Add'),
          ),
          Expanded(
            child: ReusableCard(
              cardChild: Table(
                border: TableBorder.all(color: Colors.lightBlueAccent),
                children: [
                  TableRow(children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Item',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          'Quantity',
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Value',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blueGrey.shade800),
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Coconut',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalCoconut',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalCoconutValue',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      ]),
                  TableRow(children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Oil',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$totalCoconutOil',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('$totalCoconutOilValue',
                            style: TextStyle(
                              fontSize: 20,
                            )),
                      ),
                    ),
                  ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blueGrey.shade800),
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Other',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalOther',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalOtherValue',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      ]),
                  TableRow(
                      decoration:
                          BoxDecoration(color: Colors.blueGrey.shade800),
                      children: [
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Total',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalOther',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                        Center(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('$totalValue',
                                style: TextStyle(
                                  fontSize: 20,
                                )),
                          ),
                        ),
                      ]),
                ],
              ),
              colour: kActiveCardColor,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () {
              readData(0);
              readData(1);
              readData(2);
              calculateTotalValue();
            },
            child: const Text('Read'),
          ),
        ],
      ),
    );
  }

  void calculateTotalValue() {
    totalValue = totalCoconutValue + totalCoconutOilValue + totalOtherValue;
    totalQuantity = totalCoconut + totalCoconutOil + totalOther;
  }

  readData(int type) async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    CollectionReference newCollection =
        FirebaseFirestore.instance.collection("users/$userId/Selling");

    QuerySnapshot snapshot;

    DateTime now = DateTime.now();
    DateTime today =
        DateTime(now.year, now.month, now.day); // Get current date without time
    Timestamp startTimestamp = Timestamp.fromDate(today);
    Timestamp endTimestamp = Timestamp.fromDate(today.add(Duration(days: 1)));

    snapshot = await newCollection
        .where('type', isEqualTo: type)
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();

    int count = 0;
    int value = 0;

    for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      Map<String, Object?>? types = docSnapshot.data() as Map<String, Object?>?;
      int? secondNumber = types?['secondNumber'] as int?;
      int? price = types?['value'] as int?;
      if (secondNumber != null && price != null) {
        count += secondNumber;
        value += price;
      }
    }

    setState(() {
      if (type == 0) {
        totalCoconut = count;
        totalCoconutValue = value;
      } else if (type == 1) {
        totalCoconutOil = count;
        totalCoconutOilValue = value;
      } else if (type == 2) {
        totalOther = count;
        totalOtherValue = value;
      }
    });

    print('Total Count ($type): $count');
    print('Total Value ($type): $value');
  }
}
