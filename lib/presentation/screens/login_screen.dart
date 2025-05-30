import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartuaqyt/data/services/auth_service.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _email = TextEditingController();
  final _pass = TextEditingController();
  bool _isLogin = true;
  bool _isLoading = false;
  String? _errorMessage;

  void _showError(String message) {
    setState(() => _errorMessage = message);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 3),
      ),
    );
  }

  Future<void> _handleSubmit() async {
    // Input validation
    if (_email.text.trim().isEmpty || _pass.text.trim().isEmpty) {
      _showError('Please fill in all fields');
      return;
    }

    if (!_email.text.contains('@')) {
      _showError('Please enter a valid email address');
      return;
    }

    if (_pass.text.length < 6) {
      _showError('Password must be at least 6 characters long');
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final auth = context.read<AuthService>();
      if (_isLogin) {
        await auth.login(_email.text.trim(), _pass.text);
      } else {
        await auth.register(_email.text.trim(), _pass.text);
      }
      if (mounted) {
        Navigator.pop(context);
      }
    } on FirebaseAuthException catch (e) {
      String message = 'An error occurred';
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found with this email';
          break;
        case 'wrong-password':
          message = 'Wrong password';
          break;
        case 'email-already-in-use':
          message = 'Email is already registered';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'This account has been disabled';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Please try again later';
          break;
      }
      _showError(message);
    } catch (e) {
      _showError('An unexpected error occurred');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              controller: _email,
              decoration: InputDecoration(
                labelText: 'Email',
                errorText: _errorMessage,
                prefixIcon: const Icon(Icons.email),
              ),
              keyboardType: TextInputType.emailAddress,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pass,
              decoration: InputDecoration(
                labelText: 'Password',
                prefixIcon: const Icon(Icons.lock),
              ),
              obscureText: true,
              enabled: !_isLoading,
            ),
            const SizedBox(height: 24),
            if (_isLoading)
              const Center(child: CircularProgressIndicator())
            else
              ElevatedButton(
                onPressed: _handleSubmit,
                child: Text(_isLogin ? 'Login' : 'Register'),
              ),
            TextButton(
              onPressed:
                  _isLoading
                      ? null
                      : () => setState(() => _isLogin = !_isLogin),
              child: Text(
                _isLogin
                    ? 'Need an account? Register'
                    : 'Have an account? Login',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
