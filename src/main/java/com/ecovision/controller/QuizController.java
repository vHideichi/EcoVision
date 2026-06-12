package com.ecovision.controller;

import com.ecovision.model.Pontuacao;
import com.ecovision.model.Quiz;
import com.ecovision.service.QuizService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

/**
 * Controller REST para operações de Quiz.
 * Expõe endpoints para listar quizzes, responder perguntas e registrar pontuações.
 */
@RestController
@RequestMapping("/api/quizzes")
@CrossOrigin(origins = "*")
public class QuizController {

    @Autowired
    private QuizService quizService;

    /**
     * GET /api/quizzes
     * Lista todos os quizzes disponíveis.
     */
    @GetMapping
    public ResponseEntity<List<Quiz>> listarTodos() {
        return ResponseEntity.ok(quizService.listarTodos());
    }

    /**
     * GET /api/quizzes/{id}
     * Busca quiz por ID com suas perguntas.
     */
    @GetMapping("/{id}")
    public ResponseEntity<Quiz> buscarPorId(@PathVariable Long id) {
        return ResponseEntity.ok(quizService.buscarPorId(id));
    }

    /**
     * POST /api/quizzes/{quizId}/finalizar
     * Finaliza o quiz e registra a pontuação do usuário.
     *
     * Body: {
     *   "usuarioId": 1,
     *   "acertos": 2
     * }
     */
    @PostMapping("/{quizId}/finalizar")
    public ResponseEntity<Pontuacao> finalizarQuiz(
            @PathVariable Long quizId,
            @RequestBody Map<String, Integer> dados) {

        Long usuarioId = dados.get("usuarioId").longValue();
        int acertos = dados.get("acertos");

        Pontuacao pontuacao = quizService.finalizarQuiz(usuarioId, quizId, acertos);
        return ResponseEntity.ok(pontuacao);
    }

    /**
     * GET /api/quizzes/historico/{usuarioId}
     * Retorna o histórico de quizzes realizados por um usuário.
     */
    @GetMapping("/historico/{usuarioId}")
    public ResponseEntity<List<Pontuacao>> getHistorico(@PathVariable Long usuarioId) {
        return ResponseEntity.ok(quizService.getHistoricoUsuario(usuarioId));
    }
}
