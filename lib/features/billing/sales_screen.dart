import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

const _columns = [
  RowColumn(flex: 2, align: TextAlign.left),
  RowColumn(),
  RowColumn(),
];

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
        title: const Text('Sales'),
        centerTitle: true,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          TextFormField(
            controller: _startDateController,
            readOnly: true,
            onTap: selectStartDate,
            decoration: const InputDecoration(
              labelText: 'Start Date',
              suffixIcon: Icon(Icons.calendar_today, size: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          TextFormField(
            controller: _endDateController,
            readOnly: true,
            onTap: selectEndDate,
            decoration: const InputDecoration(
              labelText: 'End Date',
              suffixIcon: Icon(Icons.calendar_today, size: 18),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          ElevatedButton(
            onPressed: () {
              readData(0);
              readData(1);
              readData(2);
            },
            child: const Text('Read'),
          ),
          const SizedBox(height: AppSpacing.md),
          AppCard(
            child: Column(
              children: [
                const ListHeaderRow(
                  labels: ['Item', 'Quantity', 'Value'],
                  columns: _columns,
                ),
                _salesRow('Coconut', totalCoconut, totalCoconutValue),
                const Divider(height: 1),
                _salesRow('Oil', totalCoconutOil, totalCoconutOilValue),
                const Divider(height: 1),
                _salesRow('Other', totalOther, totalOtherValue),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _salesRow(String label, int quantity, int value) {
    return DataRowItem.texts(
      values: [label, '$quantity', '$value'],
      columns: _columns,
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
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    CollectionReference newCollection =
        FirebaseFirestore.instance.collection("users/$userId/Selling");

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
