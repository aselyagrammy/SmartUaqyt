import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:smartuaqyt/data/services/auth_service.dart';
import 'package:smartuaqyt/data/services/prefs_service.dart';
import 'package:smartuaqyt/data/services/storage_service.dart';
import 'package:smartuaqyt/data/services/connectivity_service.dart';
import 'package:smartuaqyt/data/services/timer_service.dart';
import 'package:smartuaqyt/l10n/generated/app_localizations.dart';
import 'package:smartuaqyt/presentation/screens/login_screen.dart';
import 'package:smartuaqyt/presentation/widgets/offline_banner.dart';

import 'package:smartuaqyt/presentation/screens/auth_gate_page.dart';
import 'package:smartuaqyt/presentation/screens/home_page.dart';
import 'package:smartuaqyt/presentation/screens/about_page.dart';
import 'package:smartuaqyt/presentation/screens/interactive_page.dart';
import 'package:smartuaqyt/presentation/screens/settings_page.dart';
import 'package:smartuaqyt/presentation/screens/profile_page.dart';
import 'package:smartuaqyt/presentation/screens/timer_page.dart';

import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize local storage first
  final storage = StorageService();
  await storage.init().catchError((e) {
    debugPrint('Failed to initialize storage: $e');
  });

  // Initialize Firebase if online
  try {
    await Firebase.initializeApp();
  } catch (e) {
    debugPrint('Failed to initialize Firebase: $e');
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ConnectivityService()),
        ChangeNotifierProvider(create: (_) => storage),
        ChangeNotifierProvider(
          create:
              (context) => TimerService(
                context.read<StorageService>(),
                context.read<ConnectivityService>(),
              ),
        ),
        ChangeNotifierProvider(
          create:
              (context) => AuthService(
                context.read<StorageService>(),
                context.read<TimerService>(),
              ),
        ),
        ChangeNotifierProxyProvider<AuthService, PrefsService>(
          create: (_) => PrefsService(),
          update: (_, auth, prefs) {
            prefs!.attach(auth.user);
            return prefs;
          },
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final prefs = context.watch<PrefsService>();
    final auth = context.watch<AuthService>();
    final connectivity = context.watch<ConnectivityService>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: prefs.themeMode,
      locale: Locale(prefs.lang),
      supportedLocales: const [Locale('en'), Locale('ru'), Locale('kk')],
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      builder: (context, child) {
        return Column(
          children: [
            Expanded(
              child: Scaffold(
                body: child,
                // Show offline banner when not connected
                bottomNavigationBar:
                    !connectivity.isOnline ? const OfflineBanner() : null,
              ),
            ),
          ],
        );
      },
      home: const AuthGate(),
      onGenerateRoute: (settings) {
        // List of routes that require authentication
        const protectedRoutes = ['/timer', '/profile', '/settings'];

        // Check if route requires auth and user is not authenticated
        if (protectedRoutes.contains(settings.name) && !auth.isAuth) {
          return MaterialPageRoute(
            builder:
                (context) => Scaffold(
                  appBar: AppBar(title: const Text('Access Denied')),
                  body: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.lock_outline,
                          size: 64,
                          color: Colors.red,
                        ),
                        const SizedBox(height: 16),
                        const Text(
                          'Please log in to access this feature',
                          style: TextStyle(fontSize: 18),
                        ),
                        const SizedBox(height: 24),
                        ElevatedButton(
                          onPressed:
                              () => Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const LoginScreen(),
                                ),
                              ),
                          child: const Text('Login / Register'),
                        ),
                      ],
                    ),
                  ),
                ),
          );
        }

        // Regular route handling
        switch (settings.name) {
          case '/home':
            return MaterialPageRoute(builder: (_) => const HomePage());
          case '/about':
            return MaterialPageRoute(builder: (_) => const AboutPage());
          case '/interactive':
            return MaterialPageRoute(builder: (_) => InteractivePage());
          case '/timer':
            return MaterialPageRoute(builder: (_) => TimerPage());
          case '/profile':
            return MaterialPageRoute(builder: (_) => const ProfilePage());
          case '/settings':
            return MaterialPageRoute(builder: (_) => const SettingsPage());
          default:
            return null;
        }
      },
    );
  }
}
