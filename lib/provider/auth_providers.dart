import 'package:flutter/material.dart';
import 'package:todo_app/model/my_user.dart';

class AuthProviders extends ChangeNotifier {
  MyUser? currentUser;

  void setCurrentUser(MyUser? user) {
    currentUser = user;
    notifyListeners();
  }
}
