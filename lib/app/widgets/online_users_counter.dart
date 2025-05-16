import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../services/online_users_service.dart';
import 'responsive_builder.dart';

class OnlineUsersCounter extends StatelessWidget {
  const OnlineUsersCounter({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final onlineService = Get.find<OnlineUsersService>();
    final colorScheme = Theme.of(context).colorScheme;
    
    return ResponsiveBuilder(
      builder: (context, tipoDispositivo, tamanho) {
        final isMobile = tipoDispositivo == TipoDispositivo.mobile;
        
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: isMobile ? 8 : 12, 
            vertical: isMobile ? 4 : 6
          ),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.people_alt_outlined,
                size: isMobile ? 14 : 16,
                color: colorScheme.primary,
              ),
              SizedBox(width: isMobile ? 4 : 6),
              Obx(() => Text(
                isMobile ? '${onlineService.onlineUsers.value}' : '${onlineService.onlineUsers.value} online',
                style: TextStyle(
                  fontSize: isMobile ? 10 : 12,
                  fontWeight: FontWeight.bold,
                  color: colorScheme.primary,
                ),
              )),
            ],
          ),
        );
      },
    );
  }
}