import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_technical_test_catalina/config/theme/cubit/theme_cubit.dart';
import 'circular_icon_button.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDarkMode =
        context.watch<ThemeCubit>().state == ThemeModeState.dark;

    return CircularIconButton(
      child: PopupMenuButton<int>(
        onSelected: (value) {
          if (value == 0) {
            context.read<ThemeCubit>().toggleTheme();
          }
        },
        icon: const Icon(Icons.menu, color: Colors.white),
        itemBuilder: (context) => [
          PopupMenuItem(
            value: 0,
            child: Row(
              children: [
                Icon(
                  isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: isDarkMode ? Colors.white : Colors.black,
                ),
                const SizedBox(width: 10),
                Text(isDarkMode ? "Modo Claro" : "Modo Oscuro"),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
