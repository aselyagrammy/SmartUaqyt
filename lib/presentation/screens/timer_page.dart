import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:smartuaqyt/data/services/auth_service.dart';
import 'package:smartuaqyt/data/services/timer_service.dart';

enum TimerMode { stopwatch, countdown }

class TimerPage extends StatefulWidget {
  const TimerPage({super.key});

  @override
  State<TimerPage> createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> {
  Timer? _timer;
  int _centiseconds = 0;
  int _initialSeconds = 0;
  int _remainingSeconds = 0;
  bool _isRunning = false;
  TimerMode _mode = TimerMode.stopwatch;
  DateTime? _startTime;
  DateTime? _endTime;
  final TextEditingController _nameController = TextEditingController();

  @override
  void dispose() {
    _timer?.cancel();
    _nameController.dispose();
    super.dispose();
  }

  void _startTimer() {
    _startTime = DateTime.now();
    if (_mode == TimerMode.stopwatch) {
      _timer = Timer.periodic(const Duration(milliseconds: 10), (timer) {
        setState(() {
          _centiseconds++;
        });
      });
    } else {
      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_remainingSeconds > 0) {
            _remainingSeconds--;
          } else {
            _stopTimer();
          }
        });
      });
    }
    setState(() {
      _isRunning = true;
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    _endTime = DateTime.now();
    setState(() {
      _isRunning = false;
    });
  }

  Future<void> _saveTime() async {
    if (_nameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a name for your timing'),
          duration: Duration(seconds: 2),
        ),
      );
      return;
    }

    final auth = context.read<AuthService>();
    if (!auth.isAuth) return;

    final timerService = context.read<TimerService>();
    String duration;
    String type;

    if (_mode == TimerMode.stopwatch) {
      duration = _formatStopwatchTime(_centiseconds);
      type = 'Stopwatch';
    } else {
      duration = _formatCountdownTime(_initialSeconds - _remainingSeconds);
      type = 'Timer';
    }

    final startTime = _startTime?.toIso8601String() ?? '';
    final endTime = _endTime?.toIso8601String() ?? '';
    final details = {
      'type': type,
      'startTime': startTime,
      'endTime': endTime,
      'initialDuration':
          _mode == TimerMode.countdown
              ? _formatCountdownTime(_initialSeconds)
              : '00:00:00',
    };

    await timerService.addEntry(
      auth.currentUserId ?? '',
      _nameController.text,
      duration,
      details,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Time saved successfully'),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  void _resetTimer() {
    _timer?.cancel();
    setState(() {
      if (_mode == TimerMode.stopwatch) {
        _centiseconds = 0;
      } else {
        _remainingSeconds = _initialSeconds;
      }
      _isRunning = false;
      _startTime = null;
      _endTime = null;
    });
  }

  Future<void> _pickTime() async {
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: _initialSeconds ~/ 3600,
        minute: (_initialSeconds % 3600) ~/ 60,
      ),
    );

    if (picked != null) {
      setState(() {
        _initialSeconds = picked.hour * 3600 + picked.minute * 60;
        _remainingSeconds = _initialSeconds;
      });
    }
  }

  String _formatStopwatchTime(int centiseconds) {
    final minutes = (centiseconds ~/ 6000).toString().padLeft(2, '0');
    final seconds = ((centiseconds % 6000) ~/ 100).toString().padLeft(2, '0');
    final cs = (centiseconds % 100).toString().padLeft(2, '0');
    return '$minutes:$seconds.$cs';
  }

  String _formatCountdownTime(int seconds) {
    final hours = (seconds ~/ 3600).toString().padLeft(2, '0');
    final minutes = ((seconds % 3600) ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$hours:$minutes:$secs';
  }

  @override
  Widget build(BuildContext context) {
    final String displayTime =
        _mode == TimerMode.stopwatch
            ? _formatStopwatchTime(_centiseconds)
            : _formatCountdownTime(_remainingSeconds);

    return Scaffold(
      appBar: AppBar(
        title: Text(_mode == TimerMode.stopwatch ? 'Stopwatch' : 'Timer'),
        actions: [
          IconButton(
            icon: Icon(
              _mode == TimerMode.stopwatch
                  ? Icons.timer
                  : Icons.hourglass_empty,
            ),
            onPressed: () {
              setState(() {
                _mode =
                    _mode == TimerMode.stopwatch
                        ? TimerMode.countdown
                        : TimerMode.stopwatch;
                _resetTimer();
              });
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText:
                      'Name your ${_mode == TimerMode.stopwatch ? "stopwatch" : "timer"}',
                  border: const OutlineInputBorder(),
                  prefixIcon: Icon(
                    _mode == TimerMode.stopwatch
                        ? Icons.timer
                        : Icons.hourglass_empty,
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                _mode == TimerMode.stopwatch ? 'Stopwatch' : 'Timer',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              const SizedBox(height: 16),
              Text(
                displayTime,
                style: const TextStyle(
                  fontSize: 60,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold,
                ),
              ),
              if (_mode == TimerMode.countdown && !_isRunning) ...[
                const SizedBox(height: 16),
                ElevatedButton.icon(
                  onPressed: _pickTime,
                  icon: const Icon(Icons.access_time),
                  label: const Text('Set Time'),
                ),
              ],
              const SizedBox(height: 32),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  FloatingActionButton(
                    heroTag: 'timer_start_stop_fab',
                    onPressed:
                        _mode == TimerMode.countdown &&
                                _remainingSeconds == 0 &&
                                !_isRunning
                            ? null
                            : _isRunning
                            ? _stopTimer
                            : _startTimer,
                    child: Icon(_isRunning ? Icons.pause : Icons.play_arrow),
                  ),
                  const SizedBox(width: 16),
                  FloatingActionButton(
                    heroTag: 'timer_reset_fab',
                    onPressed:
                        (_mode == TimerMode.stopwatch && _centiseconds > 0) ||
                                (_mode == TimerMode.countdown &&
                                    _remainingSeconds < _initialSeconds)
                            ? _resetTimer
                            : null,
                    child: const Icon(Icons.refresh),
                  ),
                  if (!_isRunning &&
                      ((_mode == TimerMode.stopwatch && _centiseconds > 0) ||
                          (_mode == TimerMode.countdown &&
                              _remainingSeconds < _initialSeconds))) ...[
                    const SizedBox(width: 16),
                    FloatingActionButton(
                      heroTag: 'timer_save_fab',
                      onPressed: _saveTime,
                      child: const Icon(Icons.save),
                    ),
                  ],
                ],
              ),
              if (_startTime != null) ...[
                const SizedBox(height: 32),
                Text(
                  'Started: ${_startTime?.toString().split('.')[0] ?? ''}',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                if (_endTime != null)
                  Text(
                    'Ended: ${_endTime?.toString().split('.')[0] ?? ''}',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
