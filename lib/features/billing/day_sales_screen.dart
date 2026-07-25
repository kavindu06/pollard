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

class Day_Sales_Screen extends StatefulWidget {
  static const String id = 'day_sales_screen';
  const Day_Sales_Screen({Key? key}) : super(key: key);

  @override
  State<Day_Sales_Screen> createState() => _Day_Sales_ScreenState();
}

class _Day_Sales_ScreenState extends State<Day_Sales_Screen> {
  @override
  Widget build(BuildContext context) {
    FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;
    String userId = user!.uid;

    DateTime now = DateTime.now();
    DateTime today = DateTime(now.year, now.month, now.day);
    Timestamp startTimestamp = Timestamp.fromDate(today);
    Timestamp endTimestamp = Timestamp.fromDate(today.add(const Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Day Sales'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection("users/$userId/Selling")
            .where("date", isGreaterThanOrEqualTo: startTimestamp)
            .where("date", isLessThan: endTimestamp)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error: ${snapshot.error}',
                style: AppTextStyles.bodyLg,
              ),
            );
          }
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(color: AppColors.primary),
            );
          }

          final docs = snapshot.data!.docs;

          double totalSales = 0;
          for (final doc in docs) {
            final data = doc.data() as Map<String, dynamic>;
            final unitPrice = (data['firstNumber'] as num?)?.toDouble() ?? 0;
            final quantity = (data['secondNumber'] as num?)?.toDouble() ?? 0;
            totalSales += unitPrice * quantity;
          }

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            children: [
              SummaryCard(
                label: "Today's Sales",
                value: totalSales.toStringAsFixed(2),
                caption:
                    '${docs.length} transaction${docs.length == 1 ? '' : 's'} today',
              ),
              const SizedBox(height: AppSpacing.md),
              AppCard(
                child: Column(
                  children: [
                    const ListHeaderRow(
                      labels: ['Item', 'Price', 'Qty'],
                      columns: _columns,
                    ),
                    if (docs.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 32),
                        child: Text(
                          'No sales recorded today',
                          style: AppTextStyles.bodyMd,
                        ),
                      )
                    else
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: docs.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1, color: AppColors.outlineVariant),
                        itemBuilder: (context, index) {
                          final data = docs[index].data() as Map<String, dynamic>;
                          final itemType = data['type']?.toString() ?? '-';
                          final count = data['count']?.toString() ?? '-';
                          final unitPrice = (data['firstNumber'] as num?)?.toDouble() ?? 0;
                          final quantity = (data['secondNumber'] as num?)?.toDouble() ?? 0;

                          return DataRowItem(
                            columns: _columns,
                            cells: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    itemType,
                                    style: AppTextStyles.bodyLg
                                        .copyWith(fontWeight: FontWeight.w600),
                                  ),
                                  const SizedBox(height: 2),
                                  Text('No. $count', style: AppTextStyles.bodyMd),
                                ],
                              ),
                              Text(
                                unitPrice.toStringAsFixed(2),
                                style: AppTextStyles.dataMono,
                              ),
                              Text(
                                quantity.toStringAsFixed(
                                  quantity.truncateToDouble() == quantity ? 0 : 2,
                                ),
                                style: AppTextStyles.dataMono
                                    .copyWith(fontWeight: FontWeight.w700),
                              ),
                            ],
                          );
                        },
                      ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
