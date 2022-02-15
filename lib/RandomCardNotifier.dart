import 'package:flutter/material.dart';

class RandomCardNotifier extends ChangeNotifier {

  bool shouldSelectRandom = false;

  void selectAtRandom(){
    shouldSelectRandom = true;
    notifyListeners();
  }
}