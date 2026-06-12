package com.ecovision.service;

import com.ecovision.exception.BusinessException;
import com.ecovision.exception.ResourceNotFoundException;
import com.ecovision.model.*;
import com.ecovision.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.ArrayDeque;
import java.util.List;
import java.util.Queue;

/**
 * Serviço responsável pelas regras de negócio do Quiz.
 *
 * Estrutura de dados: utiliza FILA (Queue/ArrayDeque) para controlar
 * a ordem de apresentação das perguntas. A fila garante que as perguntas
 * sejam apresentadas na ordem correta (FIFO: primeiro a entrar, primeiro a sair).
 *
 * Complexidade das operações de fila:
 * - Enfileirar (offer): O(1)
 * - Desenfileirar (poll): O(1)
 * - Verificar frente (peek): O(1)
 */
@Service
public class QuizService {

    @Autowired
    private QuizRepository quizRepository;

    @Autowired
    private PontuacaoRepository pontuacaoRepository;

    @Autowired
    private UsuarioRepository usuarioRepository;

    /**
     * Busca quiz por ID.
     *
     * @param id identificador do quiz
     * @return quiz encontrado
     */
    public Quiz buscarPorId(Long id) {
        return quizRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Quiz não encontrado com id: " + id));
    }

    /**
     * Lista todos os quizzes disponíveis.
     *
     * @return lista de quizzes
     */
    public List<Quiz> listarTodos() {
        return quizRepository.findAll();
    }

    /**
     * Retorna as perguntas de um quiz organizadas em fila (ordem correta).
     * Demonstra o uso da estrutura de dados FILA.
     *
     * @param quizId ID do quiz
     * @return fila de perguntas ordenadas
     */
    public Queue<Pergunta> montarFilaDePerguntas(Long quizId) {
        Quiz quiz = buscarPorId(quizId);

        // Cria a fila e adiciona as perguntas em ordem
        Queue<Pergunta> filaPerguntass = new ArrayDeque<>();

        // Ordena por ordem antes de enfileirar
        quiz.getPerguntas().stream()
                .sorted((a, b) -> a.getOrdem() - b.getOrdem())
                .forEach(filaPerguntass::offer); // offer = enfileirar

        return filaPerguntass;
    }

    /**
     * Processa a resposta do usuário a uma pergunta do quiz.
     * Valida a resposta e retorna se está correta.
     *
     * @param pergunta  pergunta respondida
     * @param resposta  letra da alternativa escolhida pelo usuário
     * @return true se a resposta estiver correta
     */
    public boolean validarResposta(Pergunta pergunta, String resposta) {
        if (resposta == null || resposta.trim().isEmpty()) {
            throw new BusinessException("Resposta não pode ser vazia");
        }
        return pergunta.validarResposta(resposta);
    }

    /**
     * Finaliza um quiz e registra a pontuação do usuário.
     *
     * @param usuarioId     ID do usuário
     * @param quizId        ID do quiz
     * @param acertos       número de respostas corretas
     * @return pontuação registrada
     */
    public Pontuacao finalizarQuiz(Long usuarioId, Long quizId, int acertos) {
        Usuario usuario = usuarioRepository.findById(usuarioId)
                .orElseThrow(() -> new ResourceNotFoundException("Usuário não encontrado"));

        Quiz quiz = buscarPorId(quizId);
        int totalPerguntas = quiz.getPerguntas().size();

        if (acertos < 0 || acertos > totalPerguntas) {
            throw new BusinessException("Número de acertos inválido: " + acertos);
        }

        // Cria o registro de pontuação
        Pontuacao pontuacao = new Pontuacao(usuario, quiz, acertos, totalPerguntas);
        pontuacaoRepository.save(pontuacao);

        // Atualiza a pontuação total do usuário
        if (pontuacao.getPontosObtidos() > 0) {
            usuario.adicionarPontos(pontuacao.getPontosObtidos());
            usuarioRepository.save(usuario);
        }

        return pontuacao;
    }

    /**
     * Retorna o histórico de pontuações de um usuário.
     *
     * @param usuarioId ID do usuário
     * @return lista de pontuações ordenadas por data (mais recente primeiro)
     */
    public List<Pontuacao> getHistoricoUsuario(Long usuarioId) {
        return pontuacaoRepository.findByUsuarioIdOrderByDataRealizacaoDesc(usuarioId);
    }
}
