import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService _authService = AuthService();

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.indigo.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.white,
                child: Icon(Icons.check_circle, size: 60, color: Colors.indigo),
              ),
              const SizedBox(height: 30),
              Text(
                "Katomaran To-Do",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.indigo.shade700,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Sign in to manage your tasks",
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              const SizedBox(height: 50),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.login),
                  label: const Text(
                    "Sign in with Google",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black87,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: const BorderSide(color: Colors.grey),
                    ),
                    elevation: 3,
                  ),
                  onPressed: () async {
                    final user = await _authService.signInWithGoogle();
                    if (user != null) {
                      Navigator.pushReplacementNamed(
                        context,
                        '/home',
                        arguments: user,
                      );
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Login failed. Please try again.")),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
