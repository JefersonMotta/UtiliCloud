import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drawer_controller.dart' as app_drawer;

enum TipoDispositivo { mobile, tablet, desktop }

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final String currentRoute;
  final Widget Function(BuildContext, TipoDispositivo, Widget)? bodyBuilder;

  const ResponsiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.drawer,
    this.floatingActionButton,
    required this.currentRoute,
    this.bodyBuilder,
  }) : super(key: key);

  TipoDispositivo _getTipoDispositivo(MediaQueryData mediaQuery) {
    double larguraDispositivo = mediaQuery.size.width;

    if (larguraDispositivo < 600) {
      return TipoDispositivo.mobile;
    }
    if (larguraDispositivo < 900) {
      return TipoDispositivo.tablet;
    }
    return TipoDispositivo.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final tipoDispositivo = _getTipoDispositivo(mediaQuery);
    final drawerController = Get.find<app_drawer.AppDrawerController>();

    // Widget do corpo principal, que pode ser personalizado pelo bodyBuilder
    Widget mainBody = bodyBuilder != null ? bodyBuilder!(context, tipoDispositivo, body) : body;

    return Obx(() {
      final drawerState = drawerController.drawerState;

      // Se o drawer estiver oculto, retorna um Scaffold normal
      if (drawerState == 2) {
        return Scaffold(
          appBar: AppBar(
            title: Text(title),
            centerTitle: true,
            actions: [
              ...?actions,
              IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => drawerController.setDrawerState(0),
              ),
            ],
          ),
          body: Row(
            children: [
              // Indicador de drawer oculto
              GestureDetector(
                onTap: () => drawerController.setDrawerState(0),
                child: Container(
                  width: 20,
                  height: double.infinity,
                  color: Colors.transparent,
                  child: Center(
                    child: Container(
                      width: 5,
                      height: 50,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary.withOpacity(0.3),
                        borderRadius: const BorderRadius.horizontal(right: Radius.circular(5)),
                      ),
                      child: const Icon(Icons.chevron_right, size: 5),
                    ),
                  ),
                ),
              ),
              Expanded(child: mainBody),
            ],
          ),
          floatingActionButton: floatingActionButton,
        );
      }

      // Se o drawer estiver minimizado ou expandido
      return Scaffold(
        body: Row(
          children: [
            // Drawer lateral
            if (drawerState == 0 || drawerState == 1)
              GestureDetector(
                onHorizontalDragEnd: (details) {
                  if (details.primaryVelocity! < 0) {
                    // Deslizou para a esquerda
                    if (drawerState == 0) {
                      drawerController.setDrawerState(1);
                    } else if (drawerState == 1) {
                      drawerController.setDrawerState(2);
                    }
                  } else if (details.primaryVelocity! > 0) {
                    // Deslizou para a direita
                    if (drawerState == 1) {
                      drawerController.setDrawerState(0);
                    } else if (drawerState == 2) {
                      drawerController.setDrawerState(1);
                    }
                  }
                },
                onTap: () {
                  // Alternar entre expandido e minimizado ao clicar
                  if (drawerState == 0) {
                    drawerController.setDrawerState(1);
                  } else if (drawerState == 1) {
                    drawerController.setDrawerState(0);
                  }
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: drawerState == 0 ? 250 : 70,
                  child: Drawer(
                    child: Column(
                      children: [
                        DrawerHeader(
                          padding: EdgeInsets.symmetric(
                            horizontal: drawerState == 0 ? 16.0 : 8.0,
                            vertical: 16.0,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(Icons.cloud, size: 40),
                              if (drawerState == 0) const SizedBox(height: 8),
                              if (drawerState == 0)
                                const Text(
                                  'UtiliCloud',
                                  style: TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                            ],
                          ),
                        ),
                        Expanded(
                          child: drawer ?? Container(),
                        ),
                        const Divider(),
                        // Botão para alternar o estado do drawer
                        ListTile(
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
                          leading: Icon(
                            drawerState == 0 ? Icons.chevron_left : Icons.chevron_right,
                          ),
                          title: drawerState == 0 ? const Text('Recolher menu') : null,
                          onTap: () {
                            if (drawerState == 0) {
                              drawerController.setDrawerState(1);
                            } else {
                              drawerController.setDrawerState(0);
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            // Conteúdo principal
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  centerTitle: true,
                  // Remover o botão de menu quando o drawer estiver visível
                  leading: drawerState == 0 || drawerState == 1 
                      ? null  // Sem botão quando o drawer está visível
                      : IconButton(
                          icon: const Icon(Icons.menu),
                          onPressed: () => drawerController.setDrawerState(0),
                        ),
                  actions: actions,
                ),
                body: mainBody,
                floatingActionButton: floatingActionButton,
              ),
            ),
          ],
        ),
      );
    });
  }
}
