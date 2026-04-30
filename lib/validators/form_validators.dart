class FormValidators {
  static String? validarVazio(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Este campo é obrigatório';
    }
    return null;
  }

  static String? validarNome(String? value) {
    if (value == null || value.trim().length < 3) {
      return 'O nome deve ter pelo menos 3 caracteres';
    }
    return null;
  }

  static String? validarEmail(String? value) {
    final vazio = validarVazio(value);
    if (vazio != null) return vazio;
    
    if (!value!.contains('@') || !value.contains('.')) {
      return 'Insira um email válido com @ e domínio';
    }
    return null;
  }

  static String? validarCPF(String? value) {
    final vazio = validarVazio(value);
    if (vazio != null) return vazio;
    
    // Remove os caracteres da máscara para contar só os números
    final numeros = value!.replaceAll(RegExp(r'[^0-9]'), '');
    if (numeros.length != 11) {
      return 'O CPF deve conter 11 dígitos';
    }
    return null;
  }

  static String? validarSenha(String? value) {
    if (value == null || value.length < 6) {
      return 'A senha deve ter pelo menos 6 caracteres';
    }
    return null;
  }

  static String? validarConfirmacaoSenha(String? value, String senha) {
    if (value != senha) {
      return 'As senhas não coincidem';
    }
    return null;
  }
}