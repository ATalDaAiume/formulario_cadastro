import 'package:flutter/material.dart';
import 'package:mask_text_input_formatter/mask_text_input_formatter.dart';
import '../validators/form_validators.dart';

class CadastroScreen extends StatefulWidget {
  const CadastroScreen({super.key});

  @override
  State<CadastroScreen> createState() => _CadastroScreenState();
}

class _CadastroScreenState extends State<CadastroScreen> {
  final _formKey = GlobalKey<FormState>();
  
  bool _enviando = false;
  bool _aceitouTermos = false;
  bool _verificandoEmail = false;
  String? _erroEmailAssincrono;

  // Controllers
  final _nomeCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _cpfCtrl = TextEditingController();
  final _telefoneCtrl = TextEditingController();
  final _nascimentoCtrl = TextEditingController();
  final _senhaCtrl = TextEditingController();
  final _confirmarSenhaCtrl = TextEditingController();

  // FocusNodes
  final _nomeFocus = FocusNode();
  final _emailFocus = FocusNode();
  final _cpfFocus = FocusNode();
  final _telefoneFocus = FocusNode();
  final _nascimentoFocus = FocusNode();
  final _senhaFocus = FocusNode();
  final _confirmarSenhaFocus = FocusNode();

  // Máscaras (Requisito Bônus) - CORRIGIDAS PARA FLUTTER WEB
  final _cpfMask = MaskTextInputFormatter(mask: '###.###.###-##', filter: {"#": RegExp(r'[1-9]')});
  final _telefoneMask = MaskTextInputFormatter(mask: '(##) #####-####', filter: {"#": RegExp(r'[1-9]')});
  final _nascimentoMask = MaskTextInputFormatter(mask: '##/##/####', filter: {"#": RegExp(r'[1-9]')});

  @override
  void initState() {
    super.initState();
    // Requisito Bônus: Validação Assíncrona de Email
    _emailFocus.addListener(() {
      if (!_emailFocus.hasFocus && _emailCtrl.text.isNotEmpty) {
        _validarEmailAssincrono();
      }
    });
  }

  @override
  void dispose() {
    // IMPORTANTE: dispose() de todos os controllers e focusNodes
    _nomeCtrl.dispose();
    _emailCtrl.dispose();
    _cpfCtrl.dispose();
    _telefoneCtrl.dispose();
    _nascimentoCtrl.dispose();
    _senhaCtrl.dispose();
    _confirmarSenhaCtrl.dispose();

    _nomeFocus.dispose();
    _emailFocus.dispose();
    _cpfFocus.dispose();
    _telefoneFocus.dispose();
    _nascimentoFocus.dispose();
    _senhaFocus.dispose();
    _confirmarSenhaFocus.dispose();
    super.dispose();
  }

  Future<void> _validarEmailAssincrono() async {
    setState(() => _verificandoEmail = true);
    await Future.delayed(const Duration(seconds: 2));
    
    final emailsCadastrados = ['teste@teste.com', 'admin@admin.com'];
    
    setState(() {
      _verificandoEmail = false;
      if (emailsCadastrados.contains(_emailCtrl.text.trim())) {
        _erroEmailAssincrono = 'Email já cadastrado no sistema';
      } else {
        _erroEmailAssincrono = null;
      }
    });
    _formKey.currentState?.validate();
  }

