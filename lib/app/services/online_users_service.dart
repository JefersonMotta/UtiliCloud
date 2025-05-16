import 'package:get/get.dart';
import 'package:firebase_database/firebase_database.dart';

class OnlineUsersService extends GetxService {
  final RxInt onlineUsers = 0.obs;
  final DatabaseReference _ref = FirebaseDatabase.instance.ref('online_users');
  String? _userId;
  
  Future<OnlineUsersService> init() async {
    // Gerar um ID único para este usuário
    _userId = DateTime.now().millisecondsSinceEpoch.toString();
    
    // Registrar este usuário como online
    await _ref.child(_userId!).set({
      'timestamp': ServerValue.timestamp,
      'lastActive': ServerValue.timestamp
    });
    
    // Configurar para remover o usuário quando desconectar
    _ref.child(_userId!).onDisconnect().remove();
    
    // Atualizar o status a cada 30 segundos
    _startHeartbeat();
    
    // Ouvir mudanças no número de usuários online
    _ref.onValue.listen((event) {
      if (event.snapshot.exists) {
        onlineUsers.value = event.snapshot.children.length;
      } else {
        onlineUsers.value = 1; // Apenas este usuário
      }
    });
    
    return this;
  }
  
  void _startHeartbeat() {
    Future.doWhile(() async {
      if (_userId != null) {
        await _ref.child(_userId!).update({
          'lastActive': ServerValue.timestamp
        });
      }
      await Future.delayed(const Duration(seconds: 30));
      return true; // Continuar o loop
    });
  }
  
  // Limpar usuários inativos (pode ser chamado periodicamente)
  Future<void> cleanupInactiveUsers() async {
    final snapshot = await _ref.get();
    if (snapshot.exists) {
      final now = DateTime.now().millisecondsSinceEpoch;
      for (final child in snapshot.children) {
        final data = child.value as Map<dynamic, dynamic>?;
        if (data != null && data['lastActive'] != null) {
          final lastActive = data['lastActive'] as int;
          // Remover usuários inativos por mais de 5 minutos
          if (now - lastActive > 5 * 60 * 1000) {
            await _ref.child(child.key!).remove();
          }
        }
      }
    }
  }
}