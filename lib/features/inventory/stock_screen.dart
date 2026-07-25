import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

const _columns = [
  RowColumn(flex: 2, align: TextAlign.left),
  RowColumn(),
  RowColumn(),
];

class Stock_Screen extends StatefulWidget {
  static const String id = 'stock_screen';

  @override
  State<Stock_Screen> createState() => _Stock_ScreenState();
}

class _Stock_ScreenState extends State<Stock_Screen> {
  static const double _lowStockThreshold = 10;

  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;

    User? user = auth.currentUser;
    String userId = user!.uid;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Stock'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        padding: const EdgeInsets.all(AppSpacing.md),
        child: AppCard(
          child: Column(
            children: <Widget>[
              const ListHeaderRow(
                labels: ['Item', 'Quantity', 'Status'],
                columns: _columns,
              ),
              StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users/$userId/Items")
                    .snapshots(),
                builder: (context, itemsSnapshot) {
                  final itemNames = <String, String>{
                    for (final doc in itemsSnapshot.data?.docs ?? [])
                      (doc['index'] as num).toInt().toString():
                          doc['name'] as String,
                  };

                  return StreamBuilder(
                    stream: FirebaseFirestore.instance
                        .collection("users/$userId/Stock")
                        .snapshots(),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        final docs = snapshot.data!.docs;
                        if (docs.isEmpty) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 32),
                            child: Center(
                              child: Text(
                                'No stock recorded',
                                style: AppTextStyles.bodyMd,
                              ),
                            ),
                          );
                        }
                        return ListView.separated(
                          reverse: false,
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: docs.length,
                          separatorBuilder: (context, index) => const Divider(
                              height: 1, color: AppColors.outlineVariant),
                          itemBuilder: (context, index) {
                            DocumentSnapshot documentSnapshot = docs[index];
                            final quantity =
                                (documentSnapshot["secondNumber"] as num?)
                                        ?.toDouble() ??
                                    0;
                            final isLowStock = quantity <= _lowStockThreshold;

                            return DataRowItem(
                              columns: _columns,
                              cells: [
                                Text(
                                  itemNames[
                                          documentSnapshot["type"].toString()] ??
                                      documentSnapshot["type"].toString(),
                                  style: AppTextStyles.bodyLg
                                      .copyWith(fontWeight: FontWeight.w600),
                                ),
                                Text(
                                  documentSnapshot["secondNumber"].toString(),
                                  style: AppTextStyles.dataMono,
                                ),
                                isLowStock
                                    ? StatusBadge.warning('Low Stock')
                                    : StatusBadge.success('In Stock'),
                              ],
                            );
                          },
                        );
                      } else if (snapshot.hasError) {
                        return Padding(
                          padding: const EdgeInsets.all(AppSpacing.md),
                          child: Text(
                            'Error: ${snapshot.error}',
                            style: AppTextStyles.bodyLg,
                          ),
                        );
                      } else {
                        return const Padding(
                          padding: EdgeInsets.all(AppSpacing.md),
                          child: Center(
                            child:
                                CircularProgressIndicator(color: AppColors.primary),
                          ),
                        );
                      }
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
