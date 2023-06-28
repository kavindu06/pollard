import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:convert';

class Analytics_Screen extends StatefulWidget {
  static const String id = 'analytics_screen';

  @override
  State<Analytics_Screen> createState() => _Analytics_ScreenState();
}

class _Analytics_ScreenState extends State<Analytics_Screen>
    with SingleTickerProviderStateMixin {
  final colorstheme = Color(0xff4b4b87);
  late TabController _tabController;

  @override
  void initState() {
    _tabController = new TabController(length: 3, vsync: this, initialIndex: 0)
      ..addListener(() {});
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Analytics',
        ),
        backgroundColor: const Color(0xFF0A0E21),
        centerTitle: true,
        shadowColor: Colors.transparent,
        leading: Padding(
          padding: const EdgeInsets.only(left: 15.0),
          child: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: colorstheme,
              size: 30,
            ),
            onPressed: () {},
          ),
        ),
      ),
      body: Column(
        children: [
          Container(
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Colors.grey[300]),
            child: TabBar(
                isScrollable: true,
                indicatorPadding: EdgeInsets.all(10),
                labelColor: Colors.white,
                unselectedLabelColor: colorstheme,
                labelStyle: TextStyle(fontSize: 20),
                labelPadding:
                    EdgeInsets.only(left: 35, right: 35, top: 10, bottom: 10),
                indicator: BoxDecoration(
                    color: colorstheme,
                    borderRadius: BorderRadius.circular(20)),
                controller: _tabController,
                tabs: [
                  Text('Day'),
                  Text('Week'),
                  Text('Month'),
                ]),
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [const Text("data")],
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.lightBlueAccent,
            ),
            onPressed: () {
              readData();
            },
            child: const Text('Read'),
          ),
        ],
      ),
    );
  }
}

readData() async {
  CollectionReference newCollection =
      FirebaseFirestore.instance.collection("Selling");
  QuerySnapshot snapshot =
      await newCollection.where('type', isEqualTo: 0).get();

  int totalCoconut = 0;

  for (QueryDocumentSnapshot docSnapshot in snapshot.docs) {
    Map<String, Object?>? types = docSnapshot.data() as Map<String, Object?>?;
    int? coconut = types?['secondNumber'] as int?;
    if (coconut != null) {
      totalCoconut += coconut;
    }
  }
  print("Total coconut: $totalCoconut");
}
