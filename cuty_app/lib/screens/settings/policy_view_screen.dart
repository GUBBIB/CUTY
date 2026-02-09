import 'package:flutter/material.dart';

class PolicyViewScreen extends StatelessWidget {
  final String title;
  final String content;

  const PolicyViewScreen({Key? key, required this.title, required this.content}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Text(
          content,
          style: TextStyle(fontSize: 14, height: 1.5, color: Colors.grey[800]),
        ),
      ),
    );
  }
}
