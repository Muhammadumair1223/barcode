import 'package:flutter/material.dart';

import '../repository/auth_repository.dart';

class AuthController extends ChangeNotifier {
  final userNameController = TextEditingController(text: "3176994381");
  final passwordController = TextEditingController(text: "12345678");

  final formKey = GlobalKey<FormState>();

  final AuthRepository _repository;

  AuthController(this._repository);

  bool isLoading = false;

  Future<void> login(context) async {
    String userName = userNameController.text;
    String password = passwordController.text;

    if (userName.isEmpty || password.isEmpty) {
      showErrorDialog(context, 'Please input data');
    } else {
      isLoading = true;
      notifyListeners();

      try {
        await _repository.login(userName, password);

        Navigator.pushReplacementNamed(context, '/checkprice');
      } catch (error) {
        showErrorDialog(context, 'UserName or Password error!!.');
      }

      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> showErrorDialog(context, String message) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Info'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> logout(context) async {
    await _repository.logout(context);
  }

  bool isLogged() {
    return _repository.isLogged();
  }

  @override
  void dispose() {
    userNameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
