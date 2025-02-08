import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'circular_icon_button.dart';

class BackButton extends StatelessWidget {
  const BackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      icon: Icons.arrow_back_ios_rounded,
      onTap: () => context.pop(),
    );
  }
}
