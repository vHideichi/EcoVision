package com.ecovision;

import com.ecovision.exception.BusinessException;
import com.ecovision.exception.ResourceNotFoundException;
import com.ecovision.model.*;
import com.ecovision.repository.*;
import com.ecovision.service.*;
import org.junit.jupiter.api.*;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;

import java.util.Arrays;
import java.util.List;
import java.util.Optional;
import java.util.Queue;

import static org.junit.jupiter.api.Assertions.*;
import static org.mockito.ArgumentMatchers.*;
import static org.mockito.Mockito.*;

/**
 * Testes Unitários do EcoVision - Metodologia TDD
 *
 * Estes testes validam as principais regras de negócio do sistema:
 * 1. Cadastro de usuário (email único)
 * 2. Login com credenciais válidas/inválidas
 * 3. Adição de pontos (só valores positivos)
 * 4. Validação de respostas do quiz
 * 5. Finalização do quiz e cálculo de pontuação
 * 6. Busca de conteúdo por código de scanner
 * 7. Ordenação do ranking de usuários
 *
 * Framework: JUnit 5 com Mockito para simular repositórios
 */
@ExtendWith(MockitoExtension.class)
@DisplayName("Testes Unitários - EcoVision")
class EcoVisionApplicationTests {

    // =============================================
    // Testes de Usuario
    // =============================================

    @Nested
    @DisplayName("Testes de Usuário")
    class UsuarioTests {

        @Mock
        private UsuarioRepository usuarioRepository;

        @InjectMocks
        private UsuarioService usuarioService;

        @Test
        @DisplayName("Deve cadastrar usuário com sucesso quando email não existe")
        void deveCadastrarUsuarioComSucesso() {
            // Arrange (preparar)
            Usuario novoUsuario = new Usuario("Victor", "victor@test.com", "123456");
            when(usuarioRepository.existsByEmail("victor@test.com")).thenReturn(false);
            when(usuarioRepository.save(any(Usuario.class))).thenReturn(novoUsuario);

            // Act (executar)
            Usuario resultado = usuarioService.cadastrar(novoUsuario);

            // Assert (verificar)
            assertNotNull(resultado, "Usuário cadastrado não deve ser nulo");
            assertEquals("Victor", resultado.getNome());
            assertEquals("victor@test.com", resultado.getEmail());
            verify(usuarioRepository).save(novoUsuario);
        }

        @Test
        @DisplayName("Deve lançar exceção ao cadastrar usuário com email já existente")
        void deveLancarExcecaoEmailDuplicado() {
            // Arrange
            Usuario usuarioExistente = new Usuario("Victor", "victor@test.com", "123456");
            when(usuarioRepository.existsByEmail("victor@test.com")).thenReturn(true);

            // Act & Assert
            BusinessException excecao = assertThrows(
                    BusinessException.class,
                    () -> usuarioService.cadastrar(usuarioExistente),
                    "Deve lançar BusinessException para email duplicado"
            );
            assertTrue(excecao.getMessage().contains("Email já cadastrado"));
        }

        @Test
        @DisplayName("Deve realizar login com credenciais corretas")
        void deveRealizarLoginComSucesso() {
            // Arrange
            Usuario usuario = new Usuario("Eduardo", "edu@test.com", "senha123");
            when(usuarioRepository.findByEmail("edu@test.com"))
                    .thenReturn(Optional.of(usuario));

            // Act
            Usuario logado = usuarioService.login("edu@test.com", "senha123");

            // Assert
            assertNotNull(logado);
            assertEquals("Eduardo", logado.getNome());
        }

        @Test
        @DisplayName("Deve lançar exceção ao fazer login com senha incorreta")
        void deveLancarExcecaoSenhaIncorreta() {
            // Arrange
            Usuario usuario = new Usuario("Eduardo", "edu@test.com", "senhaCorreta");
            when(usuarioRepository.findByEmail("edu@test.com"))
                    .thenReturn(Optional.of(usuario));

            // Act & Assert
            BusinessException excecao = assertThrows(
                    BusinessException.class,
                    () -> usuarioService.login("edu@test.com", "senhaErrada")
            );
            assertEquals("Senha incorreta", excecao.getMessage());
        }

