import 'package:flutter/material.dart';

class CoinWalletProvider extends ChangeNotifier {
  int _balance = 1000; // Başlanğıc balans

  int get balance => _balance;

  void updateBalance(int reward) {
    _balance += reward;
    notifyListeners();
  }

  void setBalance(int newBalance) {
    _balance = newBalance;
    notifyListeners();
  }
}
