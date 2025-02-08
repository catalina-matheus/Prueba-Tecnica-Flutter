import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'circular_icon_button.dart';

class CloseButton extends StatelessWidget {
  const CloseButton({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularIconButton(
      icon: Icons.close,
      onTap: () => context.pop(),
    );
  }
}
