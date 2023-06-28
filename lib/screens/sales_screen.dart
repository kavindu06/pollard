import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pollard/components/reusable_card.dart';

import '../constant.dart';

class SalesScreen extends StatefulWidget {
  static const String id = 'sales_screen';

  @override
  State<SalesScreen> createState() => _SalesScreenState();
}

class _SalesScreenState extends State<SalesScreen>
    with SingleTickerProviderStateMixin {
  final colorstheme = Color(0xff4b4b87);

  int totalCoconut = 0;
  int totalCoconutValue = 0;
  int totalCoconutOil = 0;
  int totalCoconutOilValue = 0;
  int totalOther = 0;
  int totalOtherValue = 0;
  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  TextEditingController _startDateController = TextEditingController();
  TextEditingController _endDateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Sales'),
        backgroundColor: const Color(0xFF0A0E21),
        centerTitle: true,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorstheme,
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
              // ...
              ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () {
              readData(0);
              readData(1);
              readData(2);
            },
            child: const Text('Read'),
          ),
          TextFormField(
            controller: _startDateController,
            readOnly: true,
            onTap: selectStartDate,
            decoration: InputDecoration(
              labelText: 'Start Date',
            ),
          ),
          TextFormField(
            controller: _endDateController,
            readOnly: true,
            onTap: selectEndDate,
            decoration: InputDecoration(
              labelText: 'End Date',
            ),
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
                      ])
                ],
              ),
              colour: kActiveCardColor,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> selectStartDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedStartDate = picked;
        _startDateController.text = DateFormat('MMM d, yyyy').format(picked);
      });
    }
  }

  Future<void> selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2022),
      lastDate: DateTime.now(),
    );

    if (picked != null) {
      setState(() {
        selectedEndDate = picked;
        _endDateController.text = DateFormat('MMM d, yyyy').format(picked);
      });
    }
  }

  readData(int type) async {
    CollectionReference newCollection =
        FirebaseFirestore.instance.collection("Selling");

    QuerySnapshot snapshot;

    if (selectedStartDate != null && selectedEndDate != null) {
      DateTime startDateTime = DateTime(
        selectedStartDate!.year,
        selectedStartDate!.month,
        selectedStartDate!.day,
      );
      DateTime endDateTime = DateTime(
        selectedEndDate!.year,
        selectedEndDate!.month,
        selectedEndDate!.day,
        23,
        59,
        59,
      );
      Timestamp startTimestamp = Timestamp.fromDate(startDateTime);
      Timestamp endTimestamp = Timestamp.fromDate(endDateTime);

      snapshot = await newCollection
          .where('type', isEqualTo: type)
          .where('date', isGreaterThanOrEqualTo: startTimestamp)
          .where('date', isLessThanOrEqualTo: endTimestamp)
          .get();
    } else {
      snapshot = await newCollection.where('type', isEqualTo: type).get();
    }

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

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(SalesScreen());
}
