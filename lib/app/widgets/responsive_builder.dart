import 'package:flutter/material.dart';

enum TipoDispositivo { mobile, tablet, desktop }

class ResponsiveBuilder extends StatelessWidget {
  final Widget Function(BuildContext context, TipoDispositivo tipoDispositivo, Size tamanho) builder;

  const ResponsiveBuilder({
    Key? key,
    required this.builder,
  }) : super(key: key);

  TipoDispositivo _getTipoDispositivo(MediaQueryData mediaQuery) {
    double larguraDispositivo = mediaQuery.size.width;

    if (larguraDispositivo < 600) {
      return TipoDispositivo.mobile;
    }
    if (larguraDispositivo < 900) {
      return TipoDispositivo.tablet;
    }
    return TipoDispositivo.desktop;
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final tipoDispositivo = _getTipoDispositivo(mediaQuery);

    return builder(context, tipoDispositivo, mediaQuery.size);
  }
}
