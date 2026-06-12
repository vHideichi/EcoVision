import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/models.dart';

/// Serviço responsável pela comunicação com a API do back-end EcoVision.
/// Centraliza todas as requisições HTTP ao servidor Java/Spring Boot.
class ApiService {
  // URL base da API (mudar conforme o ambiente de execução)
  // Para emulador Android: use 10.0.2.2 em vez de localhost
  static const String baseUrl = 'http://localhost:8080/api';

  // =============================================
  // Endpoints de Usuário
  // =============================================

  /// Realiza login do usuário.
  /// Retorna o usuário autenticado ou lança exceção em caso de erro.
  static Future<Usuario> login(String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'senha': senha}),
    );

    if (response.statusCode == 200) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      final erro = jsonDecode(response.body)['mensagem'] ?? 'Erro no login';
      throw Exception(erro);
    }
  }

  /// Cadastra um novo usuário.
  static Future<Usuario> cadastrar(
      String nome, String email, String senha) async {
    final response = await http.post(
      Uri.parse('$baseUrl/usuarios/cadastro'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'nome': nome, 'email': email, 'senha': senha}),
    );

    if (response.statusCode == 201) {
      return Usuario.fromJson(jsonDecode(response.body));
    } else {
      final erro =
          jsonDecode(response.body)['mensagem'] ?? 'Erro no cadastro';
      throw Exception(erro);
    }
  }

  /// Busca o ranking de usuários (ordenado por pontuação).
  static Future<List<Usuario>> getRanking() async {
    final response = await http.get(
      Uri.parse('$baseUrl/usuarios/ranking'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((u) => Usuario.fromJson(u)).toList();
    } else {
      throw Exception('Erro ao carregar ranking');
    }
  }

  /// Registra um scan realizado pelo usuário.
  static Future<void> registrarScan(int usuarioId) async {
    await http.post(Uri.parse('$baseUrl/usuarios/$usuarioId/scan'));
  }

  // =============================================
  // Endpoints de Conteúdo
  // =============================================

  /// Busca conteúdo pelo código de reconhecimento do scanner AR.
  static Future<Conteudo> buscarConteudoPorCodigo(String codigo) async {
    final response = await http.get(
      Uri.parse('$baseUrl/conteudos/scanner/$codigo'),
    );

    if (response.statusCode == 200) {
      return Conteudo.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Elemento não reconhecido');
    }
  }

  /// Lista todos os conteúdos disponíveis.
  static Future<List<Conteudo>> listarConteudos() async {
    final response = await http.get(Uri.parse('$baseUrl/conteudos'));

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((c) => Conteudo.fromJson(c)).toList();
    } else {
      throw Exception('Erro ao carregar conteúdos');
    }
  }

  // =============================================
  // Endpoints de Quiz
  // =============================================

  /// Busca um quiz pelo ID com todas as suas perguntas.
  static Future<Quiz> buscarQuiz(int quizId) async {
    final response = await http.get(
      Uri.parse('$baseUrl/quizzes/$quizId'),
    );

    if (response.statusCode == 200) {
      return Quiz.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('Quiz não encontrado');
    }
  }

  /// Lista todos os quizzes disponíveis.
  static Future<List<Quiz>> listarQuizzes() async {
    final response = await http.get(Uri.parse('$baseUrl/quizzes'));

    if (response.statusCode == 200) {
      final List<dynamic> lista = jsonDecode(response.body);
      return lista.map((q) => Quiz.fromJson(q)).toList();
    } else {
      throw Exception('Erro ao carregar quizzes');
    }
  }

  /// Finaliza um quiz e envia a pontuação para o back-end.
  static Future<void> finalizarQuiz(
      int usuarioId, int quizId, int acertos) async {
    await http.post(
      Uri.parse('$baseUrl/quizzes/$quizId/finalizar'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'usuarioId': usuarioId, 'acertos': acertos}),
    );
  }
}
