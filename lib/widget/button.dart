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

class ButtonDetail extends StatelessWidget {
  final String text;
  final Future<void> Function() function;
  final Future<void> Function()? function2;

  ButtonDetail(this.text, this.function, [this.function2]);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () async {
        await function();
        if (function2 != null) {
          await function2!();
        }
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
