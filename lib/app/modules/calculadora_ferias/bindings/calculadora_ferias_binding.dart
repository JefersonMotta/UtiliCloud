import 'package:get/get.dart';

import '../controllers/calculadora_ferias_controller.dart';

class CalculadoraFeriasBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CalculadoraFeriasController>(
      () => CalculadoraFeriasController(),
    );
  }
}