package com.ecovision.repository;

import com.ecovision.model.Usuario;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository para operações de banco de dados da entidade Usuario.
 * Herda operações CRUD básicas do JpaRepository.
 */
@Repository
public interface UsuarioRepository extends JpaRepository<Usuario, Long> {

    /**
     * Busca usuário pelo email (para login).
     */
    Optional<Usuario> findByEmail(String email);

    /**
     * Verifica se já existe um usuário com o email informado.
     */
    boolean existsByEmail(String email);

    /**
     * Retorna ranking dos usuários ordenados por pontuação total (decrescente).
     * Complexidade da query: O(n log n) - ordenação pelo banco de dados.
     */
    @Query("SELECT u FROM Usuario u ORDER BY u.pontuacaoTotal DESC")
    List<Usuario> findRankingUsuarios();

    /**
     * Busca usuários por nome (busca parcial, insensível a maiúsculas).
     */
    List<Usuario> findByNomeContainingIgnoreCase(String nome);
}
