import 'package:flutter/material.dart';
import '../constant.dart';

class NumericTextField extends StatelessWidget {
 


 
  final number = TextEditingController();

  NumericTextField(number);
 
  @override
  Widget build(BuildContext context) {
    return TextField(
                  controller: number,
                  autocorrect: true,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(hintText: 'Ekak'),
                  style: kNumberTextStyle,
                );
              

            
        
  
  }
}

