import 'package:pollard/screens/login_screen.dart';
import 'package:flutter/foundation.dart';
import 'registration_screen.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class Welcome_Screen extends StatefulWidget {
  static const String id = 'welcome_screen';
  @override
  _Welcome_ScreenState createState() => _Welcome_ScreenState();
}

class _Welcome_ScreenState extends State<Welcome_Screen> with SingleTickerProviderStateMixin {

  late AnimationController controller;
  @override
  void initState() {
    super.initState();
    controller = AnimationController(duration: const Duration(seconds: 2), vsync: this, upperBound: 100.0);
      controller.addListener(() {
        setState(() {});
        });
    controller.forward();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              children: <Widget>[
                Hero(
                  tag:'logo',
                  child: Container(
                     child: Image.asset('images/logo.png'),
                    height: controller.value,
                  ),
                ),
                DefaultTextStyle(
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 45.0,
                    fontWeight: FontWeight.w900,
                  ),
                  child: AnimatedTextKit (
                    animatedTexts:[TypewriterAnimatedText('POLLARD')],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 48.0,
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                elevation: 5.0,
                color: Colors.lightBlueAccent,
                borderRadius: BorderRadius.circular(30.0),
                child: MaterialButton(
                  onPressed: () {
                    //Go to login screen.
                    Navigator.pushNamed(context, Login_Screen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Log In',
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(vertical: 16.0),
              child: Material(
                color: Colors.blueAccent,
                borderRadius: BorderRadius.circular(30.0),
                elevation: 5.0,
                child: MaterialButton(
                  onPressed: () {
                    //Go to registration screen.
                    Navigator.pushNamed(context, Registration_Screen.id);
                  },
                  minWidth: 200.0,
                  height: 42.0,
                  child: Text(
                    'Register',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
