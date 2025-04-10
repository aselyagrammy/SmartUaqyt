import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("About"),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "App Description",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Simple Stopwatch is a lightweight and easy-to-use timing app that allows users to measure time precisely. With its intuitive interface, users can start, stop, and reset the stopwatch with just one tap. Ideal for timing workouts, studying, or any activity where tracking time matters.",
              style: TextStyle(fontSize: 16),
            ),
            SizedBox(height: 30),
            Text(
              "Credits",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Text(
              "Developed by Askar,Alimzhan, Aselya in the scope of the course “Crossplatform Development” at Astana IT University.\n"
              "Mentor (Teacher): Assistant Professor Abzal Kyzyrkanov",
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
