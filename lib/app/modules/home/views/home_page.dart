import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:utilicloud/app/widgets/module_card.dart';
import '../../../widgets/app_drawer.dart';
import '../../../widgets/responsive_scaffold.dart';
import '../../../widgets/online_users_counter.dart';
import '../controllers/home_controller.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    final isMobile = MediaQuery.of(context).size.width < 600;

    return ResponsiveScaffold(
      title: 'UtiliCloud',
      currentRoute: '/home',
      actions: [
        const OnlineUsersCounter(), // Adicione aqui o contador de usuários
        const SizedBox(width: 8),
        IconButton(
          icon: const Icon(Icons.notifications_outlined),
          onPressed: () {},
        ),
      ],
      drawer: const AppDrawer(currentRoute: '/home'),
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
            const SizedBox(height: 16),

            // Seção de módulos recentes
            if (controller.recentModules.isNotEmpty) ...[
              Text(
                'Recentes',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: controller.recentModules.length,
                  itemBuilder: (context, index) {
                    final modulo = controller.recentModules[index];
                    return Padding(
                      padding: const EdgeInsets.only(right: 12.0),
                      child: SizedBox(
                        width: 100,
                        child: ModuleCard(
                          title: modulo['titulo']!,
                          icon: modulo['icone'] == 'beach_access' ? Icons.beach_access : Icons.build,
                          onTap: () => Get.toNamed(modulo['rota']!),
                          isCompact: true,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(height: 16), // Reduzido de 24 para 16
            ],

            // Todos os módulos
            Text(
              'Todas as ferramentas',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: Obx(
                () => GridView.builder(
                  // Adicionar padding na parte inferior para evitar overflow
                  padding: const EdgeInsets.only(bottom: 16),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: isMobile ? 2 : 3,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: isMobile ? 1.0 : 1.3, // Valores menores dão mais altura
                  ),
                  itemCount: controller.ferramentas.length + 1, // +1 para o card "Em desenvolvimento"
                  itemBuilder: (context, index) {
                    if (index < controller.ferramentas.length) {
                      final ferramenta = controller.ferramentas[index];
                      
                      // Usando o ModuleCard em vez do Card padrão
                      return ModuleCard(
                        title: ferramenta['titulo']!,
                        icon: ferramenta['icone'] == 'beach_access' ? Icons.beach_access : Icons.build,
                        onTap: () {
                          Get.toNamed(ferramenta['rota']!);
                          controller.addToRecent(ferramenta);
                        },
                        isCompact: true,
                      );
                      
                    } else {
                      // Card "Em desenvolvimento" também usando ModuleCard
                      return ModuleCard(
                        title: 'Em desenvolvimento',
                        icon: Icons.construction,
                        onTap: () {},
                        color: colorScheme.surfaceVariant.withOpacity(0.5),
                        isCompact: true,
                      );
                    }
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