        @Test
        @DisplayName("Deve lançar exceção ao fazer login com email não cadastrado")
        void deveLancarExcecaoEmailNaoEncontrado() {
            // Arrange
            when(usuarioRepository.findByEmail(anyString())).thenReturn(Optional.empty());

            // Act & Assert
            assertThrows(
                    BusinessException.class,
                    () -> usuarioService.login("naoexiste@test.com", "123456")
            );
        }

        @Test
        @DisplayName("Deve adicionar pontos positivos ao usuário com sucesso")
        void deveAdicionarPontosComSucesso() {
            // Arrange
            Usuario usuario = new Usuario("Victor", "v@test.com", "123456");
            usuario.setPontuacaoTotal(50);

            // Act
            usuario.adicionarPontos(30);

            // Assert
            assertEquals(80, usuario.getPontuacaoTotal(),
                    "Pontuação deve ser 50 + 30 = 80");
        }

        @Test
        @DisplayName("Deve lançar exceção ao tentar adicionar pontos negativos ou zero")
        void deveLancarExcecaoPontosNegativos() {
            // Arrange
            Usuario usuario = new Usuario("Victor", "v@test.com", "123456");

            // Act & Assert - pontos negativos
            assertThrows(
                    IllegalArgumentException.class,
                    () -> usuario.adicionarPontos(-10),
                    "Deve rejeitar pontos negativos"
            );

            // Assert - pontos zero
            assertThrows(
                    IllegalArgumentException.class,
                    () -> usuario.adicionarPontos(0),
                    "Deve rejeitar zero pontos"
            );
        }

        @Test
        @DisplayName("Deve retornar ranking com usuários ordenados por pontuação")
        void deveRetornarRankingOrdenado() {
            // Arrange
            Usuario u1 = new Usuario("Maria", "maria@test.com", "123");
            u1.setPontuacaoTotal(100);
            Usuario u2 = new Usuario("João", "joao@test.com", "123");
            u2.setPontuacaoTotal(50);
            Usuario u3 = new Usuario("Ana", "ana@test.com", "123");
            u3.setPontuacaoTotal(200);

            when(usuarioRepository.findRankingUsuarios())
                    .thenReturn(Arrays.asList(u3, u1, u2));

            // Act
            List<Usuario> ranking = usuarioService.getRanking();

            // Assert
            assertEquals(3, ranking.size());
            assertEquals(200, ranking.get(0).getPontuacaoTotal(), "Primeiro deve ter mais pontos");
            assertEquals(100, ranking.get(1).getPontuacaoTotal());
            assertEquals(50, ranking.get(2).getPontuacaoTotal(), "Último deve ter menos pontos");
        }

        @Test
        @DisplayName("Deve lançar exceção ao buscar usuário por ID inexistente")
        void deveLancarExcecaoUsuarioNaoEncontrado() {
            // Arrange
            when(usuarioRepository.findById(999L)).thenReturn(Optional.empty());

            // Act & Assert
            assertThrows(
                    ResourceNotFoundException.class,
                    () -> usuarioService.buscarPorId(999L)
            );
        }
    }

    // =============================================
    // Testes de Pergunta (validação de respostas)
    // =============================================

    @Nested
    @DisplayName("Testes de Validação de Respostas")
    class PerguntaTests {

        private Pergunta pergunta;

        @BeforeEach
        void setUp() {
            pergunta = new Pergunta(
                    "Qual é a cor do Ipê Amarelo?",
                    "Roxo", "Azul", "Amarelo", "Verde",
                    "C", 1, null
            );
        }

        @Test
        @DisplayName("Deve retornar verdadeiro para resposta correta")
        void deveValidarRespostaCorreta() {
            assertTrue(pergunta.validarResposta("C"), "Alternativa C é a correta");
        }

