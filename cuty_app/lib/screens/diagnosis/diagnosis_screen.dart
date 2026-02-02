import 'package:flutter/material.dart';
import 'consulting_screen.dart';

class DiagnosisScreen extends StatelessWidget {
  const DiagnosisScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text("This screen is deprecated."),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const ConsultingScreen()),
                );
              },
              child: const Text("Go to New Diagnosis"),
            ),
          ],
        ),
      ),
    );
  }
}
