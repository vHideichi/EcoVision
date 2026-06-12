package com.ecovision.service;

import com.ecovision.exception.ResourceNotFoundException;
import com.ecovision.model.Conteudo;
import com.ecovision.repository.ConteudoRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.List;

/**
 * Serviço responsável pelas regras de negócio relacionadas ao Conteúdo.
 * Gerencia o catálogo de elementos reconhecíveis pelo scanner AR.
 *
 * Estrutura de dados: os conteúdos são organizados em categorias hierárquicas
 * (ex: Flora/Plantas, Fauna/Animais), simulando uma estrutura de árvore.
 */
@Service
public class ConteudoService {

    @Autowired
    private ConteudoRepository conteudoRepository;

    /**
     * Busca um conteúdo pelo código de reconhecimento do scanner AR.
     * Esta é a operação principal do app: ao escanear, o app envia o código
     * e recebe as informações do elemento identificado.
     *
     * Complexidade: O(1) com índice no banco de dados.
     *
     * @param codigo código retornado pelo scanner AR
     * @return conteúdo correspondente
     * @throws ResourceNotFoundException se o código não for encontrado
     */
    public Conteudo buscarPorCodigo(String codigo) {
        return conteudoRepository.findByCodigoReconhecimento(codigo)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Conteúdo não encontrado para o código: " + codigo));
    }

    /**
     * Busca conteúdo por ID.
     *
     * @param id identificador do conteúdo
     * @return conteúdo encontrado
     */
    public Conteudo buscarPorId(Long id) {
        return conteudoRepository.findById(id)
                .orElseThrow(() -> new ResourceNotFoundException(
                        "Conteúdo não encontrado com id: " + id));
    }

    /**
     * Lista conteúdos por tipo (PLANTA, ANIMAL, etc).
     * Permite navegação por categorias, como uma árvore de conteúdo.
     *
     * @param tipo tipo do conteúdo
     * @return lista de conteúdos do tipo especificado
     */
    public List<Conteudo> listarPorTipo(Conteudo.TipoConteudo tipo) {
        return conteudoRepository.findByTipo(tipo);
    }

    /**
     * Lista todos os conteúdos cadastrados.
     *
     * @return lista de todos os conteúdos
     */
    public List<Conteudo> listarTodos() {
        return conteudoRepository.findAll();
    }

    /**
     * Busca conteúdos por nome (busca parcial).
     * Algoritmo: busca linear com filtro SQL LIKE.
     * Complexidade: O(n)
     *
     * @param nome texto para busca
     * @return lista de conteúdos que correspondem à busca
     */
    public List<Conteudo> buscarPorNome(String nome) {
        return conteudoRepository.findByNomeContainingIgnoreCase(nome);
    }

    /**
     * Cadastra um novo conteúdo no sistema.
     *
     * @param conteudo dados do conteúdo
     * @return conteúdo salvo
     */
    public Conteudo salvar(Conteudo conteudo) {
        return conteudoRepository.save(conteudo);
    }
}
