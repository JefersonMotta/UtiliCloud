part of 'app_pages.dart';

abstract class Routes {
  Routes._();
  static const HOME = _Paths.HOME;
  static const CALCULADORA_FERIAS = _Paths.CALCULADORA_FERIAS;
}

abstract class _Paths {
  _Paths._();
  static const HOME = '/home';
  static const CALCULADORA_FERIAS = '/calculadora-ferias';
}