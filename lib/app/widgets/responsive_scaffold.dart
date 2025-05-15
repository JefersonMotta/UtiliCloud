import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/drawer_controller.dart' as app_drawer;

class ResponsiveScaffold extends StatelessWidget {
  final String title;
  final Widget body;
  final List<Widget>? actions;
  final Widget? drawer;
  final Widget? floatingActionButton;
  final String currentRoute;
  
  const ResponsiveScaffold({
    Key? key,
    required this.title,
    required this.body,
    this.actions,
    this.drawer,
    this.floatingActionButton,
    required this.currentRoute,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final drawerController = Get.find<app_drawer.AppDrawerController>();
    
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
          body: body,
          floatingActionButton: floatingActionButton,
        );
      }
      
      // Se o drawer estiver minimizado ou expandido
      return Scaffold(
        body: Row(
          children: [
            // Drawer lateral
            if (drawerState == 0 || drawerState == 1)
              AnimatedContainer(
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
                            if (drawerState == 0) 
                              const SizedBox(height: 8),
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
                      Divider(),
                      ListTile(
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: drawerState == 0 ? 16.0 : 8.0,
                        ),
                        leading: Icon(
                          drawerState == 0 
                              ? Icons.chevron_left 
                              : Icons.chevron_right
                        ),
                        title: drawerState == 0 
                            ? const Text('Recolher menu') 
                            : null,
                        onTap: () {
                          if (drawerState == 0) {
                            drawerController.setDrawerState(1);
                          } else {
                            drawerController.setDrawerState(0);
                          }
                        },
                      ),
                      if (drawerState == 0)
                        ListTile(
                          leading: const Icon(Icons.visibility_off),
                          title: const Text('Ocultar menu'),
                          onTap: () => drawerController.setDrawerState(2),
                        ),
                    ],
                  ),
                ),
              ),
            
            // Conteúdo principal
            Expanded(
              child: Scaffold(
                appBar: AppBar(
                  title: Text(title),
                  centerTitle: true,
                  actions: actions,
                ),
                body: body,
                floatingActionButton: floatingActionButton,
              ),
            ),
          ],
        ),
      );
    });
  }
}