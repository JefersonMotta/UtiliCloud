import 'package:flutter/material.dart';

class ModuleCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final VoidCallback onTap;
  final Color? color;
  final bool isCompact;

  const ModuleCard({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
    this.color,
    this.isCompact = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cardColor = color ?? theme.colorScheme.primaryContainer;
    
    return Card(
      elevation: 2,
      color: cardColor,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(isCompact ? 8.0 : 16.0), // Reduzido o padding
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // Importante: ajusta ao conteúdo
            children: [
              Icon(
                icon,
                size: isCompact ? 24.0 : 40.0, // Reduzido o tamanho do ícone
                color: theme.colorScheme.onPrimaryContainer,
              ),
              SizedBox(height: isCompact ? 4.0 : 12.0), // Reduzido o espaçamento
              Flexible( // Adicionado Flexible para permitir que o texto se ajuste
                child: Text(
                  title,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: isCompact ? 12.0 : 14.0, // Reduzido o tamanho da fonte
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onPrimaryContainer,
                  ),
                  maxLines: 2, // Limita a 2 linhas
                  overflow: TextOverflow.ellipsis, // Adiciona "..." se não couber
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}