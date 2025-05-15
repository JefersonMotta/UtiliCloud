import 'package:get/get.dart';

class HomeController extends GetxController {
  final ferramentas = [
    {
      'titulo': 'Calculadora de Férias',
      'descricao': 'Calcule valores de férias conforme a CLT',
      'icone': 'beach_access',
      'rota': '/calculadora-ferias',
    },
    // Espaço para adicionar mais ferramentas no futuro
  ].obs;
}