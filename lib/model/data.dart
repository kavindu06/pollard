import 'package:flutter/foundation.dart';
import 'package:pollard/components/numeric_text_field.dart';


class Data extends ChangeNotifier{
  int number = 10;

  void changeNumber(int newNumber){
    number=newNumber;
    notifyListeners();

  }

}