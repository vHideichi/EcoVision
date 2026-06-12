package com.ecovision.repository;

import com.ecovision.model.Pontuacao;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository para operações de banco de dados da entidade Pontuacao.
 */
@Repository
public interface PontuacaoRepository extends JpaRepository<Pontuacao, Long> {

    /**
     * Busca histórico de pontuações de um usuário, ordenadas por data.
     */
    List<Pontuacao> findByUsuarioIdOrderByDataRealizacaoDesc(Long usuarioId);

    /**
     * Busca pontuações de um quiz específico.
     */
    List<Pontuacao> findByQuizIdOrderByPontosObtidosDesc(Long quizId);

    /**
     * Soma total de pontos de um usuário (para validação/auditoria).
     */
    @Query("SELECT COALESCE(SUM(p.pontosObtidos), 0) FROM Pontuacao p WHERE p.usuario.id = :usuarioId")
    Integer somarPontosPorUsuario(Long usuarioId);
}
