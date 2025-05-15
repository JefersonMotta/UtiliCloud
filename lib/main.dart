import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'app/routes/app_pages.dart';
import 'app/controllers/theme_controller.dart';
import 'app/controllers/drawer_controller.dart';

void main() {
  // Adicione esta linha para configurar a estratégia de URL
  setUrlStrategy(PathUrlStrategy());
  
  // Registra os controladores
  Get.put(ThemeController());
  Get.put(AppDrawerController(), permanent: true);
  
  runApp(
    GetMaterialApp(
      title: "UtiliCloud",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true, // Ativa o Material 3
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true, // Ativa o Material 3 para o tema escuro
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system, // Segue o tema do sistema
    ),
  );
}
