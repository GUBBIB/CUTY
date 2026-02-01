import 'package:flutter/material.dart';

class CharacterSection extends StatelessWidget {
  const CharacterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Image.asset(
        'assets/images/capy_hello.png',
        width: MediaQuery.of(context).size.width * 0.32,
        fit: BoxFit.contain,
      ),
    );
  }
}
