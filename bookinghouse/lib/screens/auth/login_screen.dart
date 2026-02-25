import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/user_provider.dart';
import '../../widgets/custom_button.dart'; // We will create this
import 'register_screen.dart';
import '../tenant/home_screen.dart';
import '../admin/admin_home_screen.dart'; // Admin Screen
import '../host/host_home_screen.dart'; // Host Screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  void _login() async {
    if (_formKey.currentState!.validate()) {
      try {
        await Provider.of<UserProvider>(context, listen: false).login(
          _emailController.text,
          _passwordController.text,
        );
        if (mounted) {
          final userRole = Provider.of<UserProvider>(context, listen: false).user?.roleId;
          
          if (userRole == 1) {
            // Admin
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const AdminHomeScreen()),
            );
          } else {
            // User (Role 2) or others
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
            );
          }
        }
      } catch (e) {
        print("LOGIN ERROR CHI TIET: $e"); // In lỗi ra Terminal
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Lỗi đăng nhập: $e')),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'Booking House',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 32),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) => value!.isEmpty ? 'Please enter email' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) => value!.isEmpty ? 'Please enter password' : null,
              ),
              const SizedBox(height: 24),
              Consumer<UserProvider>(
                builder: (context, userProvider, child) {
                  return userProvider.isLoading
                      ? const CircularProgressIndicator()
                      : CustomButton(
                          onPressed: _login,
                          text: 'Login',
                        );
                },
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const RegisterScreen()),
                  );
                },
                child: const Text('Don\'t have an account? Register'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
