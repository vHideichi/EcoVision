import 'package:flutter/material.dart';
import '../models/models.dart';
import '../services/api_service.dart';

/// Tela de Catálogo - lista todos os elementos do EcoVision.
class CatalogoScreen extends StatefulWidget {
  const CatalogoScreen({super.key});

  @override
  State<CatalogoScreen> createState() => _CatalogoScreenState();
}

class _CatalogoScreenState extends State<CatalogoScreen> {
  List<Conteudo> _conteudos = [];
  List<Conteudo> _conteudosFiltrados = [];
  bool _carregando = true;
  final _buscaController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _carregarConteudos();
  }

  Future<void> _carregarConteudos() async {
    try {
      final conteudos = await ApiService.listarConteudos();
      if (mounted) {
        setState(() {
          _conteudos = conteudos;
          _conteudosFiltrados = conteudos;
          _carregando = false;
        });
      }
    } catch (e) {
      if (mounted) setState(() => _carregando = false);
    }
  }

  void _filtrar(String texto) {
    setState(() {
      _conteudosFiltrados = _conteudos
          .where((c) =>
              c.nome.toLowerCase().contains(texto.toLowerCase()) ||
              c.categoria.toLowerCase().contains(texto.toLowerCase()))
          .toList();
    });
  }

  String _iconeParaTipo(String tipo) {
    return switch (tipo) {
      'PLANTA' => '🌱',
      'ANIMAL' => '🦜',
      'PLACA' => '♻️',
      'MONUMENTO' => '🏛️',
      _ => '🔍',
    };
  }

  Color _corParaTipo(String tipo) {
    return switch (tipo) {
      'PLANTA' => const Color(0xFF2E7D32),
      'ANIMAL' => const Color(0xFF1565C0),
      'PLACA' => const Color(0xFF00695C),
      'MONUMENTO' => const Color(0xFF6A1B9A),
      _ => Colors.grey,
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F8E9),
      appBar: AppBar(
        title: const Text('Catálogo EcoVision'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(56),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
            child: TextField(
              controller: _buscaController,
              onChanged: _filtrar,
              decoration: InputDecoration(
                hintText: 'Buscar por nome ou categoria...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
      ),
      body: _carregando
          ? const Center(child: CircularProgressIndicator(color: Color(0xFF2E7D32)))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _conteudosFiltrados.length,
              itemBuilder: (context, index) {
                final conteudo = _conteudosFiltrados[index];
                final cor = _corParaTipo(conteudo.tipo);

                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: cor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _iconeParaTipo(conteudo.tipo),
                        style: const TextStyle(fontSize: 24),
                      ),
                    ),
                    title: Text(
                      conteudo.nome,
                      style: TextStyle(
                          fontWeight: FontWeight.bold, color: cor),
                    ),
                    subtitle: Text(
                      conteudo.categoria,
                      style:
                          const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                    childrenPadding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    children: [
                      Text(
                        conteudo.descricao,
                        style:
                            const TextStyle(height: 1.6, color: Color(0xFF424242)),
                      ),
                      if (conteudo.localizacao != null) ...[
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            const Icon(Icons.location_on,
                                color: Colors.grey, size: 16),
                            const SizedBox(width: 4),
                            Text(
                              conteudo.localizacao!,
                              style: const TextStyle(
                                  color: Colors.grey, fontSize: 13),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              },
            ),
    );
  }
}
