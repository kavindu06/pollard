import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pollard/features/billing/day_sales_screen.dart';
import 'package:pollard/features/inventory/stock_screen.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

final _quantityFormat = NumberFormat('#,##0.##');

class Home_Screen extends StatefulWidget {
  static const String id = 'home_screen';

  @override 
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen> {
  static const double _lowStockThreshold = 10;

  static const _typeNames = {0: 'Coconut', 1: 'Oil', 2: 'Other'};

  String _typeName(dynamic type) {
    if (type is int) return _typeNames[type] ?? 'Other';
    return type?.toString() ?? 'Other';
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final startTimestamp = Timestamp.fromDate(today);
    final endTimestamp = Timestamp.fromDate(today.add(const Duration(days: 1)));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          // Today's sales + orders + top products, from today's Selling docs.
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users/$userId/Selling")
                .where("date", isGreaterThanOrEqualTo: startTimestamp)
                .where("date", isLessThan: endTimestamp)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}',
                    style: AppTextStyles.bodyMd);
              }
              if (!snapshot.hasData) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: CircularProgressIndicator(color: AppColors.primary),
                  ),
                );
              }

              final docs = snapshot.data!.docs;

              double totalSales = 0;
              final Map<String, double> soldByType = {};
              for (final doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final unitPrice = (data['firstNumber'] as num?)?.toDouble() ?? 0;
                final quantity = (data['secondNumber'] as num?)?.toDouble() ?? 0;
                totalSales += unitPrice * quantity;
                final name = _typeName(data['type']);
                soldByType[name] = (soldByType[name] ?? 0) + quantity;
              }
              final topProducts = soldByType.entries.toList()
                ..sort((a, b) => b.value.compareTo(a.value));

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  SummaryCard(
                    label: "Today's Sales",
                    value: totalSales.toStringAsFixed(2),
                    caption:
                        '${docs.length} transaction${docs.length == 1 ? '' : 's'} today',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  StatCard(
                    label: 'Total Orders',
                    value: '${docs.length}',
                    caption: 'Completed today',
                    icon: Icons.shopping_cart_outlined,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  _TopProductsCard(
                    products: topProducts,
                    onViewAll: () =>
                        Navigator.pushNamed(context, Day_Sales_Screen.id),
                  ),
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // Stock totals + low stock alert.
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users/$userId/Stock")
                .snapshots(),
            builder: (context, snapshot) {
              if (!snapshot.hasData) return const SizedBox.shrink();

              final docs = snapshot.data!.docs;
              double totalItems = 0;
              int lowStockCount = 0;
              for (final doc in docs) {
                final data = doc.data() as Map<String, dynamic>;
                final quantity = (data['secondNumber'] as num?)?.toDouble() ?? 0;
                totalItems += quantity;
                if (quantity <= _lowStockThreshold) lowStockCount++;
              }

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  StatCard(
                    label: 'Total Items',
                    value: _quantityFormat.format(totalItems),
                    caption: 'In stock across ${docs.length} products',
                    icon: Icons.inventory_2_outlined,
                  ),
                  if (lowStockCount > 0) ...[
                    const SizedBox(height: AppSpacing.md),
                    AlertCard(
                      label: 'Low Stock Alerts',
                      value:
                          '$lowStockCount item${lowStockCount == 1 ? '' : 's'}',
                      onTap: () =>
                          Navigator.pushNamed(context, Stock_Screen.id),
                    ),
                  ],
                ],
              );
            },
          ),
          const SizedBox(height: AppSpacing.md),

          // AI-style next-week stock forecast: projects each item's sales
          // velocity over the last 14 days forward 7 days against current
          // stock, so low-stock items surface before they run out.
          StreamBuilder<QuerySnapshot>(
            stream: FirebaseFirestore.instance
                .collection("users/$userId/Stock")
                .snapshots(),
            builder: (context, stockSnapshot) {
              if (!stockSnapshot.hasData) return const SizedBox.shrink();

              final stockByType = <String, double>{
                for (final doc in stockSnapshot.data!.docs)
                  (doc.data() as Map<String, dynamic>)['type'].toString():
                      ((doc.data() as Map<String, dynamic>)['secondNumber']
                                  as num?)
                              ?.toDouble() ??
                          0,
              };

              final historyStart =
                  Timestamp.fromDate(today.subtract(const Duration(days: 13)));

              return StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection("users/$userId/Selling")
                    .where("date", isGreaterThanOrEqualTo: historyStart)
                    .snapshots(),
                builder: (context, sellingSnapshot) {
                  if (!sellingSnapshot.hasData) return const SizedBox.shrink();

                  final soldByType = <String, double>{};
                  for (final doc in sellingSnapshot.data!.docs) {
                    final data = doc.data() as Map<String, dynamic>;
                    final quantity =
                        (data['secondNumber'] as num?)?.toDouble() ?? 0;
                    final type = data['type'].toString();
                    soldByType[type] = (soldByType[type] ?? 0) + quantity;
                  }

                  const historyDays = 14.0;
                  final forecasts = <_StockForecast>[];
                  for (final entry in stockByType.entries) {
                    final dailyVelocity =
                        (soldByType[entry.key] ?? 0) / historyDays;
                    if (dailyVelocity <= 0) continue;
                    final projectedUse = dailyVelocity * 7;
                    forecasts.add(_StockForecast(
                      name: _typeName(int.tryParse(entry.key) ?? entry.key),
                      currentStock: entry.value,
                      projectedUse: projectedUse,
                      projectedRemaining: entry.value - projectedUse,
                    ));
                  }
                  forecasts.sort(
                      (a, b) => a.projectedRemaining.compareTo(b.projectedRemaining));

                  return _AiForecastCard(
                    forecasts: forecasts,
                    lowStockThreshold: _lowStockThreshold,
                    onManageStock: () =>
                        Navigator.pushNamed(context, Stock_Screen.id),
                  );
                },
              );
            },
          ),
          const SizedBox(height: AppSpacing.lg),
        ],
      ),
    );
  }
}

