import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/theme_controller.dart';
import '../controllers/drawer_controller.dart';

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({Key? key, required this.currentRoute}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeController themeController = Get.find<ThemeController>();
    final AppDrawerController drawerController = Get.find<AppDrawerController>();
    final colorScheme = Theme.of(context).colorScheme;

    return Obx(() {
      final isMinimized = drawerController.isMinimized;

      return ListView(
        padding: EdgeInsets.zero,
        children: [
          _buildMenuItem(
            context,
            'Início',
            Icons.home,
            '/home',
            currentRoute,
            isMinimized,
          ),
          _buildMenuItem(
            context,
            'Calculadora de Férias',
            Icons.beach_access,
            '/calculadora-ferias',
            currentRoute,
            isMinimized,
          ),
          const Divider(),
          ListTile(
            contentPadding: EdgeInsets.symmetric(
              horizontal: isMinimized ? 8.0 : 16.0,
            ),
            leading: Obx(() => Icon(
                  themeController.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                  color: colorScheme.primary,
                )),
            title: isMinimized
                ? null
                : Obx(() => Text(
                      themeController.isDarkMode ? 'Modo Claro' : 'Modo Escuro',
                      style: TextStyle(
                        color: colorScheme.onSurface,
                      ),
                    )),
            onTap: () {
              themeController.toggleTheme();
            },
          ),
        ],
      );
    });
  }

  Widget _buildMenuItem(
    BuildContext context,
    String title,
    IconData icon,
    String route,
    String currentRoute,
    bool isMinimized,
  ) {
    final colorScheme = Theme.of(context).colorScheme;
    final isSelected = currentRoute == route;

    return ListTile(
      contentPadding: EdgeInsets.symmetric(
        horizontal: isMinimized ? 8.0 : 16.0,
      ),
      leading: Icon(
        icon,
        color: isSelected ? colorScheme.primary : colorScheme.onSurfaceVariant,
      ),
      title: isMinimized
          ? null
          : Text(
              title,
              style: TextStyle(
                color: isSelected ? colorScheme.primary : colorScheme.onSurface,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              ),
            ),
      tileColor: isSelected ? colorScheme.primaryContainer.withOpacity(0.3) : null,
      onTap: () {
        if (currentRoute != route) {
          Get.offAllNamed(route);
        }
      },
    );
  }
}
