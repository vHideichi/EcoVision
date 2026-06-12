package com.ecovision.config;

import com.ecovision.model.*;
import com.ecovision.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

/**
 * Inicializa o banco de dados com dados de exemplo ao iniciar a aplicação.
 * Permite testar as funcionalidades sem precisar inserir dados manualmente.
 */
@Component
public class DataInitializer implements CommandLineRunner {

    @Autowired private UsuarioRepository usuarioRepository;
    @Autowired private ConteudoRepository conteudoRepository;
    @Autowired private QuizRepository quizRepository;
    @Autowired private PontuacaoRepository pontuacaoRepository;

    @Override
    public void run(String... args) throws Exception {
        System.out.println("=== EcoVision: Inicializando dados de exemplo ===");

        // =============================================
        // Criando Usuários (usando Factory do Singleton de config)
        // =============================================
        Usuario usuario1 = new Usuario("Victor Suzuki", "victor@ecovision.com", "123456");
        Usuario usuario2 = new Usuario("Eduardo Vasconcellos", "eduardo@ecovision.com", "123456");
        Usuario usuario3 = new Usuario("Maria Silva", "maria@ecovision.com", "123456");
        usuarioRepository.save(usuario1);
        usuarioRepository.save(usuario2);
        usuarioRepository.save(usuario3);

        // =============================================
        // Criando Conteúdos (usando ConteudoFactory - Padrão Factory)
        // =============================================
        Conteudo ipê = ConteudoFactory.criarPlanta(
            "Ipê Amarelo",
            "O Ipê Amarelo (Handroanthus albus) é uma árvore nativa do Brasil, " +
            "símbolo nacional. Floresce nos meses de julho a setembro, " +
            "cobrindo ruas e parques com flores amarelas vibrantes. " +
            "Muito presente nos parques de Maringá.",
            "Parque do Ingá - Maringá/PR",
            "IPE001"
        );

        Conteudo araucaria = ConteudoFactory.criarPlanta(
            "Araucária",
            "A Araucária (Araucaria angustifolia) é uma conífera nativa do sul do Brasil. " +
            "Também chamada de pinheiro-do-paraná, é símbolo do estado do Paraná. " +
            "Espécie ameaçada de extinção, muito importante para o ecossistema.",
            "Parque do Ingá - Maringá/PR",
            "ARU001"
        );

        Conteudo tucanoBecoBranco = ConteudoFactory.criarAnimal(
            "Tucano-de-bico-branco",
            "O Tucano-de-bico-branco (Ramphastos tucanus) é uma ave colorida " +
            "característica da Mata Atlântica. Alimenta-se de frutos e tem papel " +
            "essencial na dispersão de sementes, ajudando na regeneração da floresta.",
            "Parque do Ingá - Maringá/PR",
            "TUC001"
        );

        Conteudo placaReciclagem = ConteudoFactory.criarPlaca(
            "Placa de Reciclagem",
            "Esta placa indica os materiais que podem ser reciclados neste local. " +
            "A reciclagem reduz o lixo em aterros, economiza energia e recursos naturais. " +
            "Em Maringá, o programa de coleta seletiva recolhe mais de 500 toneladas por mês.",
            "Parque do Ingá - Maringá/PR",
            "PLC001"
        );

        Conteudo monumento = ConteudoFactory.criarMonumento(
            "Monumento ao Café",
            "O Monumento ao Café homenageia os pioneiros que desbravaram a região " +
            "noroeste do Paraná, onde Maringá foi fundada em 1947. " +
            "A região foi uma das maiores produtoras de café do Brasil.",
            "Centro de Maringá/PR",
            "MON001"
        );

        conteudoRepository.save(ipê);
        conteudoRepository.save(araucaria);
        conteudoRepository.save(tucanoBecoBranco);
        conteudoRepository.save(placaReciclagem);
        conteudoRepository.save(monumento);

        // =============================================
        // Criando Quiz sobre o Ipê Amarelo
        // =============================================
        Quiz quizIpe = new Quiz("Quiz: Ipê Amarelo", ipê, 10);
        quizRepository.save(quizIpe);

        Pergunta p1 = new Pergunta(
            "Qual é o nome científico do Ipê Amarelo?",
            "Handroanthus albus",
            "Araucaria angustifolia",
            "Eucalyptus grandis",
            "Cedrela fissilis",
            "A", 1, quizIpe
        );

        Pergunta p2 = new Pergunta(
            "Em quais meses o Ipê Amarelo costuma florescer?",
            "Janeiro e Fevereiro",
            "Março e Abril",
            "Julho a Setembro",
            "Outubro e Novembro",
            "C", 2, quizIpe
        );

        Pergunta p3 = new Pergunta(
            "O Ipê Amarelo é nativo de qual país?",
            "Argentina",
            "Brasil",
            "Peru",
            "Colômbia",
            "B", 3, quizIpe
        );

        quizIpe.getPerguntas().add(p1);
        quizIpe.getPerguntas().add(p2);
        quizIpe.getPerguntas().add(p3);

        // Salvar quiz com perguntas (cascade salva automaticamente)
        quizRepository.save(quizIpe);

        // =============================================
        // Criando Quiz sobre Reciclagem
        // =============================================
        Quiz quizReciclagem = new Quiz("Quiz: Reciclagem e Meio Ambiente", placaReciclagem, 10);
        quizRepository.save(quizReciclagem);

        Pergunta r1 = new Pergunta(
            "Qual das alternativas representa a cor correta para lixo de papel?",
            "Vermelho",
            "Azul",
            "Verde",
            "Amarelo",
            "B", 1, quizReciclagem
        );

        Pergunta r2 = new Pergunta(
            "O que significa ODS 4, ao qual o EcoVision está alinhado?",
            "Saúde e Bem-Estar",
            "Vida Terrestre",
            "Educação de Qualidade",
            "Cidades Sustentáveis",
            "C", 2, quizReciclagem
        );

        quizReciclagem.getPerguntas().add(r1);
        quizReciclagem.getPerguntas().add(r2);
        quizRepository.save(quizReciclagem);

        // =============================================
        // Adicionando pontuações iniciais aos usuários
        // =============================================
        usuario1.adicionarPontos(50);
        usuario1.registrarScan();
        usuario1.registrarScan();
        usuarioRepository.save(usuario1);

        usuario2.adicionarPontos(30);
        usuario2.registrarScan();
        usuarioRepository.save(usuario2);

        usuario3.adicionarPontos(80);
        usuario3.registrarScan();
        usuario3.registrarScan();
        usuario3.registrarScan();
        usuarioRepository.save(usuario3);

        System.out.println("=== Dados inicializados com sucesso! ===");
        System.out.println("Conteúdos cadastrados: " + conteudoRepository.count());
        System.out.println("Usuários cadastrados: " + usuarioRepository.count());
        System.out.println("Quizzes cadastrados: " + quizRepository.count());
    }
}
