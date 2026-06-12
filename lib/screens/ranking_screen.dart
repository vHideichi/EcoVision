import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Tela de Ranking - exibe os usuários ordenados por pontuação.
class RankingScreen extends StatefulWidget {
  final Usuario usuario;

  const RankingScreen({super.key, required this.usuario});

  @override
  State<RankingScreen> createState() => _RankingScreenState();
}

class _RankingScreenState extends State<RankingScreen> {
  List<Usuario> _ranking = [];
  bool _carregando = true;

  @override
  void initState() {
    super.initState();
    _carregarRanking();
  }

  Future<void> _carregarRanking() async {
    try {
      final ranking = await ApiService.getRanking();
      if (mounted) setState(() { _ranking = ranking; _carregando = false; });
    } catch (e) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      body: RefreshIndicator(
        onRefresh: _carregarRanking,
        color: const Color(0xFF2E7D32),
        child: _carregando
            ? const Center(
                child: CircularProgressIndicator(color: Color(0xFFF57C00)))
            : CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          colors: [Color(0xFFF57C00), Color(0xFFFFB74D)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            '🏆 Ranking de Exploradores',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Maringá - EcoVision',
                            style: TextStyle(color: Colors.white70),
                          ),
                          const SizedBox(height: 16),
                          if (_ranking.isNotEmpty)
                            _buildTop3(),
                        ],
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) {
                        if (index >= _ranking.length) return null;
                        final usuario = _ranking[index];
                        final posicao = index + 1;
                        final ehUsuarioAtual =
                            usuario.id == widget.usuario.id;

                        return Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 4),
                          decoration: BoxDecoration(
                            color: ehUsuarioAtual
                                ? const Color(0xFFFFF9C4)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            border: ehUsuarioAtual
                                ? Border.all(
                                    color: const Color(0xFFF57C00), width: 2)
                                : null,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            leading: CircleAvatar(
                              backgroundColor:
                                  _corPosicao(posicao).withOpacity(0.15),
                              child: Text(
                                posicao <= 3
                                    ? ['🥇', '🥈', '🥉'][posicao - 1]
                                    : '#$posicao',
                                style: TextStyle(
                                  fontSize: posicao <= 3 ? 22 : 14,
                                  fontWeight: FontWeight.bold,
                                  color: _corPosicao(posicao),
                                ),
                              ),
                            ),
                            title: Row(
                              children: [
                                Text(
                                  usuario.nome,
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: ehUsuarioAtual
                                        ? const Color(0xFFF57F17)
                                        : const Color(0xFF212121),
                                  ),
                                ),
                                if (ehUsuarioAtual) ...[
                                  const SizedBox(width: 6),
                                  const Text(
                                    '(você)',
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xFFF57F17)),
                                  ),
                                ],
                              ],
                            ),
                            subtitle: Text(
                              '🔍 ${usuario.totalScans} scans realizados',
                              style: const TextStyle(fontSize: 12),
                            ),
                            trailing: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.end,
                              children: [
                                Text(
                                  '${usuario.pontuacaoTotal}',
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFFF57C00),
                                  ),
                                ),
                                const Text(
                                  'pontos',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.grey),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SliverToBoxAdapter(child: SizedBox(height: 24)),
                ],
              ),
      ),
    );
  }

  Widget _buildTop3() {
    if (_ranking.length < 3) return const SizedBox.shrink();
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        _buildPodiumItem(_ranking[1], 2, 80),
        _buildPodiumItem(_ranking[0], 1, 100),
        _buildPodiumItem(_ranking[2], 3, 80),
      ],
    );
  }

  Widget _buildPodiumItem(Usuario usuario, int posicao, double altura) {
    final medalhas = ['🥇', '🥈', '🥉'];
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(medalhas[posicao - 1], style: const TextStyle(fontSize: 28)),
        const SizedBox(height: 4),
        Text(
          usuario.nome.split(' ').first,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
        ),
        Text(
          '${usuario.pontuacaoTotal} pts',
          style: const TextStyle(color: Colors.white70, fontSize: 11),
        ),
      ],
    );
  }

  Color _corPosicao(int posicao) {
    return switch (posicao) {
      1 => const Color(0xFFFFD700),
      2 => const Color(0xFFC0C0C0),
      3 => const Color(0xFFCD7F32),
      _ => const Color(0xFF757575),
    };
  }
}
