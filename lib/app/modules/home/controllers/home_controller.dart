import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class HomeController extends GetxController {
  final box = GetStorage();
  final ferramentas = [
    {
      'titulo': 'Calculadora de Férias',
      'descricao': 'Calcule valores de férias conforme a CLT',
      'icone': 'beach_access',
      'rota': '/calculadora-ferias',
    },
    // Espaço para adicionar mais ferramentas no futuro
  ].obs;
  
  final recentModules = <Map<String, String>>[].obs;
  
  @override
  void onInit() {
    super.onInit();
    loadRecentModules();
  }
  
  void loadRecentModules() {
    final recents = box.read<List>('recent_modules');
    if (recents != null) {
      recentModules.value = List<Map<String, String>>.from(
        recents.map((item) => Map<String, String>.from(item))
      );
    }
  }
  
  void addToRecent(Map<String, String> module) {
    // Remover se já existir
    recentModules.removeWhere((item) => item['rota'] == module['rota']);
    
    // Adicionar ao início
    recentModules.insert(0, module);
    
    // Manter apenas os 5 mais recentes
    if (recentModules.length > 5) {
      recentModules.removeLast();
    }
    
    // Salvar no armazenamento local
    box.write('recent_modules', recentModules);
  }
}