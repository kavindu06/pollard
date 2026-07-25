import 'dart:math';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

class Analytics_Screen extends StatefulWidget {
  static const String id = 'analytics_screen';

  @override
  State<Analytics_Screen> createState() => _Analytics_ScreenState();
}

class _Analytics_ScreenState extends State<Analytics_Screen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this, initialIndex: 0);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final tomorrow = today.add(const Duration(days: 1));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Analytics'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          children: [
            Container(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: TabBar(
                isScrollable: true,
                indicatorPadding: const EdgeInsets.all(4),
                labelColor: AppColors.onPrimary,
                unselectedLabelColor: AppColors.onSurfaceVariant,
                labelStyle: AppTextStyles.bodyLg.copyWith(fontWeight: FontWeight.w600),
                labelPadding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                indicator: BoxDecoration(
                  color: AppColors.primary,
                  borderRadius: BorderRadius.circular(AppRadius.lg),
                ),
                controller: _tabController,
                tabs: const [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Day'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Week'),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10.0),
                    child: Text('Month'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.md),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _ItemCountAnalytics(
                    periodLabel: 'today',
                    start: today,
                    end: tomorrow,
                  ),
                  _ItemCountAnalytics(
                    periodLabel: 'the last 7 days',
                    start: today.subtract(const Duration(days: 6)),
                    end: tomorrow,
                  ),
                  _ItemCountAnalytics(
                    periodLabel: 'the last 30 days',
                    start: today.subtract(const Duration(days: 29)),
                    end: tomorrow,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quantity sold vs bought for a single item within the selected period.
class _ItemStat {
  final String name;
  final double sold;
  final double bought;

  const _ItemStat({required this.name, required this.sold, required this.bought});
}

/// Fetches Selling + Buying counts per item for [start, end) and renders
/// them as a grouped bar chart (item vs count, sold vs bought).
class _ItemCountAnalytics extends StatelessWidget {
  final String periodLabel;
  final DateTime start;
  final DateTime end;

  const _ItemCountAnalytics({
    required this.periodLabel,
    required this.start,
    required this.end,
  });

  Future<List<_ItemStat>> _load(String userId) async {
    final firestore = FirebaseFirestore.instance;
    final startTs = Timestamp.fromDate(start);
    final endTs = Timestamp.fromDate(end);

    final results = await Future.wait([
      firestore
          .collection("users/$userId/Selling")
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThan: endTs)
          .get(),
      firestore
          .collection("users/$userId/Buying")
          .where('date', isGreaterThanOrEqualTo: startTs)
          .where('date', isLessThan: endTs)
          .get(),
      firestore.collection("users/$userId/Items").get(),
    ]);

    final itemNames = <int, String>{
      for (final doc in results[2].docs)
        (doc['index'] as num).toInt(): doc['name'] as String,
    };

    final sold = _sumByType(results[0].docs);
    final bought = _sumByType(results[1].docs);

    final types = {...sold.keys, ...bought.keys}.toList()..sort();

    return [
      for (final type in types)
        _ItemStat(
          name: itemNames[type] ?? 'Item $type',
          sold: sold[type] ?? 0,
          bought: bought[type] ?? 0,
        ),
    ];
  }

  Map<int, double> _sumByType(List<QueryDocumentSnapshot> docs) {
    final totals = <int, double>{};
    for (final doc in docs) {
      final data = doc.data() as Map<String, dynamic>;
      final type = (data['type'] as num?)?.toInt() ?? 0;
      final quantity = (data['secondNumber'] as num?)?.toDouble() ?? 0;
      totals[type] = (totals[type] ?? 0) + quantity;
    }
    return totals;
  }

  @override
  Widget build(BuildContext context) {
    final userId = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<List<_ItemStat>>(
      future: _load(userId),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}', style: AppTextStyles.bodyLg),
          );
        }
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: AppColors.primary),
          );
        }

        final stats = snapshot.data!;
        if (stats.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              child: Text(
                'No purchases or sales recorded for $periodLabel',
                style: AppTextStyles.bodyMd,
                textAlign: TextAlign.center,
              ),
            ),
          );
        }

        return ListView(
          padding: const EdgeInsets.only(bottom: AppSpacing.lg),
          children: [
            AppCard(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text('Item vs Count', style: AppTextStyles.headlineMd),
                      ),
                      const _LegendDot(color: AppColors.chartBuying, label: 'Bought'),
                      const SizedBox(width: AppSpacing.md),
                      const _LegendDot(color: AppColors.chartSelling, label: 'Sold'),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text('Quantity for $periodLabel', style: AppTextStyles.bodyMd),
                  const SizedBox(height: AppSpacing.lg),
                  SizedBox(
                    height: 260,
                    child: _ItemCountChart(stats: stats),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }
}

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.labelMd),
      ],
    );
  }
}

