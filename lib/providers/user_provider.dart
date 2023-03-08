import 'package:autograph/resources/auth_methods.dart';
import 'package:autograph/models/user.dart';
import 'package:flutter/widgets.dart';

class UserProvider with ChangeNotifier {
  User? auser;
  final AuthMethods authMethods = AuthMethods();

  User get getUser => auser!;

  Future<void> refreshUser() async {
    User user = await authMethods.getUserDetails();
    auser = user;
    notifyListeners();
  }
}