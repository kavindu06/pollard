import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

const _columns = [
  RowColumn(flex: 2, align: TextAlign.left),
  RowColumn(),
  RowColumn(),
];

class Wallet_Screen extends StatefulWidget {
  const Wallet_Screen({super.key});
  static const String id = 'wallet_screen';
  @override
  State<Wallet_Screen> createState() => _Wallet_ScreenState();
}

class _Wallet_ScreenState extends State<Wallet_Screen> {
  final TextEditingController _initialNumberController =
      TextEditingController();

  int totalCoconut = 0;
  int totalCoconutValue = 0;
  int totalCoconutOil = 0;
  int totalCoconutOilValue = 0;
  int totalOther = 0;
  int totalOtherValue = 0;
  int totalQuantity = 0;
  int totalValue = 0;
  int endTotal = 0;
  int startNumber = 0;

  DateTime? selectedStartDate;
  DateTime? selectedEndDate;

  getInitialNumber(initialNumber) {
    initialNumber = initialNumber;
  }

  createData() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    DateTime now = DateTime.now();

    String formattedDate = DateFormat('yyyy-MM-dd-kk:mm:ss').format(now);

    CollectionReference collectionReference =
        FirebaseFirestore.instance.collection("users/$userId/Start Cashier");

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int initialNumber = int.parse(_initialNumberController.text);

    Map<String, dynamic> start = {
      "initialNumber": initialNumber,
      "date": now,
    };

    collectionReference.doc(formattedDate).set(start).whenComplete(() {
      print('created');
    });

    // Update stock quantity in Firestore
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
    print('total:$totalValue');
  }

  readData2() async {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    CollectionReference newCollection =
        FirebaseFirestore.instance.collection("users/$userId/Start Cashier");

    QuerySnapshot snapshot;

    DateTime now = DateTime.now();
    DateTime today =
        DateTime(now.year, now.month, now.day); // Get current date without time
    Timestamp startTimestamp = Timestamp.fromDate(today);
    Timestamp endTimestamp = Timestamp.fromDate(today.add(Duration(days: 1)));

    snapshot = await newCollection
        .where('date', isGreaterThanOrEqualTo: startTimestamp)
        .where('date', isLessThanOrEqualTo: endTimestamp)
        .get();
    int inNumber = 0;
    for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
      Map<String, dynamic> data = docSnapshot.data() as Map<String, dynamic>;
      int initialNumber = data['initialNumber'] as int;
      inNumber = initialNumber;
      print('Initial Number: $inNumber');
    }
    setState(() {
      startNumber = inNumber;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Wallet'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextField(
            style: AppTextStyles.displayBilling,
            keyboardType: TextInputType.number,
            controller: _initialNumberController,
            decoration: const InputDecoration(
              labelText: 'Start Cashier',
            ),
            onChanged: (String initialNumber) {
              getInitialNumber(initialNumber);
            },
          ),
          const SizedBox(height: AppSpacing.sm),
          ElevatedButton(
            onPressed: () => {
              createData(),
              _initialNumberController.clear(),
              FocusManager.instance.primaryFocus?.unfocus(),
            },
            child: const Text('Add'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                const ListHeaderRow(
                  labels: ['Item', 'Quantity', 'Value'],
                  columns: _columns,
                ),
                _walletRow('Coconut', '$totalCoconut', '$totalCoconutValue'),
                const Divider(height: 1),
                _walletRow('Oil', '$totalCoconutOil', '$totalCoconutOilValue'),
                const Divider(height: 1),
                _walletRow('Other', '$totalOther', '$totalOtherValue'),
                const Divider(height: 1),
                _walletRow('Total', '', '$totalValue', bold: true),
                const Divider(height: 1),
                _walletRow('Start Cashier', '', '$startNumber'),
                const Divider(height: 1),
                _walletRow('End Cashier', '', '$endTotal', bold: true),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () => {
              readData(0),
              readData(1),
              readData(2),
              readData2(),
              calculateTotalValue(),
            },
            child: const Text('Read'),
          ),
        ],
      ),
    );
  }

  Widget _walletRow(String label, String quantity, String value, {bool bold = false}) {
    return DataRowItem.texts(
      values: [label, quantity, value],
      columns: _columns,
      bold: bold,
    );
  }

  void calculateTotalValue() {
    setState(() {
      totalValue = totalCoconutValue + totalCoconutOilValue + totalOtherValue;
      totalQuantity = totalCoconut + totalCoconutOil + totalOther;
      endTotal = totalValue + startNumber;
    });
  }
}
