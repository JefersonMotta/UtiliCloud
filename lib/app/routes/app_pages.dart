import 'package:get/get.dart';

import '../modules/calculadora_ferias/bindings/calculadora_ferias_binding.dart';
import '../modules/calculadora_ferias/views/calculadora_ferias_page.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_page.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.CALCULADORA_FERIAS,
      page: () => const CalculadoraFeriasPage(),
      binding: CalculadoraFeriasBinding(),
    ),
  ];
}
