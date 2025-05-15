import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppDrawerController extends GetxController {
  // 0 = aberto, 1 = minimizado, 2 = oculto
  final _drawerState = 0.obs;
  
  int get drawerState => _drawerState.value;
  
  bool get isExpanded => _drawerState.value == 0;
  bool get isMinimized => _drawerState.value == 1;
  bool get isHidden => _drawerState.value == 2;
  
  @override
  void onInit() {
    super.onInit();
    _loadDrawerState();
  }
  
  Future<void> _loadDrawerState() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _drawerState.value = prefs.getInt('drawerState') ?? 0;
  }
  
  Future<void> toggleDrawerState() async {
    // Ciclo entre os estados: aberto -> minimizado -> oculto -> aberto
    _drawerState.value = (_drawerState.value + 1) % 3;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('drawerState', _drawerState.value);
  }
  
  Future<void> setDrawerState(int state) async {
    if (state >= 0 && state <= 2) {
      _drawerState.value = state;
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setInt('drawerState', _drawerState.value);
    }
  }
}