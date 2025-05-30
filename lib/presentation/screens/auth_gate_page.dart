import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartuaqyt/data/services/auth_service.dart';
import 'package:smartuaqyt/presentation/screens/home_page.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    return const HomePage();
  }
}
