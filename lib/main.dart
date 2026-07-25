import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollard/features/dashboard/analytics_screen.dart';
import 'package:pollard/features/inventory/buying_screen.dart';
import 'package:pollard/features/billing/day_sales_screen.dart';
import 'package:pollard/features/dashboard/home_screen.dart';
import 'package:pollard/features/inventory/stock_screen.dart';
import 'package:pollard/features/auth/login_screen.dart';
import 'package:pollard/features/auth/registration_screen.dart';
import 'package:pollard/features/billing/sales_screen.dart';
import 'package:pollard/features/billing/wallet_screen.dart';
import 'package:pollard/theme/app_theme.dart';

import 'package:pollard/features/auth/welcome_screen.dart';
import 'package:pollard/features/shell/main_shell.dart';
import 'package:pollard/features/profile/profile_screen.dart';
import 'package:pollard/features/billing/selling_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: Welcome_Screen.id,
      routes: {
        MainShell.id: (context) => const MainShell(),
        Profile_Screen.id: (context) => const Profile_Screen(),
        Selling_Screen.id: (context) => Selling_Screen(),
        Buying_Screen.id: (context) => Buying_Screen(),
        Welcome_Screen.id: (context) => Welcome_Screen(),
        Login_Screen.id: (context) => Login_Screen(),
        Registration_Screen.id: (context) => Registration_Screen(),
        Day_Sales_Screen.id: (context) => Day_Sales_Screen(),
        Home_Screen.id: (context) => Home_Screen(),
        SalesScreen.id: (context) => SalesScreen(),
        Analytics_Screen.id: (context) => Analytics_Screen(),
        Stock_Screen.id: (context) => Stock_Screen(),
        Wallet_Screen.id: (context) => Wallet_Screen(),
      },
    );
  }
}
