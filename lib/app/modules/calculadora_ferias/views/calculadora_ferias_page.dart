import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../widgets/app_drawer.dart';
import '../../../widgets/responsive_scaffold.dart';
import '../controllers/calculadora_ferias_controller.dart';

class CalculadoraFeriasPage extends GetView<CalculadoraFeriasController> {
  const CalculadoraFeriasPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return ResponsiveScaffold(
      title: 'Calculadora de Férias',
      currentRoute: '/calculadora-ferias',
      actions: [
        IconButton(
          icon: const Icon(Icons.help_outline),
          onPressed: () {
            // Mostrar ajuda
          },
        ),
      ],
      drawer: const AppDrawer(currentRoute: '/calculadora-ferias'),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Cabeçalho
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Icon(
                      Icons.beach_access,
                      size: 40,
                      color: colorScheme.onPrimaryContainer,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Calculadora de Férias',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: colorScheme.onPrimaryContainer,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Preencha os dados para calcular suas férias conforme a CLT',
                            style: TextStyle(
                              fontSize: 14,
                              color: colorScheme.onPrimaryContainer.withOpacity(0.8),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Formulário
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Informações Salariais',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.salarioBrutoController,
                        decoration: const InputDecoration(
                          labelText: 'Salário Bruto (R\$) *',
                          hintText: 'Ex: 2500,00',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.horasExtrasController,
                        decoration: const InputDecoration(
                          labelText: 'Valor médio de horas extras no ano (R\$)',
                          hintText: 'Ex: 200,00',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: const TextInputType.numberWithOptions(decimal: true),
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.dependentesController,
                        decoration: const InputDecoration(
                          labelText: 'Número de dependentes',
                          hintText: 'Ex: 2',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: controller.diasFeriasController,
                        decoration: const InputDecoration(
                          labelText: 'Dias de férias (10 a 30) *',
                          hintText: 'Ex: 30',
                          border: OutlineInputBorder(),
                        ),
                        keyboardType: TextInputType.number,
                        inputFormatters: [
                          FilteringTextInputFormatter.digitsOnly,
                        ],
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Campo obrigatório';
                          }
                          final dias = int.tryParse(value);
                          if (dias == null || dias < 10 || dias > 30) {
                            return 'Deve estar entre 10 e 30 dias';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      Obx(() => CheckboxListTile(
                            title: const Text('Abono Pecuniário (vender 1/3 das férias)'),
                            subtitle: const Text('Máximo de 10 dias'),
                            value: controller.abonoPecuniario.value,
                            onChanged: (value) => controller.abonoPecuniario.value = value!,
                            controlAffinity: ListTileControlAffinity.leading,
                          )),
                      Obx(() => CheckboxListTile(
                            title: const Text('Adiantar 1ª parcela do 13º salário'),
                            value: controller.adiantar13.value,
                            onChanged: (value) => controller.adiantar13.value = value!,
                            controlAffinity: ListTileControlAffinity.leading,
                          )),
                      const SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          FilledButton.tonal(
                            onPressed: controller.limparCampos,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.clear),
                                SizedBox(width: 8),
                                Text('Limpar'),
                              ],
                            ),
                          ),
                          FilledButton(
                            onPressed: controller.calcularFerias,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.calculate),
                                SizedBox(width: 8),
                                Text('Calcular'),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Resultados do cálculo
              Obx(() => Visibility(
                    visible: controller.calculoRealizado.value,
                    child: Card(
                      color: colorScheme.secondaryContainer,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.attach_money,
                                  color: colorScheme.onSecondaryContainer,
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  'Resultado do Cálculo:',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: colorScheme.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                            Divider(color: colorScheme.onSecondaryContainer.withOpacity(0.2)),
                            const SizedBox(height: 10),
                            _buildResultRow('Valor das Férias:', controller.valorFerias.value),
                            _buildResultRow('1/3 Constitucional:', controller.valorTercoConstitucional.value),
                            Visibility(
                              visible: controller.valorAbono.value > 0,
                              child: _buildResultRow('Abono Pecuniário:', controller.valorAbono.value),
                            ),
                            const Divider(),
                            _buildResultRow('Descontos INSS:', controller.valorINSS.value, isDeduction: true),
                            _buildResultRow('Descontos IRRF:', controller.valorIRRF.value, isDeduction: true),
                            const Divider(),
                            _buildResultRow('Valor Líquido a Receber:', controller.valorLiquido.value, isTotal: true),
                            Visibility(
                              visible: controller.valorAdiantamento13.value > 0,
                              child: Column(
                                children: [
                                  const Divider(),
                                  _buildResultRow('Adiantamento 13º Salário:', controller.valorAdiantamento13.value,
                                      isHighlighted: true),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )),

              // Novo card com a descrição do cálculo
              Obx(() => Visibility(
                    visible: controller.calculoRealizado.value,
                    child: Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Card(
                        color: colorScheme.tertiaryContainer,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.info_outline,
                                    color: colorScheme.onTertiaryContainer,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Como o cálculo é feito:',
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: colorScheme.onTertiaryContainer,
                                    ),
                                  ),
                                ],
                              ),
                              Divider(color: colorScheme.onTertiaryContainer.withOpacity(0.2)),
                              const SizedBox(height: 10),
                              Text(
                                '• O valor base das férias é calculado proporcionalmente aos dias de férias solicitados (salário ÷ 30 × dias de férias).',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Adiciona-se 1/3 do valor base como adicional constitucional (garantido por lei).',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Visibility(
                                    visible: controller.abonoPecuniario.value,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• O abono pecuniário (venda de férias) é calculado sobre até 1/3 dos dias de férias, limitado a 10 dias.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onTertiaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )),
                              Text(
                                '• Descontos de INSS são aplicados conforme a tabela vigente sobre o valor das férias + 1/3.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                '• Descontos de IRRF consideram a base de cálculo (férias + 1/3 - INSS) e as deduções por dependentes.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Obx(() => Visibility(
                                    visible: controller.adiantar13.value,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          '• O adiantamento da 1ª parcela do 13º salário corresponde a 50% do salário bruto.',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: colorScheme.onTertiaryContainer,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                      ],
                                    ),
                                  )),
                              Text(
                                'Observação: Este cálculo é uma estimativa baseada na legislação trabalhista brasileira vigente. Para valores exatos, consulte um profissional especializado.',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontStyle: FontStyle.italic,
                                  color: colorScheme.onTertiaryContainer,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildResultRow(String label, double value,
      {bool isDeduction = false, bool isTotal = false, bool isHighlighted = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontWeight: isTotal || isHighlighted ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isHighlighted ? Colors.blue[800] : null,
            ),
          ),
          Text(
            controller.formatoMoeda.format(value),
            style: TextStyle(
              fontWeight: isTotal || isHighlighted ? FontWeight.bold : FontWeight.normal,
              fontSize: isTotal ? 16 : 14,
              color: isDeduction
                  ? Colors.red
                  : isHighlighted
                      ? Colors.blue[800]
                      : isTotal
                          ? Colors.green[800]
                          : null,
            ),
          ),
        ],
      ),
    );
  }
}
