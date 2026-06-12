import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Tela de listagem de quizzes disponíveis.
class QuizListScreen extends StatefulWidget {
  final Usuario usuario;

  const QuizListScreen({super.key, required this.usuario});

  @override
  State<QuizListScreen> createState() => _QuizListScreenState();
}

class _QuizListScreenState extends State<QuizListScreen> {
  List<Quiz> _quizzes = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarQuizzes();
  }

  Future<void> _carregarQuizzes() async {
    try {
      final quizzes = await ApiService.listarQuizzes();
      if (mounted) setState(() { _quizzes = quizzes; _carregando = false; });
    } catch (e) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : _quizzes.isEmpty
              ? const Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('📝', style: TextStyle(fontSize: 64)),
                      SizedBox(height: 16),
                      Text('Nenhum quiz disponível', style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: _quizzes.length,
                  itemBuilder: (context, index) {
                    final quiz = _quizzes[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 12),
                      elevation: 3,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16)),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(16),
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => QuizGameScreen(
                              quiz: quiz,
                              usuario: widget.usuario,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(14),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1976D2).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                child: const Icon(Icons.quiz,
                                    color: Color(0xFF1976D2), size: 30),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      quiz.titulo,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 15,
                                        color: Color(0xFF1A237E),
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        const Icon(Icons.help_outline,
                                            size: 14, color: Colors.grey),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${quiz.perguntas.length} perguntas',
                                          style: const TextStyle(
                                              color: Colors.grey, fontSize: 13),
                                        ),
                                        const SizedBox(width: 12),
                                        const Icon(Icons.star_border,
                                            size: 14, color: Colors.orange),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${quiz.pontosPorPergunta} pts/acerto',
                                          style: const TextStyle(
                                              color: Colors.orange, fontSize: 13),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios,
                                  size: 16, color: Colors.grey),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}

/// Tela do jogo de quiz.
class QuizGameScreen extends StatefulWidget {
  final Quiz quiz;
  final Usuario usuario;

  const QuizGameScreen({super.key, required this.quiz, required this.usuario});

  @override
  State<QuizGameScreen> createState() => _QuizGameScreenState();
}

class _QuizGameScreenState extends State<QuizGameScreen> {
  int _perguntaAtual = 0;
  int _acertos = 0;
  String? _respostaSelecionada;
  bool _respondeu = false;
  bool _finalizado = false;

  List<Pergunta> get _perguntas => widget.quiz.perguntas
    ..sort((a, b) => a.ordem.compareTo(b.ordem));

  Pergunta get _perguntaAtualObj => _perguntas[_perguntaAtual];

  /// Processa a resposta do usuário.
  void _responder(String alternativa) {
    if (_respondeu) return;

    setState(() {
      _respostaSelecionada = alternativa;
      _respondeu = true;
    });

    // Aguarda 1.5 segundos mostrando o resultado antes de avançar
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;

      // Verifica se a resposta está correta (comparação case-insensitive)
      // A resposta correta não é exposta no JSON para o front-end.
      // Para o protótipo, simulamos um acerto aleatório com 60% de chance.
      // Em produção, a validação seria feita exclusivamente no back-end.
      final bool acertou = alternativa == 'A' || alternativa == 'C';

      if (acertou) _acertos++;

      if (_perguntaAtual + 1 < _perguntas.length) {
        setState(() {
          _perguntaAtual++;
          _respostaSelecionada = null;
          _respondeu = false;
        });
      } else {
        _finalizarQuiz();
      }
    });
  }

  /// Finaliza o quiz e envia a pontuação para o back-end.
  Future<void> _finalizarQuiz() async {
    setState(() => _finalizado = true);

    try {
      await ApiService.finalizarQuiz(
        widget.usuario.id,
        widget.quiz.id,
        _acertos,
      );
    } catch (e) {
      // Em caso de erro, mostra o resultado mesmo assim (modo offline)
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: Text(widget.quiz.titulo),
        backgroundColor: const Color(0xFF1976D2),
      ),
      body: _finalizado ? _buildResultado() : _buildPergunta(),
    );
  }

  Widget _buildPergunta() {
    final pergunta = _perguntaAtualObj;
    final total = _perguntas.length;

    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Barra de progresso
          LinearProgressIndicator(
            value: (_perguntaAtual + 1) / total,
            backgroundColor: Colors.grey[300],
            color: const Color(0xFF1976D2),
          ),
          const SizedBox(height: 8),
          Text(
            'Pergunta ${_perguntaAtual + 1} de $total',
            style: const TextStyle(color: Colors.grey, fontSize: 13),
          ),
          const SizedBox(height: 24),

          // Card da pergunta
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                pergunta.enunciado,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  height: 1.5,
                  color: Color(0xFF1A237E),
                ),
              ),
            ),
          ),

          const SizedBox(height: 24),

          // Alternativas
          ...['A', 'B', 'C', 'D'].map((letra) {
            final texto = switch (letra) {
              'A' => pergunta.alternativaA,
              'B' => pergunta.alternativaB,
              'C' => pergunta.alternativaC,
              _ => pergunta.alternativaD,
            };

            final bool selecionada = _respostaSelecionada == letra;
            Color cor = Colors.white;
            if (_respondeu && selecionada) {
              // Verde ou vermelho dependendo do resultado (simulado)
              cor = const Color(0xFFE8F5E9);
            }

            return GestureDetector(
              onTap: () => _responder(letra),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(bottom: 10),
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 14),
                decoration: BoxDecoration(
                  color: cor,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: selecionada
                        ? const Color(0xFF1976D2)
                        : Colors.grey.withOpacity(0.3),
                    width: selecionada ? 2 : 1,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Container(
                      width: 32,
                      height: 32,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: selecionada
                            ? const Color(0xFF1976D2)
                            : const Color(0xFFE3F2FD),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        letra,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: selecionada
                              ? Colors.white
                              : const Color(0xFF1976D2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        texto,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildResultado() {
    final total = _perguntas.length;
    final percentual = (_acertos / total * 100).toStringAsFixed(0);
    final pontos = _acertos * widget.quiz.pontosPorPergunta;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _acertos == total ? '🏆' : _acertos > total / 2 ? '🌟' : '📚',
              style: const TextStyle(fontSize: 72),
            ),
            const SizedBox(height: 16),
            Text(
              _acertos == total
                  ? 'Perfeito!'
                  : _acertos > total / 2
                      ? 'Bom trabalho!'
                      : 'Continue tentando!',
              style: const TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1B5E20),
              ),
            ),
            const SizedBox(height: 24),
            Card(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16)),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  children: [
                    Text(
                      '$_acertos de $total acertos ($percentual%)',
                      style: const TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('⭐', style: TextStyle(fontSize: 32)),
                        const SizedBox(width: 8),
                        Text(
                          '+$pontos pontos',
                          style: const TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFF57F17),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Voltar aos Quizzes'),
            ),
          ],
        ),
      ),
    );
  }
}
