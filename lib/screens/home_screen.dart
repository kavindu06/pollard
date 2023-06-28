import 'package:flutter/material.dart';
import 'package:pollard/screens/analytics_screen.dart';
import 'package:pollard/screens/buying_screen.dart';
import 'package:pollard/screens/selling_screen.dart';
import 'package:pollard/screens/login_screen.dart';
import 'package:pollard/screens/registration_screen.dart';
import 'package:pollard/screens/sales_screen.dart';
import 'package:pollard/screens/wallet_screen.dart';
import 'package:pollard/screens/welcome_screen.dart';

import 'inventory_screen.dart';

class Home_Screen extends StatefulWidget {
  static const String id = 'home_screen';

  @override
  State<Home_Screen> createState() => _Home_ScreenState();
}

class _Home_ScreenState extends State<Home_Screen>
    with SingleTickerProviderStateMixin {
  final colorstheme = Color(0xff4b4b87);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Home"),
        backgroundColor: const Color(0xFF0A0E21),
        leading: const Icon(Icons.home),
      ),
      body: Container(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          // ignore: sort_child_properties_last
          child: GridView(
            scrollDirection: Axis.vertical,
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Selling_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffff6968),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.sell,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Selling",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Buying_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff7a54ff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.add_business,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Buying",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, SalesScreen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffff8f61),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.assignment_turned_in,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Sales",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Analytics_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff2ac3ff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.analytics_sharp,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Analytics",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Inventory_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff5a65ff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.inventory_2,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Inventory",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Wallet_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff96da45),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.wallet_rounded,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Wallet",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  // Navigator.pushNamed(context, MultiplicationScreen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xffff6968),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.commute,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Transpot",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, Welcome_Screen.id);
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Color(0xff7a54ff),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.delete_sweep_outlined,
                        size: 50,
                        color: Colors.white,
                      ),
                      Text(
                        "Wastage",
                        style: TextStyle(color: Colors.white, fontSize: 30),
                      )
                    ],
                  ),
                ),
              ),
            ],
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2, mainAxisSpacing: 10, crossAxisSpacing: 10),
          ),
        ),
      ),
    );
  }
}
