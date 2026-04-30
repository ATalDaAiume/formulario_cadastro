![Atividade](https://img.shields.io/badge/Atividade-Flutter-blue)
![Dart](https://img.shields.io/badge/Linguagem-Dart-00b4ab)

# 📝 Formulário de Cadastro Completo
> Resolução de Atividade Prática — Aula 10 | Análise e Desenvolvimento de Sistemas | 5ª Fase

**Aluna:** Eloize Aiume de Liz Pereira | **Turma:** 5ª Fase — Análise e Desenvolvimento de Sistemas (2026/1)

Repositório criado para armazenar o projeto completo da atividade prática da Aula 10 da disciplina de **Desenvolvimento para Dispositivos Móveis**, da Faculdade Senac Joinville.

---

## 📚 Descrição do Aplicativo e seu Objetivo

Este aplicativo é um **Formulário de Cadastro de Usuário** completo e interativo construído inteiramente em Flutter. O objetivo principal da aplicação é aplicar e demonstrar o domínio sobre os conceitos de formulários avançados, validação síncrona e assíncrona, gerenciamento inteligente de foco e feedback visual.

O projeto cumpre todos os requisitos obrigatórios e bônus exigidos pela atividade, focando na criação de uma interface robusta, livre de erros de compilação (inclusive adaptada para Web) e com uma excelente experiência do usuário (UX), simulando de perto um ambiente real de produção.

---

## ✨ Funcionalidades e Validações Implementadas

Conforme exigido pelos critérios de avaliação, as seguintes funcionalidades foram aplicadas:

- [x] **1. Form e GlobalKey:** Utilização do widget `Form` englobando todos os campos e uma `GlobalKey<FormState>` para acionar a validação simultânea de todo o formulário.
- [x] **2. Oito Campos com Validação:** Implementados os campos obrigatórios (Nome, Email, CPF, Telefone, Data de Nascimento, Senha, Confirmação de Senha e Checkbox de Termos de Uso) utilizando `TextFormField` com os `keyboardType` apropriados.
- [x] **3. FocusNode e Gerenciamento de Foco:** Navegação inteligente implementada. O uso de `textInputAction: TextInputAction.next` em conjunto com `onFieldSubmitted` direciona ativamente o foco ao próximo campo. O `dispose()` de todos os controladores foi feito corretamente para evitar vazamento de memória.
- [x] **4. Validadores Customizados:** Lógica de validação componentizada num arquivo separado (`form_validators.dart`). Inclui validação de campos vazios, verificação de padrão de e-mail (presença de `@` e domínio), verificação de 11 dígitos numéricos do CPF, tamanho de senha e igualdade da confirmação.
- [x] **5. SnackBar para Feedback:** Feedback visual imediato com barra inferior verde indicando sucesso ou vermelha indicando erros de preenchimento ou falta de aceite dos termos.
- [x] **6. Estado de Loading (API Simulada):** Utilização da variável booleana `_enviando` para mostrar um `CircularProgressIndicator` no botão "Cadastrar" e desabilitar cliques múltiplos durante o tempo de resposta simulado (`Future.delayed`).
- [x] **🌟 Requisito Bônus 1 (Validação Assíncrona):** Verificação ativa quando o foco sai do campo de e-mail (`addListener`). O app simula uma busca e acusa se o e-mail inserido já estiver registrado, exibindo um carregamento interativo no `suffixIcon`.
- [x] **🌟 Requisito Bônus 2 (Máscara de Entrada):** Uso do pacote `mask_text_input_formatter` (corrigido com Regex compatível com a Web) para aplicar a máscara visual automaticamente nos campos de CPF (`XXX.XXX.XXX-XX`) e Telefone (`(XX) XXXXX-XXXX`).
- [x] **🌟 Requisito Bônus 3 (Dialog de Confirmação):** Finalizando o fluxo com sucesso, é apresentado um `AlertDialog` contendo o resumo dos dados cadastrados e os botões de ação 'Editar' (voltar) e 'Confirmar' (limpar form).

---

## 🛠️ Tecnologias Utilizadas
- Framework Flutter
- Linguagem Dart
- Pacote `mask_text_input_formatter` (Requisito Bônus)
- IDE: VS Code
