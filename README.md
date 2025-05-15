## Sobre o Projeto
UtiliCloud é uma plataforma moderna de ferramentas online, calculadoras e utilitários práticos desenvolvida para facilitar sua rotina. Construída com Flutter, a plataforma oferece uma experiência rápida, segura e responsiva tanto em dispositivos móveis quanto na web.

## Funcionalidades Principais
- Calculadora de Férias : Calcule seus direitos de férias conforme a CLT, incluindo valores de abono pecuniário e adiantamento do 13º salário.
- Interface Adaptável : Menu lateral com 3 níveis de visualização (expandido, minimizado ou oculto).
- Tema Personalizável : Alterne entre tema claro e escuro conforme sua preferência.
- Persistência de Configurações : Suas preferências de tema e layout são salvas automaticamente.
## Tecnologias Utilizadas
- Flutter : Framework para desenvolvimento multiplataforma
- GetX : Gerenciamento de estado e navegação
- Material Design 3 : Interface moderna e responsiva
- Shared Preferences : Armazenamento local de configurações
## Como Executar o Projeto
### Pré-requisitos
- Flutter SDK (versão 3.2.0 ou superior)
- Dart SDK (versão 3.2.0 ou superior)
- Git
### Passos para Execução
1. Clone o repositório:
```
git clone https://github.com/JefersonMotta/utilicloud.git
```
2. Navegue até a pasta do projeto:
```
cd utilicloud
```
3. Instale as dependências:
```
flutter pub get
```
4. Execute o aplicativo:
```
flutter run
```
Para executar na web:

```
flutter run -d chrome
```
## Estrutura do Projeto
O projeto segue a arquitetura MVC com GetX:

- lib/app/controllers/ : Controladores da aplicação
- lib/app/modules/ : Módulos da aplicação (cada ferramenta)
- lib/app/routes/ : Configuração de rotas
- lib/app/widgets/ : Widgets reutilizáveis
- lib/main.dart : Ponto de entrada da aplicação
## Contribuição
Contribuições são bem-vindas! Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature ( git checkout -b feature/nova-calculadora )
3. Faça commit das suas alterações ( git commit -m 'Adiciona nova calculadora' )
4. Faça push para a branch ( git push origin feature/nova-calculadora )
5. Abra um Pull Request
## Licença
Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para mais detalhes.

## Contato
Para dúvidas ou sugestões, entre em contato através do email: [ jefersonmotta@jbwconnect.com ]

Desenvolvido em Flutter e GetX.