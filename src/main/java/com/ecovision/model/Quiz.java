package com.ecovision.model;

import jakarta.persistence.*;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import com.fasterxml.jackson.annotation.JsonManagedReference;
import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "quizzes")
public class Quiz {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Título é obrigatório")
    @Column(nullable = false)
    private String titulo;

    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "conteudo_id")
    private Conteudo conteudo;

    @JsonManagedReference
    @OneToMany(mappedBy = "quiz", cascade = CascadeType.ALL, fetch = FetchType.EAGER)
    private List<Pergunta> perguntas = new ArrayList<>();

    @Column(nullable = false)
    private Integer pontosPorPergunta = 10;

    public Quiz() {}

    public Quiz(String titulo, Conteudo conteudo, Integer pontosPorPergunta) {
        this.titulo = titulo;
        this.conteudo = conteudo;
        this.pontosPorPergunta = pontosPorPergunta;
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }

    public String getTitulo() { return titulo; }
    public void setTitulo(String titulo) { this.titulo = titulo; }

    public Conteudo getConteudo() { return conteudo; }
    public void setConteudo(Conteudo conteudo) { this.conteudo = conteudo; }

    public List<Pergunta> getPerguntas() { return perguntas; }
    public void setPerguntas(List<Pergunta> perguntas) { this.perguntas = perguntas; }

    public Integer getPontosPorPergunta() { return pontosPorPergunta; }
    public void setPontosPorPergunta(Integer pontosPorPergunta) {
        this.pontosPorPergunta = pontosPorPergunta;
    }
}