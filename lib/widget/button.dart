import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final String text;
  final String goToPage;

  Button(this.text, this.goToPage);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.of(context).pushNamed(goToPage);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color.fromARGB(255, 23, 96, 232),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    );
  }
}
