// import 'package:flutter/material.dart';
// import '../../data/services/auth_service.dart';

// class LoginPage extends StatefulWidget {
//   const LoginPage({super.key});

//   @override
//   State<LoginPage> createState() => _LoginPageState();
// }

// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _emailController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//   final AuthService _authService = AuthService();

//   bool _isLogin = true;
//   bool _isLoading = false;

//   void _toggleForm() {
//     setState(() {
//       _isLogin = !_isLogin;
//     });
//   }

//   void _submit() async {
//     final email = _emailController.text.trim();
//     final password = _passwordController.text.trim();

//     if (email.isEmpty || password.isEmpty) {
//       _showError('Please enter both email and password.');
//       return;
//     }

//     setState(() => _isLoading = true);

//     try {
//       bool success;
//       if (_isLogin) {
//         success = await _authService.login(email, password);
//       } else {
//         success = await _authService.register(email, password);
//       }

//       if (success) {
//         Navigator.pushReplacementNamed(context, '/home');
//       } else {
//         _showError(_isLogin ? 'Login failed' : 'Registration failed');
//       }
//     } catch (e) {
//       _showError('Something went wrong. Please try again.');
//     } finally {
//       setState(() => _isLoading = false);
//     }
//   }

//   void _showError(String msg) {
//     ScaffoldMessenger.of(context).showSnackBar(
//       SnackBar(content: Text(msg), backgroundColor: Colors.red),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: Text(_isLogin ? 'Login' : 'Register')),
//       body: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           children: [
//             TextField(
//               controller: _emailController,
//               decoration: const InputDecoration(labelText: 'Email'),
//               keyboardType: TextInputType.emailAddress,
//             ),
//             TextField(
//               controller: _passwordController,
//               obscureText: true,
//               decoration: const InputDecoration(labelText: 'Password'),
//             ),
//             const SizedBox(height: 20),
//             if (_isLoading)
//               const CircularProgressIndicator()
//             else ...[
//               ElevatedButton(
//                 onPressed: _submit,
//                 child: Text(_isLogin ? 'Login' : 'Register'),
//               ),
//               TextButton(
//                 onPressed: _toggleForm,
//                 child: Text(_isLogin
//                     ? 'Don’t have an account? Register'
//                     : 'Already have an account? Login'),
//               ),
//             ]
//           ],
//         ),
//       ),
//     );
//   }
// }
