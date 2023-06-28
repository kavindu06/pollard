import 'package:flutter/material.dart';
import '../constant.dart';

class BottomButton extends StatelessWidget {
  BottomButton({required this.onTap, required this.bottomText});

  final Function() onTap;
  final String bottomText;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        child: Center(
          child: Text(
            bottomText,
            style: kLargeTextStyle,
          ),
        ),
        color: kBottomContainerColor,
        margin: EdgeInsets.only(top: 10.0),
        width: double.infinity,
        height: kBottomContainerHeight,
      ),
    );
  }
}