/// Grouped bar chart: one group per item, one bar for bought and one for sold.
class _ItemCountChart extends StatelessWidget {
  final List<_ItemStat> stats;

  const _ItemCountChart({required this.stats});

  @override
  Widget build(BuildContext context) {
    final maxValue = stats.fold<double>(0, (max, s) {
      final rowMax = s.bought > s.sold ? s.bought : s.sold;
      return rowMax > max ? rowMax : max;
    });
    final interval = _niceInterval(maxValue <= 0 ? 1 : maxValue);

    return BarChart(
      BarChartData(
        minY: 0,
        maxY: (maxValue <= 0 ? 1 : maxValue) + interval,
        alignment: BarChartAlignment.spaceAround,
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          horizontalInterval: interval,
          getDrawingHorizontalLine: (value) => const FlLine(
            color: AppColors.outlineVariant,
            strokeWidth: 1,
          ),
        ),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              interval: interval,
              getTitlesWidget: (value, meta) {
                if (value == 0) return const SizedBox.shrink();
                return Text(_formatCount(value), style: AppTextStyles.labelMd);
              },
            ),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 36,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index < 0 || index >= stats.length) {
                  return const SizedBox.shrink();
                }
                return Padding(
                  padding: const EdgeInsets.only(top: 8),
                  child: SizedBox(
                    width: 56,
                    child: Text(
                      stats[index].name,
                      style: AppTextStyles.labelMd,
                      textAlign: TextAlign.center,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipColor: (_) => AppColors.onSurface,
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              final stat = stats[groupIndex];
              final label = rodIndex == 0 ? 'Bought' : 'Sold';
              return BarTooltipItem(
                '${stat.name}\n$label: ${_formatCount(rod.toY)}',
                AppTextStyles.bodyMd.copyWith(color: Colors.white),
              );
            },
          ),
        ),
        barGroups: [
          for (int i = 0; i < stats.length; i++)
            BarChartGroupData(
              x: i,
              barsSpace: 4,
              barRods: [
                BarChartRodData(
                  toY: stats[i].bought,
                  color: AppColors.chartBuying,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
                BarChartRodData(
                  toY: stats[i].sold,
                  color: AppColors.chartSelling,
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

/// Picks a "clean" grid interval (1/2/5 x 10^n) so axis ticks land on round numbers.
double _niceInterval(double maxValue) {
  if (maxValue <= 4) return 1;

  final magnitude = pow(10, (log(maxValue) / ln10).floor()).toDouble();
  final residual = maxValue / magnitude;

  double niceResidual;
  if (residual <= 1) {
    niceResidual = 1;
  } else if (residual <= 2) {
    niceResidual = 2;
  } else if (residual <= 5) {
    niceResidual = 5;
  } else {
    niceResidual = 10;
  }

  final rawInterval = (niceResidual * magnitude) / 4;
  return rawInterval < 1 ? 1 : rawInterval;
}

String _formatCount(double value) {
  return value == value.roundToDouble()
      ? value.toInt().toString()
      : value.toStringAsFixed(1);
}
