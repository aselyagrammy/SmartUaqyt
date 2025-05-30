import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartuaqyt/data/services/auth_service.dart';
import 'package:smartuaqyt/data/services/connectivity_service.dart';
import 'package:smartuaqyt/data/services/timer_service.dart';
import 'package:smartuaqyt/data/models/timer_entry.dart';
import 'package:smartuaqyt/l10n/generated/app_localizations.dart';
import 'package:smartuaqyt/presentation/screens/login_screen.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String _searchQuery = '';
  String _filterType = 'All';

  List<TimerEntry> _getFilteredEntries(List<TimerEntry> entries) {
    return entries.where((entry) {
      final matchesSearch = entry.name.toLowerCase().contains(
        _searchQuery.toLowerCase(),
      );
      final matchesType =
          _filterType == 'All' || entry.details['type'] == _filterType;
      return matchesSearch && matchesType;
    }).toList();
  }

  @override
  void initState() {
    super.initState();
    // Load timer entries when the page is created
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final auth = context.read<AuthService>();
      if (!auth.isAuth) return;

      final timerService = context.read<TimerService>();
      timerService.loadEntries(auth.currentUserId ?? '');
    });
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final auth = context.watch<AuthService>();
    final connectivity = context.watch<ConnectivityService>();
    final timerService = context.watch<TimerService>();
    final bool isGuest = !auth.isAuth;

    return Scaffold(
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(color: Theme.of(context).primaryColor),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    loc.appTitle,
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                  if (isGuest) ...[
                    const SizedBox(height: 8),
                    const Text(
                      'Welcome, Guest',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 8),
                    ElevatedButton(
                      onPressed:
                          () => Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const LoginScreen(),
                            ),
                          ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: Theme.of(context).primaryColor,
                      ),
                      child: const Text('Sign In'),
                    ),
                  ] else ...[
                    const SizedBox(height: 8),
                    Text(
                      'Welcome, ${auth.currentUserEmail ?? "User"}',
                      style: const TextStyle(
                        color: Colors.white70,
                        fontSize: 16,
                      ),
                    ),
                    if (!connectivity.isOnline) ...[
                      const SizedBox(height: 4),
                      const Text(
                        '(Offline Mode)',
                        style: TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ],
                ],
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: Text(loc.home),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              leading: const Icon(Icons.timer_outlined),
              title: const Text('Timer'),
              onTap: () {
                Navigator.pop(context);
                if (isGuest) {
                  _showSignInPrompt(context);
                } else {
                  Navigator.pushNamed(context, '/timer');
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(loc.about),
              onTap: () => Navigator.pushNamed(context, '/about'),
            ),
            if (!isGuest) ...[
              ListTile(
                leading: const Icon(Icons.person_outline),
                title: const Text('Profile'),
                onTap: () => Navigator.pushNamed(context, '/profile'),
              ),
              ListTile(
                leading: const Icon(Icons.settings),
                title: Text(loc.settingsPageTitle),
                onTap: () => Navigator.pushNamed(context, '/settings'),
              ),
            ],
          ],
        ),
      ),
      appBar: AppBar(
        title: Text(loc.appTitle),
        actions: [
          if (isGuest)
            TextButton.icon(
              icon: const Icon(Icons.login),
              label: const Text('Sign In'),
              style: TextButton.styleFrom(foregroundColor: Colors.white),
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  ),
            )
          else ...[
            if (connectivity.isOnline &&
                timerService.entries.any((e) => !e.isSynced))
              IconButton(
                icon: const Icon(Icons.sync),
                tooltip: 'Sync timings',
                onPressed:
                    timerService.isSyncing
                        ? null
                        : () {
                          timerService.syncData(auth.currentUserId);
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Syncing timings...'),
                              duration: Duration(seconds: 2),
                            ),
                          );
                        },
              ),
            IconButton(
              icon: const Icon(Icons.person_outline),
              onPressed: () => Navigator.pushNamed(context, '/profile'),
            ),
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () => Navigator.pushNamed(context, '/settings'),
            ),
          ],
        ],
      ),
      body: Column(
        children: [
          if (!isGuest && timerService.entries.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  TextField(
                    decoration: const InputDecoration(
                      labelText: 'Search by name',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) => setState(() => _searchQuery = value),
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        FilterChip(
                          label: const Text('All'),
                          selected: _filterType == 'All',
                          onSelected: (selected) {
                            if (selected) setState(() => _filterType = 'All');
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Stopwatch'),
                          selected: _filterType == 'Stopwatch',
                          onSelected: (selected) {
                            if (selected)
                              setState(() => _filterType = 'Stopwatch');
                          },
                        ),
                        const SizedBox(width: 8),
                        FilterChip(
                          label: const Text('Timer'),
                          selected: _filterType == 'Timer',
                          onSelected: (selected) {
                            if (selected) setState(() => _filterType = 'Timer');
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          Expanded(
            child:
                !isGuest && timerService.entries.isNotEmpty
                    ? RefreshIndicator(
                      onRefresh: () async {
                        if (connectivity.isOnline) {
                          await timerService.syncData(auth.currentUserId);
                        }
                      },
                      child: ListView.builder(
                        itemCount:
                            _getFilteredEntries(timerService.entries).length,
                        itemBuilder: (context, index) {
                          final entry =
                              _getFilteredEntries(timerService.entries)[index];
                          final isStopwatch =
                              entry.details['type'] == 'Stopwatch';
                          return ListTile(
                            leading: Icon(
                              isStopwatch ? Icons.timer : Icons.hourglass_empty,
                              color: Theme.of(context).primaryColor,
                            ),
                            title: Text(entry.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(entry.duration),
                                Text(
                                  DateFormat(
                                    'MMM d, y HH:mm',
                                  ).format(entry.timestamp),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                if (!entry.isSynced)
                                  const Icon(
                                    Icons.cloud_off,
                                    size: 16,
                                    color: Colors.orange,
                                  )
                                else
                                  const Icon(
                                    Icons.cloud_done,
                                    size: 16,
                                    color: Colors.green,
                                  ),
                                const SizedBox(width: 8),
                                Text(
                                  entry.isSynced ? 'Synced' : 'Local',
                                  style: TextStyle(
                                    color:
                                        entry.isSynced
                                            ? Colors.green
                                            : Colors.orange,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    )
                    : Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.timer_outlined,
                            size: 64,
                            color: Colors.grey,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            isGuest
                                ? 'Sign in to save and sync your timings'
                                : 'No timings recorded yet',
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            icon: Icon(isGuest ? Icons.login : Icons.timer),
                            label: Text(isGuest ? 'Sign In' : 'Start Timer'),
                            onPressed: () {
                              if (isGuest) {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const LoginScreen(),
                                  ),
                                );
                              } else {
                                Navigator.pushNamed(context, '/timer');
                              }
                            },
                          ),
                        ],
                      ),
                    ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        heroTag: 'home_timer_fab',
        onPressed: () {
          if (isGuest) {
            _showSignInPrompt(context);
          } else {
            Navigator.pushNamed(context, '/timer');
          }
        },
        child: const Icon(Icons.timer),
      ),
    );
  }

  void _showSignInPrompt(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Sign In Required'),
            content: const Text(
              'Please sign in to use the timer and save your timings.',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginScreen()),
                  );
                },
                child: const Text('Sign In'),
              ),
            ],
          ),
    );
  }
}
