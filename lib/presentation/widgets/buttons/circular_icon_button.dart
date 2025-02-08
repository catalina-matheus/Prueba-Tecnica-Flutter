import 'package:flutter/material.dart';

// base para los otros widgets
class CircularIconButton extends StatelessWidget {
  final IconData? icon;
  final VoidCallback? onTap;
  final Widget? child;

  const CircularIconButton({
    super.key,
    this.icon,
    this.onTap,
    this.child,
  });

  @override
  Widget build(BuildContext context) {
    final double buttonSize = MediaQuery.of(context).size.width * 0.12;
    final bool isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: buttonSize.clamp(40, 60),
        height: buttonSize.clamp(40, 60),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: isDarkMode
                ? [
                    const Color.fromARGB(255, 74, 144, 226),
                    const Color.fromARGB(255, 95, 227, 143)
                  ]
                : [
                    const Color.fromARGB(255, 95, 227, 143),
                    const Color.fromARGB(255, 65, 162, 238)
                  ],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 6,
              spreadRadius: 1,
              offset: const Offset(2, 2),
            ),
          ],
        ),
        child: child ?? Icon(icon, color: Colors.white, size: buttonSize * 0.5),
      ),
    );
  }
}
