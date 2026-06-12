/// Modelo de dados do Usuário no app Flutter.
/// Corresponde à entidade Usuario do back-end Java.
class Usuario {
  final int id;
  final String nome;
  final String email;
  final int pontuacaoTotal;
  final int totalScans;

  const Usuario({
    required this.id,
    required this.nome,
    required this.email,
    required this.pontuacaoTotal,
    required this.totalScans,
  });

  /// Cria um Usuario a partir de um Map (resposta da API em JSON).
  factory Usuario.fromJson(Map<String, dynamic> json) {
    return Usuario(
      id: json['id'] as int,
      nome: json['nome'] as String,
      email: json['email'] as String,
      pontuacaoTotal: json['pontuacaoTotal'] as int? ?? 0,
      totalScans: json['totalScans'] as int? ?? 0,
    );
  }
}

/// Modelo de dados do Conteúdo reconhecido pelo scanner AR.
class Conteudo {
  final int id;
  final String nome;
  final String descricao;
  final String tipo;
  final String categoria;
  final String? localizacao;
  final String? urlImagem;
  final String codigoReconhecimento;

  const Conteudo({
    required this.id,
    required this.nome,
    required this.descricao,
    required this.tipo,
    required this.categoria,
    this.localizacao,
    this.urlImagem,
    required this.codigoReconhecimento,
  });

  factory Conteudo.fromJson(Map<String, dynamic> json) {
    return Conteudo(
      id: json['id'] as int,
      nome: json['nome'] as String,
      descricao: json['descricao'] as String,
      tipo: json['tipo'] as String,
      categoria: json['categoria'] as String,
      localizacao: json['localizacao'] as String?,
      urlImagem: json['urlImagem'] as String?,
      codigoReconhecimento: json['codigoReconhecimento'] as String,
    );
  }
}

/// Modelo de dados de uma Pergunta do Quiz.
class Pergunta {
  final int id;
  final String enunciado;
  final String alternativaA;
  final String alternativaB;
  final String alternativaC;
  final String alternativaD;
  final int ordem;

  const Pergunta({
    required this.id,
    required this.enunciado,
    required this.alternativaA,
    required this.alternativaB,
    required this.alternativaC,
    required this.alternativaD,
    required this.ordem,
  });

  factory Pergunta.fromJson(Map<String, dynamic> json) {
    return Pergunta(
      id: json['id'] as int,
      enunciado: json['enunciado'] as String,
      alternativaA: json['alternativaA'] as String,
      alternativaB: json['alternativaB'] as String,
      alternativaC: json['alternativaC'] as String,
      alternativaD: json['alternativaD'] as String,
      ordem: json['ordem'] as int,
    );
  }
}

/// Modelo de dados do Quiz.
class Quiz {
  final int id;
  final String titulo;
  final int pontosPorPergunta;
  final List<Pergunta> perguntas;

  const Quiz({
    required this.id,
    required this.titulo,
    required this.pontosPorPergunta,
    required this.perguntas,
  });

  factory Quiz.fromJson(Map<String, dynamic> json) {
    final perguntasJson = json['perguntas'] as List? ?? [];
    return Quiz(
      id: json['id'] as int,
      titulo: json['titulo'] as String,
      pontosPorPergunta: json['pontosPorPergunta'] as int? ?? 10,
      perguntas: perguntasJson
          .map((p) => Pergunta.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }
}

/// Modelo de dados de uma entrada do Ranking.
class RankingEntry {
  final int posicao;
  final String nome;
  final int pontuacaoTotal;
  final int totalScans;

  const RankingEntry({
    required this.posicao,
    required this.nome,
    required this.pontuacaoTotal,
    required this.totalScans,
  });
}
