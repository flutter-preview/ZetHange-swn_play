import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:swn_play/api/repository/auth_repository.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _isLoading = false;

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    if (_formKey.currentState!.validate()) {
      final String token =
          await login(_emailController.text, _passwordController.text);
      debugPrint("token: $token");
      if (token == "Неправильная почта или пароль") {
        setState(() {
          _isLoading = false;
        });
      } else {
        final prefs = await SharedPreferences.getInstance();
        prefs.setBool('isLoggedIn', true);
        prefs.setString("token", token);

        Navigator.popUntil(context, ModalRoute.withName('SettingsScreen'));
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Вход в SWN Play'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                ),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Введите email';
                  }
                  if (!RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$')
                      .hasMatch(value)) {
                    return 'Введите корректный email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Пароль',
                ),
                obscureText: true,
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Введите пароль';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: _isLoading ? null : _login,
                child: _isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Войти'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
