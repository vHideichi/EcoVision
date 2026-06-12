package com.ecovision.repository;

import com.ecovision.model.Conteudo;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional;

/**
 * Repository para operações de banco de dados da entidade Conteudo.
 */
@Repository
public interface ConteudoRepository extends JpaRepository<Conteudo, Long> {

    /**
     * Busca conteúdo pelo código de reconhecimento (usado pelo scanner AR).
     * Complexidade: O(1) com índice no banco de dados.
     */
    Optional<Conteudo> findByCodigoReconhecimento(String codigo);

    /**
     * Busca conteúdos por tipo (PLANTA, ANIMAL, etc).
     * Organização em categorias/árvore.
     */
    List<Conteudo> findByTipo(Conteudo.TipoConteudo tipo);

    /**
     * Busca conteúdos por categoria.
     */
    List<Conteudo> findByCategoriaContainingIgnoreCase(String categoria);

    /**
     * Busca conteúdos por nome (busca parcial).
     */
    List<Conteudo> findByNomeContainingIgnoreCase(String nome);
}