        @Test
        @DisplayName("Deve ser insensível a maiúsculas/minúsculas")
        void deveIgnorarMaiusculas() {
            assertTrue(pergunta.validarResposta("c"), "Deve aceitar 'c' minúsculo");
            assertTrue(pergunta.validarResposta("C"), "Deve aceitar 'C' maiúsculo");
        }

        @Test
        @DisplayName("Deve retornar falso para resposta incorreta")
        void deveRejeitarRespostaErrada() {
            assertFalse(pergunta.validarResposta("A"), "A não é a resposta correta");
            assertFalse(pergunta.validarResposta("B"), "B não é a resposta correta");
            assertFalse(pergunta.validarResposta("D"), "D não é a resposta correta");
        }

        @Test
        @DisplayName("Deve retornar falso para resposta nula ou vazia")
        void deveRejeitarRespostaNulaOuVazia() {
            assertFalse(pergunta.validarResposta(null), "Deve rejeitar null");
            assertFalse(pergunta.validarResposta(""), "Deve rejeitar string vazia");
        }
    }

    // =============================================
    // Testes de Pontuação
    // =============================================

    @Nested
    @DisplayName("Testes de Pontuação")
    class PontuacaoTests {

        @Test
        @DisplayName("Deve calcular percentual de acertos corretamente")
        void deveCalcularPercentualAcertos() {
            // Arrange: cria quiz simples para teste
            Quiz quiz = new Quiz();
            quiz.setPontosPorPergunta(10);

            Usuario usuario = new Usuario("Teste", "t@test.com", "123");

            // Simula 3 acertos em 5 perguntas
            Pontuacao pontuacao = new Pontuacao();
            pontuacao.setAcertos(3);
            pontuacao.setTotalPerguntas(5);
            pontuacao.setPontosObtidos(30);

            // Act
            double percentual = pontuacao.calcularPercentualAcertos();

            // Assert
            assertEquals(60.0, percentual, 0.01, "3/5 = 60%");
        }

        @Test
        @DisplayName("Deve retornar zero quando não houver perguntas")
        void deveRetornarZeroSemPerguntas() {
            Pontuacao pontuacao = new Pontuacao();
            pontuacao.setAcertos(0);
            pontuacao.setTotalPerguntas(0);
            pontuacao.setPontosObtidos(0);

            assertEquals(0.0, pontuacao.calcularPercentualAcertos());
        }
    }

    // =============================================
    // Testes de Conteúdo
    // =============================================

    @Nested
    @DisplayName("Testes de Conteúdo")
    class ConteudoTests {

        @Mock
        private com.ecovision.repository.ConteudoRepository conteudoRepository;

        @InjectMocks
        private ConteudoService conteudoService;

        @Test
        @DisplayName("Deve encontrar conteúdo pelo código de reconhecimento")
        void deveEncontrarConteudoPorCodigo() {
            // Arrange
            Conteudo conteudo = new Conteudo("Ipê Amarelo", "Árvore nativa",
                    Conteudo.TipoConteudo.PLANTA, "Flora/Plantas", "Parque do Ingá", "IPE001");

            when(conteudoRepository.findByCodigoReconhecimento("IPE001"))
                    .thenReturn(Optional.of(conteudo));

            // Act
            Conteudo resultado = conteudoService.buscarPorCodigo("IPE001");

            // Assert
            assertNotNull(resultado);
            assertEquals("Ipê Amarelo", resultado.getNome());
            assertEquals(Conteudo.TipoConteudo.PLANTA, resultado.getTipo());
        }

        @Test
        @DisplayName("Deve lançar exceção para código de scanner não reconhecido")
        void deveLancarExcecaoCodigoNaoEncontrado() {
            // Arrange
            when(conteudoRepository.findByCodigoReconhecimento("INVALIDO"))
                    .thenReturn(Optional.empty());

            // Act & Assert
            assertThrows(
                    ResourceNotFoundException.class,
                    () -> conteudoService.buscarPorCodigo("INVALIDO"),
                    "Deve lançar exceção para código desconhecido"
            );
        }
    }
}
