import 'package:cloud_firestore/cloud_firestore.dart';

class TimerEntry {
  final String id;
  final String name;
  final String duration;
  final DateTime timestamp;
  final bool isSynced;
  final Map<String, dynamic> details;

  TimerEntry({
    required this.id,
    required this.name,
    required this.duration,
    required this.timestamp,
    this.isSynced = false,
    this.details = const {},
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'duration': duration,
      'timestamp': timestamp.toIso8601String(),
      'isSynced': isSynced,
      'details': details,
    };
  }

  factory TimerEntry.fromJson(Map<String, dynamic> json) {
    return TimerEntry(
      id: json['id'] as String,
      name: json['name'] as String,
      duration: json['duration'] as String,
      timestamp: DateTime.parse(json['timestamp'] as String),
      isSynced: json['isSynced'] as bool? ?? false,
      details: json['details'] as Map<String, dynamic>? ?? {},
    );
  }

  factory TimerEntry.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TimerEntry(
      id: doc.id,
      name: data['name'] as String,
      duration: data['duration'] as String,
      timestamp: (data['timestamp'] as Timestamp).toDate(),
      isSynced: true,
      details: data['details'] as Map<String, dynamic>? ?? {},
    );
  }

  Map<String, dynamic> toFirestore() {
    return {
      'name': name,
      'duration': duration,
      'timestamp': Timestamp.fromDate(timestamp),
      'details': details,
    };
  }

  TimerEntry copyWith({
    String? id,
    String? name,
    String? duration,
    DateTime? timestamp,
    bool? isSynced,
    Map<String, dynamic>? details,
  }) {
    return TimerEntry(
      id: id ?? this.id,
      name: name ?? this.name,
      duration: duration ?? this.duration,
      timestamp: timestamp ?? this.timestamp,
      isSynced: isSynced ?? this.isSynced,
      details: details ?? this.details,
    );
  }
}
