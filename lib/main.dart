import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:pollard/screens/analytics_screen.dart';
import 'package:pollard/screens/buying_screen.dart';
import 'package:pollard/screens/day_sales_screen.dart';
import 'package:pollard/screens/home_screen.dart';
import 'package:pollard/screens/inventory_screen.dart';
import 'package:pollard/screens/login_screen.dart';
import 'package:pollard/screens/registration_screen.dart';
import 'package:pollard/screens/sales_screen.dart';
import 'package:pollard/screens/wallet_screen.dart';

import 'package:pollard/screens/welcome_screen.dart';
import 'screens/selling_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark().copyWith(
        primaryColor: Color(0xFF0A0E21),
        scaffoldBackgroundColor: Color(0xFF0A0E21),
        colorScheme:
            ColorScheme.fromSwatch().copyWith(secondary: Colors.purple),
      ),
      initialRoute: Welcome_Screen.id,
      routes: {
        Selling_Screen.id: (context) => Selling_Screen(),
        Buying_Screen.id: (context) => Buying_Screen(),
        Welcome_Screen.id: (context) => Welcome_Screen(),
        Login_Screen.id: (context) => Login_Screen(),
        Registration_Screen.id: (context) => Registration_Screen(),
        Day_Sales_Screen.id: (context) => Day_Sales_Screen(),
        Home_Screen.id: (context) => Home_Screen(),
        SalesScreen.id: (context) => SalesScreen(),
        Analytics_Screen.id: (context) => Analytics_Screen(),
        Inventory_Screen.id:(context) => Inventory_Screen(),
        Wallet_Screen.id:(context) => Wallet_Screen(),
      },
    );
  }
}
