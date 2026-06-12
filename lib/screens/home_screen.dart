import 'package:flutter/material.dart';
import '../models/models.dart';
import 'scanner_screen.dart';
import 'quiz_screen.dart';
import 'ranking_screen.dart';
import 'catalogo_screen.dart';

/// Tela principal (Home) do EcoVision.
/// Apresenta o painel do usuário e acesso às funcionalidades.
class HomeScreen extends StatefulWidget {
  final Usuario usuario;

  const HomeScreen({super.key, required this.usuario});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _abaSelecionada = 0;

  /// Lista de abas da barra de navegação inferior
  late final List<Widget> _telas;

  @override
  void initState() {
    super.initState();
    _telas = [
      _buildPainelHome(),
      ScannerScreen(usuario: widget.usuario),
      QuizListScreen(usuario: widget.usuario),
      RankingScreen(usuario: widget.usuario),
    ];
  }

  /// Constrói o painel principal da tela Home
  Widget _buildPainelHome() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card de boas-vindas
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF2E7D32), Color(0xFF81C784)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF2E7D32).withOpacity(0.3),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const CircleAvatar(
                      backgroundColor: Colors.white,
                      radius: 28,
                      child: Icon(Icons.person,
                          color: Color(0xFF2E7D32), size: 32),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Olá, explorador! 🌿',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                          Text(
                            widget.usuario.nome,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Row(
                  children: [
                    _buildStatCard(
                      '⭐ ${widget.usuario.pontuacaoTotal}',
                      'Pontos',
                    ),
                    const SizedBox(width: 12),
                    _buildStatCard(
                      '🔍 ${widget.usuario.totalScans}',
                      'Scans',
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          const Text(
            'Explorar Maringá 🌳',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1B5E20),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Descubra a natureza ao seu redor',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 16),

          // Grid de funcionalidades
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard(
                icon: Icons.camera_alt,
                titulo: 'Scanner AR',
                descricao: 'Escaneie elementos da natureza',
                cor: const Color(0xFF43A047),
                onTap: () => setState(() => _abaSelecionada = 1),
              ),
              _buildFeatureCard(
                icon: Icons.quiz,
                titulo: 'Quizzes',
                descricao: 'Teste seus conhecimentos',
                cor: const Color(0xFF1976D2),
                onTap: () => setState(() => _abaSelecionada = 2),
              ),
              _buildFeatureCard(
                icon: Icons.leaderboard,
                titulo: 'Ranking',
                descricao: 'Veja os melhores exploradores',
                cor: const Color(0xFFF57C00),
                onTap: () => setState(() => _abaSelecionada = 3),
              ),
              _buildFeatureCard(
                icon: Icons.book,
                titulo: 'Catálogo',
                descricao: 'Explore nossa biblioteca',
                cor: const Color(0xFF7B1FA2),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CatalogoScreen()),
                ),
              ),
            ],
          ),

          const SizedBox(height: 24),

          // Dica do dia
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFF81C784)),
            ),
            child: const Row(
              children: [
                Text('🌱', style: TextStyle(fontSize: 32)),
                SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Dica do Dia',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2E7D32),
                          fontSize: 15,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'O Parque do Ingá em Maringá possui mais de 680 espécies de plantas. Vá explorar!',
                        style: TextStyle(
                          color: Color(0xFF388E3C),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String valor, String label) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.2),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Text(
              valor,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureCard({
    required IconData icon,
    required String titulo,
    required String descricao,
    required Color cor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: cor.withOpacity(0.15),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
          border: Border.all(color: cor.withOpacity(0.2)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: cor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: cor, size: 28),
            ),
            const SizedBox(height: 10),
            Text(
              titulo,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: cor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              descricao,
              style: const TextStyle(
                color: Colors.grey,
                fontSize: 11,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.eco, color: Colors.white),
            SizedBox(width: 8),
            Text('EcoVision'),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => Navigator.pushReplacementNamed(context, '/login'),
            tooltip: 'Sair',
          ),
        ],
      ),
      body: IndexedStack(
        index: _abaSelecionada,
        children: _telas,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _abaSelecionada,
        onDestinationSelected: (index) =>
            setState(() => _abaSelecionada = index),
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE8F5E9),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home, color: Color(0xFF2E7D32)),
            label: 'Início',
          ),
          NavigationDestination(
            icon: Icon(Icons.camera_alt_outlined),
            selectedIcon: Icon(Icons.camera_alt, color: Color(0xFF2E7D32)),
            label: 'Scanner',
          ),
          NavigationDestination(
            icon: Icon(Icons.quiz_outlined),
            selectedIcon: Icon(Icons.quiz, color: Color(0xFF2E7D32)),
            label: 'Quiz',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard, color: Color(0xFF2E7D32)),
            label: 'Ranking',
          ),
        ],
      ),
    );
  }
}
