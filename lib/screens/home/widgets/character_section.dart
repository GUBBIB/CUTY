import 'package:flutter/material.dart';

class CharacterSection extends StatelessWidget {
  const CharacterSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Shadow
          Container(
            width: MediaQuery.of(context).size.width * 0.35,
            height: 12,
            margin: const EdgeInsets.only(bottom: 2),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.elliptical(100, 12)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 10,
                  spreadRadius: 2,
                ),
              ],
            ),
          ),
          // Character Image
          Image.asset(
            'assets/images/capy_hello.png',
            width: MediaQuery.of(context).size.width * 0.45,
            fit: BoxFit.contain,
          ),
        ],
      ),
    );
  }
}
