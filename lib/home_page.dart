import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  final List<String> stopwatchHistory = [
    "00:45.23", "01:15.90", "00:30.00", "02:10.12", "00:59.87",
    "01:05.33", "03:40.10", "00:10.01", "00:25.67", "02:30.22",
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
  title: Text("Simple Stopwatch"),
  actions: [
    IconButton(
      icon: Icon(Icons.info_outline),
      onPressed: () {
        Navigator.pushNamed(context, '/about');
      },
    ),
  ],
),

      body: OrientationBuilder(
        builder: (context, orientation) {
          return LayoutBuilder(
            builder: (context, constraints) {
              return Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Recent Timings",
                      style: TextStyle(
                        fontSize: screenSize.width > 600 ? 28 : 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: stopwatchHistory.length,
                        itemBuilder: (context, index) {
                          return Card(
                            child: ListTile(
                              leading: Icon(Icons.timer),
                              title: Text("Session ${index + 1}"),
                              subtitle: Text("Time: ${stopwatchHistory[index]}"),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
