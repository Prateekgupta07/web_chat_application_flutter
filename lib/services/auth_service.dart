import 'package:hive/hive.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';
import '../models/user.dart';

class AuthService {
  final Box<User> userBox;

  AuthService(this.userBox);

  Future<bool> signUp(String username, String password) async {
    if (userBox.values.any((user) => user.username == username)) {
      return false; // User already exists
    }
    final user = User(username: username, password: password);
    await userBox.add(user);
    return true;
  }

  Future<User?> login(String username, String password) async {
    try {
      final user = userBox.values.firstWhere(
            (user) => user.username == username && user.password == password,
      );
      return user;
    } catch (e) {
      Fluttertoast.showToast(
        msg: "User not found or incorrect password",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0,
      );
      return null;
    }
  }

  Future<void> logout() async {
    // Handle logout if necessary (e.g., clear session data)
  }
}
