import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/responsive_scaffold.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    
    return ResponsiveScaffold(
      title: 'UtiliCloud',
      currentRoute: '/home',
      actions: [
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
      drawer: AppDrawer(currentRoute: '/home'),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bem-vindo!',
              style: TextStyle(
                fontSize: 28, 
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Selecione uma ferramenta para começar:',
              style: TextStyle(
                fontSize: 16,
                color: colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: Obx(
                () => GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                    childAspectRatio: 1.2,
                  ),
                  itemCount: controller.ferramentas.length,
                  itemBuilder: (context, index) {
                    final ferramenta = controller.ferramentas[index];
                    return Card(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Get.toNamed(ferramenta['rota']!),
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              ferramenta['icone'] == 'beach_access'
                                  ? Icon(
                                      Icons.beach_access,
                                      size: 48,
                                      color: colorScheme.primary,
                                    )
                                  : Icon(
                                      Icons.build,
                                      size: 48,
                                      color: colorScheme.primary,
                                    ),
                              const SizedBox(height: 16),
                              Text(
                                ferramenta['titulo']!,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: colorScheme.onSurface,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 8),
                              Text(
                                ferramenta['descricao']!,
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
