import 'package:flutter/material.dart';
import 'fortune_cookie_dialog.dart';

class FortuneCookieWidget extends StatelessWidget {
  const FortuneCookieWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) => const FortuneCookieDialog(),
        );
      },
      child: Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Image.asset(
          'assets/images/item_fortune_cookie.png',
          fit: BoxFit.contain,
        ),
      ),
    );
  }
}
