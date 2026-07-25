import 'package:flutter/material.dart';
import 'package:pollard/features/billing/day_sales_screen.dart';
import 'package:pollard/features/billing/sales_screen.dart';
import 'package:pollard/features/billing/selling_screen.dart';
import 'package:pollard/features/billing/wallet_screen.dart';
import 'package:pollard/features/dashboard/analytics_screen.dart';
import 'package:pollard/features/dashboard/home_screen.dart';
import 'package:pollard/features/inventory/buying_screen.dart';
import 'package:pollard/features/inventory/stock_screen.dart';
import 'package:pollard/features/profile/profile_screen.dart';
import 'package:pollard/theme/app_theme.dart';
import 'package:pollard/widgets/widgets.dart';

/// Root shell with the bottom navigation bar
/// (Dashboard | Inventory | Billing | More), matching the reference design.
class MainShell extends StatefulWidget {
  static const String id = 'main_shell';
  const MainShell({Key? key}) : super(key: key);

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  int _currentIndex = 0;

  static final List<Widget> _tabs = [
    Home_Screen(),
    Stock_Screen(),
    Selling_Screen(),
    const MoreScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppColors.outlineVariant)),
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          selectedLabelStyle:
              AppTextStyles.labelMd.copyWith(letterSpacing: 0),
          unselectedLabelStyle:
              AppTextStyles.labelMd.copyWith(letterSpacing: 0),
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard_outlined),
              activeIcon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.inventory_2_outlined),
              activeIcon: Icon(Icons.inventory_2),
              label: 'Inventory',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.receipt_long_outlined),
              activeIcon: Icon(Icons.receipt_long),
              label: 'Billing',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.more_horiz),
              label: 'More',
            ),
          ],
        ),
      ),
    );
  }
}

/// "More" tab: links to the remaining screens.
class MoreScreen extends StatelessWidget {
  const MoreScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final items = [
      (Icons.person_outline, 'Profile & Settings', Profile_Screen.id),
      (Icons.assignment_turned_in_outlined, 'Sales Report', SalesScreen.id),
      (Icons.today_outlined, 'Day Sales', Day_Sales_Screen.id),
      (Icons.analytics_outlined, 'Analytics', Analytics_Screen.id),
      (Icons.add_business_outlined, 'Buying', Buying_Screen.id),
      (Icons.account_balance_wallet_outlined, 'Wallet', Wallet_Screen.id),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('More'),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          AppCard(
            child: Column(
              children: [
                for (int i = 0; i < items.length; i++) ...[
                  if (i > 0) const Divider(height: 1),
                  ListTile(
                    leading: Icon(items[i].$1, color: AppColors.primary),
                    title: Text(
                      items[i].$2,
                      style: AppTextStyles.bodyLg
                          .copyWith(fontWeight: FontWeight.w600),
                    ),
                    trailing: const Icon(Icons.chevron_right,
                        color: AppColors.onSurfaceVariant),
                    onTap: () => Navigator.pushNamed(context, items[i].$3),
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
