import 'package:flutter/material.dart';

class HomeProvider extends ChangeNotifier {
  bool _isLoading = false;

  bool get isLoading => _isLoading;

  setIsLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }
}