  Future<void> _enviarFormulario() async {
    // Validação Síncrona do Form
    if (_formKey.currentState!.validate() && _aceitouTermos && _erroEmailAssincrono == null) {
      setState(() => _enviando = true);
      
      // Simula o tempo de Loading (API)
      await Future.delayed(const Duration(seconds: 2));
      
      setState(() => _enviando = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Cadastro realizado com sucesso!'), backgroundColor: Colors.green),
        );
        _mostrarDialogConfirmacao();
      }
    } else {
      if (!_aceitouTermos) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Você deve aceitar os termos de uso.'), backgroundColor: Colors.red),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Por favor, corrija os erros apontados no formulário.'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _mostrarDialogConfirmacao() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmação de Cadastro'),
        content: Text('Nome: ${_nomeCtrl.text}\nEmail: ${_emailCtrl.text}\nCPF: ${_cpfCtrl.text}\nTelefone: ${_telefoneCtrl.text}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), 
            child: const Text('Editar'),
          ),
          FilledButton(
            onPressed: () {
              Navigator.pop(context);
              _formKey.currentState?.reset();
              _nomeCtrl.clear();
              _emailCtrl.clear();
              _cpfCtrl.clear();
              _telefoneCtrl.clear();
              _nascimentoCtrl.clear();
              _senhaCtrl.clear();
              _confirmarSenhaCtrl.clear();
              setState(() => _aceitouTermos = false);
            },
            child: const Text('Confirmar'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Usuário'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _nomeCtrl,
                focusNode: _nomeFocus,
                keyboardType: TextInputType.name,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Nome Completo', prefixIcon: Icon(Icons.person)),
                validator: FormValidators.validarNome,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_emailFocus),
              ),
              const SizedBox(height: 16),
              
              TextFormField(
                controller: _emailCtrl,
                focusNode: _emailFocus,
                keyboardType: TextInputType.emailAddress,
                textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  labelText: 'Email', 
                  hintText: 'exemplo@dominio.com',
                  prefixIcon: const Icon(Icons.email),
                  suffixIcon: _verificandoEmail 
                      ? const Padding(padding: EdgeInsets.all(12.0), child: CircularProgressIndicator(strokeWidth: 2)) 
                      : null,
                ),
                validator: (val) {
                  final erroPadrao = FormValidators.validarEmail(val);
                  if (erroPadrao != null) return erroPadrao;
                  return _erroEmailAssincrono;
                },
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_cpfFocus),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _cpfCtrl,
                focusNode: _cpfFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [_cpfMask],
                decoration: const InputDecoration(labelText: 'CPF', hintText: '000.000.000-00', prefixIcon: Icon(Icons.badge)),
                validator: FormValidators.validarCPF,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_telefoneFocus),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _telefoneCtrl,
                focusNode: _telefoneFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [_telefoneMask],
                decoration: const InputDecoration(labelText: 'Telefone', hintText: '(00) 00000-0000', prefixIcon: Icon(Icons.phone)),
                validator: FormValidators.validarVazio,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_nascimentoFocus),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _nascimentoCtrl,
                focusNode: _nascimentoFocus,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                inputFormatters: [_nascimentoMask],
                decoration: const InputDecoration(labelText: 'Data de Nascimento', hintText: 'DD/MM/AAAA', prefixIcon: Icon(Icons.calendar_today)),
                validator: FormValidators.validarVazio,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_senhaFocus),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _senhaCtrl,
                focusNode: _senhaFocus,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(labelText: 'Senha', prefixIcon: Icon(Icons.lock)),
                validator: FormValidators.validarSenha,
                onFieldSubmitted: (_) => FocusScope.of(context).requestFocus(_confirmarSenhaFocus),
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _confirmarSenhaCtrl,
                focusNode: _confirmarSenhaFocus,
                obscureText: true,
                keyboardType: TextInputType.visiblePassword,
                textInputAction: TextInputAction.done,
                decoration: const InputDecoration(labelText: 'Confirmar Senha', prefixIcon: Icon(Icons.lock_outline)),
                validator: (val) => FormValidators.validarConfirmacaoSenha(val, _senhaCtrl.text),
                onFieldSubmitted: (_) => _enviarFormulario(),
              ),
              const SizedBox(height: 16),

              CheckboxListTile(
                title: const Text('Aceito os termos de uso'),
                value: _aceitouTermos,
                onChanged: (val) => setState(() => _aceitouTermos = val ?? false),
                controlAffinity: ListTileControlAffinity.leading,
                contentPadding: EdgeInsets.zero,
              ),
              const SizedBox(height: 24),

              ElevatedButton(
                onPressed: _enviando ? null : _enviarFormulario,
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  foregroundColor: Theme.of(context).colorScheme.onPrimary,
                ),
                child: _enviando 
                    ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                    : const Text('Cadastrar', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}