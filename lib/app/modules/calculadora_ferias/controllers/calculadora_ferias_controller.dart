import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class CalculadoraFeriasController extends GetxController {
  // Formatador para valores monetários
  final formatoMoeda = NumberFormat.currency(locale: 'pt_BR', symbol: 'R\$');
  
  // Controladores para os campos de texto
  final salarioBrutoController = TextEditingController();
  final horasExtrasController = TextEditingController();
  final dependentesController = TextEditingController();
  final diasFeriasController = TextEditingController(text: '30');
  
  // Variáveis observáveis
  final abonoPecuniario = false.obs;
  final adiantar13 = false.obs;
  
  // Resultados do cálculo
  final valorFerias = 0.0.obs;
  final valorTercoConstitucional = 0.0.obs;
  final valorAbono = 0.0.obs;
  final valorINSS = 0.0.obs;
  final valorIRRF = 0.0.obs;
  final valorAdiantamento13 = 0.0.obs;
  final valorLiquido = 0.0.obs;
  
  // Flag para controlar se o cálculo foi realizado
  final calculoRealizado = false.obs;
  
  // Método para calcular os valores das férias
  void calcularFerias() {
    try {
      // Obter valores dos campos
      final salarioBruto = double.parse(salarioBrutoController.text.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.'));
      final horasExtras = horasExtrasController.text.isEmpty ? 0.0 : double.parse(horasExtrasController.text.replaceAll(RegExp(r'[^\d,.]'), '').replaceAll(',', '.'));
      final dependentes = dependentesController.text.isEmpty ? 0 : int.parse(dependentesController.text);
      final diasFerias = int.parse(diasFeriasController.text);
      
      // Validar dias de férias (entre 10 e 30)
      if (diasFerias < 10 || diasFerias > 30) {
        Get.snackbar(
          'Erro',
          'Os dias de férias devem estar entre 10 e 30',
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }
      
      // Calcular valor base das férias (proporcional aos dias)
      final valorBaseDiario = salarioBruto / 30;
      final valorBaseFeriasProporcional = valorBaseDiario * diasFerias;
      
      // Adicionar valor médio de horas extras
      final valorTotalBase = valorBaseFeriasProporcional + horasExtras;
      
      // Calcular terço constitucional
      final tercoConstitucional = valorTotalBase / 3;
      
      // Calcular valor do abono pecuniário (se selecionado)
      double valorAbonoCalculado = 0.0;
      int diasAbono = 0;
      
      if (abonoPecuniario.value) {
        diasAbono = (diasFerias / 3).floor(); // 1/3 dos dias de férias
        diasAbono = diasAbono > 10 ? 10 : diasAbono; // Máximo de 10 dias
        valorAbonoCalculado = valorBaseDiario * diasAbono;
      }
      
      // Calcular valor do adiantamento do 13º (se selecionado)
      double valorAdiantamento13Calculado = 0.0;
      if (adiantar13.value) {
        valorAdiantamento13Calculado = salarioBruto / 2; // Metade do salário bruto
      }
      
      // Base para cálculo de INSS e IRRF
      final baseCalculoINSS = valorTotalBase + tercoConstitucional;
      
      // Calcular INSS (valores aproximados conforme tabela 2023)
      double valorINSSCalculado = 0.0;
      if (baseCalculoINSS <= 1320.0) {
        valorINSSCalculado = baseCalculoINSS * 0.075;
      } else if (baseCalculoINSS <= 2571.29) {
        valorINSSCalculado = 99.0 + ((baseCalculoINSS - 1320.0) * 0.09);
      } else if (baseCalculoINSS <= 3856.94) {
        valorINSSCalculado = 99.0 + 112.61 + ((baseCalculoINSS - 2571.29) * 0.12);
      } else if (baseCalculoINSS <= 7507.49) {
        valorINSSCalculado = 99.0 + 112.61 + 154.28 + ((baseCalculoINSS - 3856.94) * 0.14);
      } else {
        valorINSSCalculado = 877.24; // Teto do INSS
      }
      
      // Base para cálculo do IRRF
      final baseCalculoIRRF = baseCalculoINSS - valorINSSCalculado - (dependentes * 189.59); // Dedução por dependente
      
      // Calcular IRRF (valores aproximados conforme tabela 2023)
      double valorIRRFCalculado = 0.0;
      if (baseCalculoIRRF <= 2112.0) {
        valorIRRFCalculado = 0.0; // Isento
      } else if (baseCalculoIRRF <= 2826.65) {
        valorIRRFCalculado = (baseCalculoIRRF * 0.075) - 158.40;
      } else if (baseCalculoIRRF <= 3751.05) {
        valorIRRFCalculado = (baseCalculoIRRF * 0.15) - 370.40;
      } else if (baseCalculoIRRF <= 4664.68) {
        valorIRRFCalculado = (baseCalculoIRRF * 0.225) - 651.73;
      } else {
        valorIRRFCalculado = (baseCalculoIRRF * 0.275) - 884.96;
      }
      
      // Calcular valor líquido
      final valorLiquidoCalculado = valorTotalBase + tercoConstitucional + valorAbonoCalculado - valorINSSCalculado - valorIRRFCalculado;
      
      // Atualizar valores observáveis
      valorFerias.value = valorTotalBase;
      valorTercoConstitucional.value = tercoConstitucional;
      valorAbono.value = valorAbonoCalculado;
      valorINSS.value = valorINSSCalculado;
      valorIRRF.value = valorIRRFCalculado;
      valorAdiantamento13.value = valorAdiantamento13Calculado;
      valorLiquido.value = valorLiquidoCalculado;
      
      // Marcar que o cálculo foi realizado
      calculoRealizado.value = true;
    } catch (e) {
      Get.snackbar(
        'Erro',
        'Verifique se todos os campos estão preenchidos corretamente',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
  
  // Método para limpar os campos
  void limparCampos() {
    salarioBrutoController.clear();
    horasExtrasController.clear();
    dependentesController.clear();
    diasFeriasController.text = '30';
    abonoPecuniario.value = false;
    adiantar13.value = false;
    calculoRealizado.value = false;
  }
  
  @override
  void onClose() {
    salarioBrutoController.dispose();
    horasExtrasController.dispose();
    dependentesController.dispose();
    diasFeriasController.dispose();
    super.onClose();
  }
}