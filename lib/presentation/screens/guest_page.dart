import 'package:flutter/material.dart';
import 'package:smartuaqyt/presentation/screens/login_screen.dart';

class GuestPage extends StatelessWidget {
  const GuestPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Guest Mode')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 80),
            const SizedBox(height: 16),
            const Text('You are in guest mode', style: TextStyle(fontSize: 18)),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
              child: const Text('Login / Register'),
            ),
          ],
        ),
      ),
    );
  }
}
