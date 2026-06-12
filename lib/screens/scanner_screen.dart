import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Tela do Scanner de Realidade Aumentada (AR).
/// No protótipo, simula o escaneamento permitindo que o usuário
/// selecione um elemento para identificar.
///
/// Em produção, esta tela usaria a câmera do dispositivo e um
/// modelo de visão computacional para reconhecimento automático.
class ScannerScreen extends StatefulWidget {
  final Usuario usuario;

  const ScannerScreen({super.key, required this.usuario});

  @override
  State<ScannerScreen> createState() => _ScannerScreenState();
}

class _ScannerScreenState extends State<ScannerScreen>
    with TickerProviderStateMixin {
  // Estado da tela
  bool _escaneando = false;
  bool _carregando = false;
  Conteudo? _conteudoEncontrado;

  // Controlador de animação do scanner
  late AnimationController _scanAnimController;
  late Animation<double> _scanAnimation;

  // Códigos de elementos disponíveis para simular o scan
  final List<Map<String, String>> _elementosDisponiveis = [
    {'codigo': 'IPE001', 'icone': '🌳', 'nome': 'Ipê Amarelo'},
    {'codigo': 'ARU001', 'icone': '🌲', 'nome': 'Araucária'},
    {'codigo': 'TUC001', 'icone': '🦜', 'nome': 'Tucano'},
    {'codigo': 'PLC001', 'icone': '♻️', 'nome': 'Placa de Reciclagem'},
    {'codigo': 'MON001', 'icone': '🏛️', 'nome': 'Monumento ao Café'},
  ];

  @override
  void initState() {
    super.initState();
    // Configura animação da linha de scan
    _scanAnimController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);

    _scanAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scanAnimController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _scanAnimController.dispose();
    super.dispose();
  }

  /// Simula o escaneamento de um elemento.
  Future<void> _escanearElemento(String codigo) async {
    setState(() {
      _escaneando = true;
      _carregando = true;
      _conteudoEncontrado = null;
    });

    try {
      // Simula delay do reconhecimento AR (1.5 segundos)
      await Future.delayed(const Duration(milliseconds: 1500));

      final conteudo = await ApiService.buscarConteudoPorCodigo(codigo);

      // Registra o scan no back-end
      if (widget.usuario.id > 0) {
        await ApiService.registrarScan(widget.usuario.id);
      }

      if (mounted) {
        setState(() {
          _conteudoEncontrado = conteudo;
          _carregando = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _escaneando = false;
          _carregando = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Elemento não reconhecido: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _reiniciarScanner() {
    setState(() {
      _escaneando = false;
      _conteudoEncontrado = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          // Área da "câmera" simulada
          Container(
            height: 300,
            width: double.infinity,
            margin: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1A1A1A),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Fundo simulando câmera (imagem de parque)
                  Container(
                    decoration: const BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF1B5E20),
                          Color(0xFF2E7D32),
                          Color(0xFF388E3C),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: const Center(
                      child: Text(
                        '📷\n🌳 🌿 🦜\n🌱 🍃 🌺',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 36),
                      ),
                    ),
                  ),

                  // Moldura do scanner
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.white.withOpacity(0.8),
                        width: 2,
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        // Cantos do scanner
                        _buildCorner(0, 0, true, true),
                        _buildCorner(0, null, true, false),
                        _buildCorner(null, 0, false, true),
                        _buildCorner(null, null, false, false),
                      ],
                    ),
                  ),

                  // Linha de scan animada
                  if (_escaneando && _carregando)
                    AnimatedBuilder(
                      animation: _scanAnimation,
                      builder: (context, child) {
                        return Positioned(
                          top: 50 + (_scanAnimation.value * 200),
                          left: (MediaQuery.of(context).size.width - 200) / 2 -
                              16,
                          child: Container(
                            width: 200,
                            height: 2,
                            decoration: const BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Color(0xFF76FF03),
                                  Colors.transparent,
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),

                  // Mensagem de status na câmera
                  Positioned(
                    bottom: 16,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.black54,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        _carregando
                            ? 'Identificando...'
                            : _conteudoEncontrado != null
                                ? '✅ Elemento identificado!'
                                : 'Aponte para um elemento natural',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          // Resultado do scan
          if (_conteudoEncontrado != null)
            _buildResultadoScan()
          else if (!_escaneando)
            _buildSeletorElementos()
          else if (_carregando)
            const Padding(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  CircularProgressIndicator(color: Color(0xFF2E7D32)),
                  SizedBox(height: 12),
                  Text(
                    'Analisando elemento...',
                    style: TextStyle(color: Color(0xFF2E7D32)),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  /// Widget do resultado do scan com informações do elemento
  Widget _buildResultadoScan() {
    final conteudo = _conteudoEncontrado!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(Icons.eco,
                            color: Color(0xFF2E7D32), size: 28),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              conteudo.nome,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF1B5E20),
                              ),
                            ),
                            Text(
                              conteudo.categoria,
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2E7D32).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          conteudo.tipo,
                          style: const TextStyle(
                            color: Color(0xFF2E7D32),
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const Divider(height: 24),
                  Text(
                    conteudo.descricao,
                    style: const TextStyle(
                      fontSize: 14,
                      height: 1.6,
                      color: Color(0xFF424242),
                    ),
                  ),
                  if (conteudo.localizacao != null) ...[
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        const Icon(Icons.location_on,
                            color: Colors.grey, size: 16),
                        const SizedBox(width: 4),
                        Text(
                          conteudo.localizacao!,
                          style:
                              const TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ],
                    ),
                  ],
                  const SizedBox(height: 16),
                  // Pontos ganhos
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFF9C4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('⭐', style: TextStyle(fontSize: 20)),
                        SizedBox(width: 8),
                        Text(
                          '+5 pontos por escanear!',
                          style: TextStyle(
                            color: Color(0xFFF57F17),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          ElevatedButton.icon(
            onPressed: _reiniciarScanner,
            icon: const Icon(Icons.camera_alt),
            label: const Text('Escanear outro elemento'),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }

  /// Seletor de elementos para simulação do scanner
  Widget _buildSeletorElementos() {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Selecione um elemento para escanear:',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: Color(0xFF2E7D32),
            ),
          ),
          const Text(
            '(Simulação do scanner AR do protótipo)',
            style: TextStyle(color: Colors.grey, fontSize: 12),
          ),
          const SizedBox(height: 12),
          ..._elementosDisponiveis.map(
            (elemento) => Card(
              margin: const EdgeInsets.only(bottom: 8),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              child: ListTile(
                leading: Text(
                  elemento['icone']!,
                  style: const TextStyle(fontSize: 28),
                ),
                title: Text(
                  elemento['nome']!,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                subtitle: Text(
                  'Código: ${elemento['codigo']}',
                  style: const TextStyle(fontSize: 12, color: Colors.grey),
                ),
                trailing: const Icon(Icons.camera_alt,
                    color: Color(0xFF2E7D32)),
                onTap: () => _escanearElemento(elemento['codigo']!),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCorner(double? top, double? bottom, bool left, bool right) {
    return Positioned(
      top: top != null ? top + 8 : null,
      bottom: bottom != null ? bottom + 8 : null,
      left: left ? 8 : null,
      right: right == false ? 8 : null,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          border: Border(
            top: top != null
                ? const BorderSide(color: Color(0xFF76FF03), width: 3)
                : BorderSide.none,
            bottom: bottom != null
                ? const BorderSide(color: Color(0xFF76FF03), width: 3)
                : BorderSide.none,
            left: left
                ? const BorderSide(color: Color(0xFF76FF03), width: 3)
                : BorderSide.none,
            right: !left
                ? const BorderSide(color: Color(0xFF76FF03), width: 3)
                : BorderSide.none,
          ),
        ),
      ),
    );
  }
}
