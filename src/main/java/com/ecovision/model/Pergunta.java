package com.ecovision.model;

import jakarta.persistence.*;
import com.fasterxml.jackson.annotation.JsonIgnore;
import jakarta.validation.constraints.NotBlank;

@Entity
@Table(name = "perguntas")
public class Pergunta {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @NotBlank(message = "Enunciado é obrigatório")
    @Column(nullable = false, length = 500)
    private String enunciado;

    @Column(nullable = false)
    private String alternativaA;

    @Column(nullable = false)
    private String alternativaB;

    @Column(nullable = false)
    private String alternativaC;

    @Column(nullable = false)
    private String alternativaD;

    @Column(nullable = false)
    private String respostaCorreta;

    @Column(nullable = false)
    private Integer ordem = 1;

    @JsonIgnore
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "quiz_id")
    private Quiz quiz;

    public Pergunta() {}

    public Pergunta(String enunciado, String alternativaA, String alternativaB,
                    String alternativaC, String alternativaD,
                    String respostaCorreta, Integer ordem, Quiz quiz) {
        this.enunciado = enunciado;
        this.alternativaA = alternativaA;
        this.alternativaB = alternativaB;
        this.alternativaC = alternativaC;
        this.alternativaD = alternativaD;
        this.respostaCorreta = respostaCorreta;
        this.ordem = ordem;
        this.quiz = quiz;
    }

    public boolean validarResposta(String resposta) {
        if (resposta == null || resposta.isEmpty()) return false;
        return this.respostaCorreta.equalsIgnoreCase(resposta.trim());
    }

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getEnunciado() { return enunciado; }
    public void setEnunciado(String enunciado) { this.enunciado = enunciado; }
    public String getAlternativaA() { return alternativaA; }
    public void setAlternativaA(String alternativaA) { this.alternativaA = alternativaA; }
    public String getAlternativaB() { return alternativaB; }
    public void setAlternativaB(String alternativaB) { this.alternativaB = alternativaB; }
    public String getAlternativaC() { return alternativaC; }
    public void setAlternativaC(String alternativaC) { this.alternativaC = alternativaC; }
    public String getAlternativaD() { return alternativaD; }
    public void setAlternativaD(String alternativaD) { this.alternativaD = alternativaD; }
    public String getRespostaCorreta() { return respostaCorreta; }
    public void setRespostaCorreta(String respostaCorreta) { this.respostaCorreta = respostaCorreta; }
    public Integer getOrdem() { return ordem; }
    public void setOrdem(Integer ordem) { this.ordem = ordem; }
    public Quiz getQuiz() { return quiz; }
    public void setQuiz(Quiz quiz) { this.quiz = quiz; }
}