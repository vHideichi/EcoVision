package com.ecovision.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;

/**
 * Entidade Conteudo - representa um elemento reconhecível pelo EcoVision.
 * Pode ser uma planta, animal, placa ou objeto em parques/museus de Maringá.
 *
 * Padrão de Projeto aplicado: Factory Method
 * (Ver ConteudoFactory para criação de diferentes tipos)
 */
@Entity
@Table(name = "conteudos")
public class Conteudo {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Nome é obrigatório")
    @Column(nullable = false)
    private String nome;

    @NotBlank(message = "Descrição é obrigatória")
    @Column(nullable = false, length = 1000)
    private String descricao;

    // Tipo do conteúdo: PLANTA, ANIMAL, PLACA, MONUMENTO
    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private TipoConteudo tipo;

    // Categoria para organização em árvore (ex: "Flora/Árvores/Nativas")
    @Column(nullable = false)
    private String categoria;

    // Localização onde o conteúdo pode ser encontrado
    @Column
    private String localizacao;

    // URL de imagem ilustrativa (simulada para o protótipo)
    @Column
    private String urlImagem;

    // Identificador usado pelo scanner AR para reconhecimento
    @Column(unique = true)
    private String codigoReconhecimento;

    // =============================================
    // Enum para tipos de conteúdo
    // =============================================
    public enum TipoConteudo {
        PLANTA, ANIMAL, PLACA, MONUMENTO, OUTRO
    }

    // =============================================
    // Construtores
    // =============================================

    public Conteudo() {}

    public Conteudo(String nome, String descricao, TipoConteudo tipo,
                    String categoria, String localizacao, String codigoReconhecimento) {
        this.nome = nome;
        this.descricao = descricao;
        this.tipo = tipo;
        this.categoria = categoria;
        this.localizacao = localizacao;
        this.codigoReconhecimento = codigoReconhecimento;
    }

    // =============================================
    // Getters e Setters
    // =============================================

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getNome() { return nome; }
    public void setNome(String nome) { this.nome = nome; }

    public String getDescricao() { return descricao; }
    public void setDescricao(String descricao) { this.descricao = descricao; }

    public TipoConteudo getTipo() { return tipo; }
    public void setTipo(TipoConteudo tipo) { this.tipo = tipo; }

    public String getCategoria() { return categoria; }
    public void setCategoria(String categoria) { this.categoria = categoria; }

    public String getLocalizacao() { return localizacao; }
    public void setLocalizacao(String localizacao) { this.localizacao = localizacao; }

    public String getUrlImagem() { return urlImagem; }
    public void setUrlImagem(String urlImagem) { this.urlImagem = urlImagem; }

    public String getCodigoReconhecimento() { return codigoReconhecimento; }
    public void setCodigoReconhecimento(String codigoReconhecimento) {
        this.codigoReconhecimento = codigoReconhecimento;
    }
}
