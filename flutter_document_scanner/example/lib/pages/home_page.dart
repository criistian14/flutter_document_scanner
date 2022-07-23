import 'package:flutter/material.dart';
import 'package:flutter_document_scanner_example/pages/basic_page.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // * Basic example page
              ElevatedButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (BuildContext context) => const BasicPage(),
                  ),
                ),
                child: const Text(
                  'Basic example',
                ),
              ),

              // * Custom example page
              ElevatedButton(
                onPressed: () => Navigator.push<void>(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const BasicPage(),
                  ),
                ),
                child: const Text(
                  'Basic example',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
