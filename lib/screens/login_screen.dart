import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/models.dart';
import 'home_screen.dart';

/// Tela de Login do EcoVision.
/// Permite que o usuário entre com email e senha ou acesse como convidado.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Controladores dos campos de texto
  final _emailController = TextEditingController();
  final _senhaController = TextEditingController();

  // Estado de carregamento
  bool _carregando = false;
  bool _mostrarSenha = false;

  @override
  void dispose() {
    _emailController.dispose();
    _senhaController.dispose();
    super.dispose();
  }

  /// Realiza o login chamando a API do back-end.
  Future<void> _fazerLogin() async {
    final email = _emailController.text.trim();
    final senha = _senhaController.text.trim();

    if (email.isEmpty || senha.isEmpty) {
      _mostrarMensagem('Preencha email e senha', Colors.orange);
      return;
    }

    setState(() => _carregando = true);

    try {
      final usuario = await ApiService.login(email, senha);
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomeScreen(usuario: usuario),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        _mostrarMensagem(e.toString().replaceAll('Exception: ', ''),
            Colors.red);
      }
    } finally {
      if (mounted) setState(() => _carregando = false);
    }
  }

  /// Acessa o app como convidado (sem login).
  void _acessarComoConvidado() {
    // Cria usuário convidado para demonstração
    const convidado = Usuario(
      id: 0,
      nome: 'Visitante',
      email: 'visitante@ecovision.com',
      pontuacaoTotal: 0,
      totalScans: 0,
    );
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => HomeScreen(usuario: convidado)),
    );
  }

  void _mostrarMensagem(String mensagem, Color cor) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(mensagem),
        backgroundColor: cor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 40),

              // Logo e título
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  color: const Color(0xFF2E7D32),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF2E7D32).withOpacity(0.3),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.eco,
                  color: Colors.white,
                  size: 56,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'EcoVision',
                style: TextStyle(
                  fontSize: 36,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B5E20),
                ),
              ),

              const Text(
                'Educação Ambiental com Realidade Aumentada',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF558B2F),
                ),
              ),

              const SizedBox(height: 48),

              // Card de login
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      const Text(
                        'Entrar',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Campo de email
                      TextField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.email_outlined,
                              color: Color(0xFF2E7D32)),
                          hintText: 'seu@email.com',
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Campo de senha
                      TextField(
                        controller: _senhaController,
                        obscureText: !_mostrarSenha,
                        decoration: InputDecoration(
                          labelText: 'Senha',
                          prefixIcon: const Icon(Icons.lock_outlined,
                              color: Color(0xFF2E7D32)),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _mostrarSenha
                                  ? Icons.visibility_off
                                  : Icons.visibility,
                              color: const Color(0xFF2E7D32),
                            ),
                            onPressed: () =>
                                setState(() => _mostrarSenha = !_mostrarSenha),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Botão de login
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _carregando ? null : _fazerLogin,
                          child: _carregando
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Text(
                                  'Entrar',
                                  style: TextStyle(fontSize: 16),
                                ),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Botão de convidado
                      SizedBox(
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: _acessarComoConvidado,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF2E7D32),
                            side: const BorderSide(
                                color: Color(0xFF2E7D32), width: 1.5),
                            padding: const EdgeInsets.symmetric(vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Entrar como Visitante',
                            style: TextStyle(fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Dica de acesso rápido para teste
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF81C784)),
                ),
                child: const Column(
                  children: [
                    Text(
                      '💡 Usuário de teste:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E7D32),
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Email: victor@ecovision.com\nSenha: 123456',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 13,
                        color: Color(0xFF388E3C),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
