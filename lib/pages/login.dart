import 'dart:convert';
import 'package:connectfront/pages/register.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isShowPassword = false;

  void _togglePasswordView() {
    setState(() {
      _isShowPassword = !_isShowPassword;
    });
  }

  @override
  Widget build(BuildContext context) {
    var espace = SizedBox(height: 16.0);

    final String apiUrl = "http://10.0.2.2:8000/api/auth/login";

    Future<void> LoginUser(BuildContext context) async {
      final response = await http.post(Uri.parse(apiUrl),
        headers: {'content-type': 'application/json'},
        body: jsonEncode({
          'email': _emailController.text,
          'password': _passwordController.text,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        print("Response:${response.body}");
        final token = data['token'] ?? "";
        final user = data['user'];

        final localStorage = await SharedPreferences.getInstance();
        await localStorage.setString('token', token);
        await localStorage.setString('user', jsonEncode(user));

        if (kDebugMode) {
          print("token:$token");
        }

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.green,
            content: Text(
              'Connexion réussie',
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
        Navigator.pushReplacementNamed(
          context,
          '/home',
          arguments: {'token': token, 'user': user},
        );
      } else {
        final errorData = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: Colors.red,
            content: Text(
              errorData['message'],
              style: TextStyle(color: Colors.white),
            ),
          ),
        );
      }
    }

    return Scaffold(
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            // mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(height: 60.0),
              const Text(
                'Login',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
          
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.email,size: 20,),
                  labelText: 'Email'
                  ),
              ),
              espace,
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  return null;
                },
                controller: _passwordController,
                obscureText: !_isShowPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock,size: 20,),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _isShowPassword ? Icons.visibility_off : Icons.visibility,
                      size: 20,
                    ),
                    onPressed: _togglePasswordView,
                  ),
                ),
              ),
              espace,
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      LoginUser(context);
                    }
                  },
                  child: const Text('Login'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
