import 'package:flutter/material.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/routes/app_pages.dart';
import 'app/controllers/theme_controller.dart';
import 'app/controllers/drawer_controller.dart';
import 'app/services/online_users_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Carregar variáveis de ambiente
  await dotenv.load(fileName: ".env");
  
  // Adicionar manipulador para evitar erros de teclado no modo de desenvolvimento
  FlutterError.onError = (FlutterErrorDetails details) {
    if (details.exception.toString().contains('KeyDownEvent') &&
        details.exception.toString().contains('already pressed')) {
      // Ignorar este erro específico
      return;
    }
    FlutterError.presentError(details);
  };

  // Adicione esta linha para configurar a estratégia de URL
  setUrlStrategy(PathUrlStrategy());

  // Inicializar o GetStorage
  await GetStorage.init();

  // Inicializar o Firebase
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['FIREBASE_API_KEY'] ?? '',
      authDomain: dotenv.env['FIREBASE_AUTH_DOMAIN'] ?? '',
      databaseURL: dotenv.env['FIREBASE_DATABASE_URL'] ?? '',
      projectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      storageBucket: dotenv.env['FIREBASE_STORAGE_BUCKET'] ?? '',
      messagingSenderId: dotenv.env['FIREBASE_MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['FIREBASE_APP_ID'] ?? '',
      measurementId: dotenv.env['FIREBASE_MEASUREMENT_ID'] ?? '',
    ),
  );

  // Inicializar controladores
  Get.put(ThemeController());
  Get.put(AppDrawerController());
  Get.put(OnlineUsersService().init());

  // Iniciar o aplicativo
  runApp(
    GetMaterialApp(
      title: "UtiliCloud",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
      theme: ThemeData.light(useMaterial3: true),
      darkTheme: ThemeData.dark(useMaterial3: true),
      themeMode: Get.find<ThemeController>().isDarkMode ? ThemeMode.dark : ThemeMode.light,
      debugShowCheckedModeBanner: false,
    ),
  );
}
