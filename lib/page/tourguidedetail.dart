import 'package:flutter/material.dart';

class TourGuideDetail extends StatelessWidget {
  const TourGuideDetail({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tour Guide Detail'),
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(Icons.arrow_back),
        ),
      ),
      body: const Center(
        child: Text(
          'Tour Guide Detail Page',
        ),
      ),
    );
  }
}
