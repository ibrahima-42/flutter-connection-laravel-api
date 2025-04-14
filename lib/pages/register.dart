import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Register extends StatefulWidget {
  const Register({super.key});

  @override
  State<Register> createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();

  bool _showPassword = false;
  bool _showPasswordConfirmation = false;

  Future<void> register(BuildContext context) async {
    final String apiUrl = "http://10.0.2.2:8000/api/auth/register";

    final response = await http.post(
      Uri.parse(apiUrl),
      headers: {'content-type': 'application/json'},
      body: jsonEncode({
        'name': _nameController.text,
        'email': _emailController.text,
        'password': _passwordController.text,
        'password_confirmation': _passwordConfirmationController.text,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final data = jsonDecode(response.body);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Inscription réussie 🎉")),
      );
      print(data);
    } else {
  final error = jsonDecode(response.body);

  if (error['message'] != null) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(error['message'])),
    );
  } else if (error['errors'] != null) {
    final firstError = error['errors'].values.first[0];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(firstError)),
    );
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Erreur inconnue')),
    );
  }
}
  }

  void _togglePasswordView() {
    setState(() {
      _showPassword = !_showPassword;
    });
  }

  void _togglePasswordConfirmationView() {
    setState(() {
      _showPasswordConfirmation = !_showPasswordConfirmation;
    });
  }

  @override
  Widget build(BuildContext context) {
    var espace = const SizedBox(height: 10);
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              const Text(
                'Register',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'name'),
              ),
              espace,
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Email is required';
                  }
                  return null;
                },
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
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
                obscureText: !_showPassword,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPassword ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordView,
                  ),
                ),
              ),
              espace,
              TextFormField(
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password confirmation is required';
                  }
                  return null;
                },
                controller: _passwordConfirmationController,
                obscureText: !_showPasswordConfirmation,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      _showPasswordConfirmation ? Icons.visibility_off : Icons.visibility,
                    ),
                    onPressed: _togglePasswordConfirmationView,
                  ),
                ),
              ),
              espace,
              ElevatedButton(
                onPressed: (){
                  if(_formKey.currentState!.validate()){
                    register(context);
                  }
                },
                child: const Text('Register'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: const Text('Already have an account? Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