/// A single item's projected stock position seven days out.
class _StockForecast {
  final String name;
  final double currentStock;
  final double projectedUse;
  final double projectedRemaining;

  const _StockForecast({
    required this.name,
    required this.currentStock,
    required this.projectedUse,
    required this.projectedRemaining,
  });
}

/// "Top Products" card: today's items ranked by quantity sold.
class _TopProductsCard extends StatelessWidget {
  final List<MapEntry<String, double>> products;
  final VoidCallback onViewAll;

  const _TopProductsCard({required this.products, required this.onViewAll});

  @override
  Widget build(BuildContext context) {
    return AppCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Expanded(
                  child: Text('Top Products', style: AppTextStyles.headlineMd),
                ),
                TextButton(
                  onPressed: onViewAll,
                  child: const Text('View All'),
                ),
              ],
            ),
          ),
          if (products.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text('No sales yet today', style: AppTextStyles.bodyMd),
            )
          else
            for (int i = 0; i < products.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        products[i].key,
                        style: AppTextStyles.bodyLg
                            .copyWith(fontWeight: FontWeight.w600),
                      ),
                    ),
                    StatusBadge.success(
                      '${_quantityFormat.format(products[i].value)} Sold',
                    ),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}

/// AI-styled "next week" restock forecast, ranked by which items are
/// projected to run lowest first.
class _AiForecastCard extends StatelessWidget {
  final List<_StockForecast> forecasts;
  final double lowStockThreshold;
  final VoidCallback onManageStock;

  static const _maxRows = 4;

  const _AiForecastCard({
    required this.forecasts,
    required this.lowStockThreshold,
    required this.onManageStock,
  });

  StatusBadge _badgeFor(_StockForecast forecast) {
    if (forecast.projectedRemaining <= 0) {
      return StatusBadge.error('Restock now');
    }
    if (forecast.projectedRemaining <= lowStockThreshold) {
      return StatusBadge.warning('Low by next week');
    }
    return StatusBadge.success('On track');
  }

  @override
  Widget build(BuildContext context) {
    final rows = forecasts.take(_maxRows).toList();

    return AppCard(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainer,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                  ),
                  child: const Icon(Icons.auto_awesome,
                      size: 18, color: AppColors.primary),
                ),
                const SizedBox(width: AppSpacing.sm),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Stock Forecast',
                          style: AppTextStyles.headlineMd),
                      Text(
                        'Next 7 days, from the last 14 days of sales',
                        style: AppTextStyles.bodyMd,
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onManageStock,
                  child: const Text('Manage'),
                ),
              ],
            ),
          ),
          if (rows.isEmpty)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 24),
              child: Text(
                'Not enough sales history yet to forecast next week',
                style: AppTextStyles.bodyMd,
              ),
            )
          else
            for (int i = 0; i < rows.length; i++) ...[
              if (i > 0) const Divider(height: 1),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            rows[i].name,
                            style: AppTextStyles.bodyLg
                                .copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            '~${_quantityFormat.format(rows[i].projectedUse)} needed'
                            ' · ${_quantityFormat.format(rows[i].currentStock)} in stock',
                            style: AppTextStyles.bodyMd,
                          ),
                        ],
                      ),
                    ),
                    _badgeFor(rows[i]),
                  ],
                ),
              ),
            ],
        ],
      ),
    );
  }
}
