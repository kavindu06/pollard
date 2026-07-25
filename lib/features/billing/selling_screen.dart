import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollard/features/billing/day_sales_screen.dart';
import 'package:intl/intl.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:pollard/theme/app_theme.dart';

class Selling_Screen extends StatefulWidget {
  static const String id = 'selling_screen';
  @override
  _Selling_ScreenState createState() => _Selling_ScreenState();
}

class _Selling_ScreenState extends State<Selling_Screen> {
  final TextEditingController _firstNumberController = TextEditingController();
  final TextEditingController _secondNumberController = TextEditingController();

  int _type = 0;

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
    
    int currentQuantity = 0;
if (snapshot.exists && snapshot.data() != null) {
  currentQuantity = (snapshot.data() as Map<String, dynamic>)['secondNumber'] ?? 0;
}

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

  CollectionReference get _itemsCollection {
    final userId = FirebaseAuth.instance.currentUser!.uid;
    return FirebaseFirestore.instance.collection("users/$userId/Items");
  }

  Widget _buildTypeChip({
    required String label,
    required bool selected,
    required VoidCallback onPressed,
  }) {
    return ChoiceChip(
      label: Text(label),
      selected: selected,
      onSelected: (_) => onPressed(),
      labelStyle: AppTextStyles.labelMd.copyWith(
        color: selected ? AppColors.primary : AppColors.onSurfaceVariant,
      ),
      backgroundColor: Colors.transparent,
      selectedColor: AppColors.surfaceContainer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        side: BorderSide(color: AppColors.outlineVariant),
      ),
    );
  }

  Future<void> _showAddItemDialog() async {
    final controller = TextEditingController();
    final name = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Item'),
        content: TextField(
          controller: controller,
          autofocus: true,
          decoration: const InputDecoration(labelText: 'Item name'),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text.trim()),
            child: const Text('Add'),
          ),
        ],
      ),
    );

    if (name == null || name.isEmpty) return;

    final existing = await _itemsCollection.get();
    await _itemsCollection.add({
      'name': name,
      'index': existing.docs.length,
    });
  }

  Widget _buildItemSelector() {
    return StreamBuilder<QuerySnapshot>(
      stream: _itemsCollection.orderBy('index').snapshots(),
      builder: (context, snapshot) {
        final docs = snapshot.data?.docs ?? [];

        return Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final doc in docs)
              _buildTypeChip(
                label: doc['name'] as String,
                selected: _type == (doc['index'] as num).toInt(),
                onPressed: () {
                  setState(() {
                    _type = (doc['index'] as num).toInt();
                  });
                },
              ),
            ActionChip(
              avatar: const Icon(Icons.add, size: 18),
              label: const Text('Add item'),
              onPressed: _showAddItemDialog,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.lg),
                side: BorderSide(color: AppColors.outlineVariant),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildEntryCard({
    required String label,
    required TextEditingController controller,
    required String hintLabel,
    required ValueChanged<String> onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.outlineVariant),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.labelMd),
          const SizedBox(height: AppSpacing.xs),
          TextField(
            style: AppTextStyles.headlineMd,
            keyboardType: TextInputType.number,
            controller: controller,
            decoration: InputDecoration(
              labelText: hintLabel,
            ),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Selling'),
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _buildItemSelector(),
            const SizedBox(height: AppSpacing.md),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _buildEntryCard(
                    label: 'UNIT PRICE',
                    controller: _firstNumberController,
                    hintLabel: 'Price',
                    onChanged: getFirstNumber,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: _buildEntryCard(
                    label: 'QUANTITY',
                    controller: _secondNumberController,
                    hintLabel: 'Quantity',
                    onChanged: getSecondNumber,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.lg),
            Center(
              child: Text(
                'Result: $_result',
                style: AppTextStyles.displayBilling,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
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
              child: const Text('CALCULATE'),
            ),
          ],
        ),
      ),
    );
  }
}
