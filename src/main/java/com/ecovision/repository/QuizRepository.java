package com.ecovision.repository;

import com.ecovision.model.Quiz;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

/**
 * Repository para operações de banco de dados da entidade Quiz.
 */
@Repository
public interface QuizRepository extends JpaRepository<Quiz, Long> {

    /**
     * Busca quizzes associados a um conteúdo específico.
     */
    List<Quiz> findByConteudoId(Long conteudoId);
}
