import 'package:flutter/material.dart';

class Destination extends StatelessWidget {
  const Destination({super.key, required this.destination});

  final String destination;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(destination),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: Text(
          'Destination Page',
        ),
      ),
    );
  }
}
