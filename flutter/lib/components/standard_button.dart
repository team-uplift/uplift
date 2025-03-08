import 'package:flutter/material.dart';

class StandardButton extends StatelessWidget {
  final String title;
  final VoidCallback? onPressed;

  const StandardButton({
    super.key,
    required this.title,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.all(Radius.circular(10))
        ),
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        
        child: Text(
          title.toUpperCase(),
          style: const TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}
